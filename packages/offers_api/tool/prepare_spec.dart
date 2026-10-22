// Adjusts the backend's OpenAPI spec for swagger_parser before generating.
//
//   dart run tool/prepare_spec.dart openapi/openapi.json
//
// swagger_parser makes every field of a schema required when the schema has
// no `required` list and one of its fields uses `allOf` (how NestJS writes
// an enum field with a description). Update DTOs then can't leave fields
// out. An empty `required` list says what the spec means: none are.
import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final file = File(args.single);
  final spec = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final components = spec['components'] as Map<String, dynamic>? ?? {};
  final schemas = components['schemas'] as Map<String, dynamic>? ?? {};
  for (final schema in schemas.values.cast<Map<String, dynamic>>()) {
    if (schema.containsKey('properties')) {
      schema.putIfAbsent('required', () => <String>[]);
    }
  }
  file.writeAsStringSync(jsonEncode(spec));
}
