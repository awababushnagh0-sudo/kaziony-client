import 'package:admin/core/record/record_form.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

typedef Note = ({String title, String? body});

/// The saved note; [reload] stands in for it changing on the server.
class NoteViewModel extends AsyncViewModel<Note> {
  static var saved = (title: 'Hello', body: null) as Note;

  @override
  Future<Note> build() async => saved;

  void reload(Note note) => state = AsyncData(note);
}

final noteProvider = AsyncNotifierProvider.autoDispose<NoteViewModel, Note>(
  NoteViewModel.new,
);

class NoteForm extends RecordForm<Note> {
  final submitted = <Note>[];
  Result<Note>? result;

  @override
  AsyncNotifierProvider<NoteViewModel, Note> get record => noteProvider;

  @override
  Map<String, AbstractControl<Object?>> fields() => {
    'title': FormControl<String>(validators: [Validators.required]),
    'body': FormControl<String>(),
  };

  @override
  Map<String, Object?> valuesOf(Note note) => {
    'title': note.title,
    'body': note.body,
  };

  @override
  Future<Result<Note>> submit() async {
    final note = (title: text('title')!, body: text('body'));
    submitted.add(note);
    return result ?? Ok(note);
  }
}

final noteFormProvider =
    NotifierProvider.autoDispose<NoteForm, RecordFormState>(NoteForm.new);

void main() {
  late ProviderContainer container;
  NoteForm form() => container.read(noteFormProvider.notifier);
  RecordFormState state() => container.read(noteFormProvider);

  /// Lets the form hear about the edit (it arrives asynchronously).
  Future<void> edit(String field, String value) async {
    form().form.control(field).value = value;
    await Future<void>.delayed(Duration.zero);
  }

  setUp(() async {
    NoteViewModel.saved = (title: 'Hello', body: null);
    container = ProviderContainer();
    await container.read(noteProvider.future);
    container.listen(noteFormProvider, (_, _) {});
  });
  tearDown(() => container.dispose());

  test('fills from the saved record, unchanged', () {
    expect(form().form.control('title').value, 'Hello');
    expect(state().changed, isFalse);
  });

  test('is changed only while a field differs from the saved record', () async {
    await edit('title', 'Hi');
    expect(state().changed, isTrue);

    // Spaces around text and empty text aren't changes.
    await edit('title', ' Hello ');
    await edit('body', '');
    expect(state().changed, isFalse);
  });

  test('saves valid fields and starts over from what was saved', () async {
    await edit('title', 'Hi ');
    await edit('body', 'Text');

    final result = await form().save();

    expect(result, isA<Ok<Note>>());
    expect(form().submitted, [(title: 'Hi', body: 'Text')]);
    await Future<void>.delayed(Duration.zero);
    expect(state().changed, isFalse);
    expect(form().form.control('title').value, 'Hi');
  });

  test("doesn't submit invalid fields, and marks them", () async {
    await edit('title', '');

    expect(await form().save(), isNull);
    expect(form().submitted, isEmpty);
    expect(form().form.control('title').touched, isTrue);
  });

  test('keeps the changes when saving fails', () async {
    form().result = const Err(NoConnectionFailure());
    await edit('title', 'Hi');

    expect(await form().save(), isA<Err<Note>>());
    expect(state().changed, isTrue);
    expect(form().form.control('title').value, 'Hi');
  });

  test('refills when the record changes, unless it is being edited', () async {
    final notes = container.read(noteProvider.notifier);
    notes.reload((title: 'Renamed', body: null));
    expect(form().form.control('title').value, 'Renamed');

    await edit('title', 'Mine');
    notes.reload((title: 'Renamed again', body: null));
    expect(form().form.control('title').value, 'Mine');
    expect(state().changed, isTrue);
  });
}
