// Package imports:
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:app/gen/app_router.dart';

class MockAppRouter extends Mock implements AppRouter {
  MockAppRouter() {
    registerFallbackValue(this);
    when(() => push(any())).thenAnswer((_) async => null);
  }
}
