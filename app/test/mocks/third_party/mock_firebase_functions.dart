// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFunctions extends Mock implements FirebaseFunctions {
  void withHttpsCallable(String name, HttpsCallable callable) {
    when(() => httpsCallable(name)).thenReturn(callable);
  }
}

class MockHttpCallable extends Mock implements HttpsCallable {
  MockHttpCallable();

  factory MockHttpCallable.fromData(Map<String, Object?> data) {
    final MockHttpCallable callable = MockHttpCallable();
    callable.withData(data);
    return callable;
  }

  void withData(Map<String, Object?> data) {
    final MockHttpsCallableResult result = MockHttpsCallableResult();
    result.withData(data);

    when(() => call(data)).thenAnswer((_) async => result);
  }
}

class MockHttpsCallableResult extends Mock implements HttpsCallableResult {
  void withData(Map<String, Object?> mockData) {
    when(() => data).thenReturn(mockData);
  }
}
