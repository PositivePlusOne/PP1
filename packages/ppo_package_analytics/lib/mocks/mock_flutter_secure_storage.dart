import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {
  MockFlutterSecureStorage() {
    when(() => delete(key: any(named: 'key'))).thenAnswer((_) async {});
    when(() => write(key: any(named: 'key'), value: any(named: 'value'))).thenAnswer((_) async {});
  }

  void withMockProperties(Map<String, String> properties) {
    when(() => readAll()).thenAnswer((_) async => properties);
  }
}
