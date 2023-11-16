// Package imports:
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

class MockLogger extends Mock implements Logger {
  MockLogger() {
    registerFallbackValue(this);
  }
}
