import 'package:flutter_test/flutter_test.dart';
import 'package:offers_api/admin.dart';

void main() {
  // Sending null would ask the backend to clear the store's name and
  // category (see build.yaml).
  test('requests leave out the fields that are not set', () {
    expect(const UpdateStoreDto(isActive: false).toJson(), {'isActive': false});
  });
}
