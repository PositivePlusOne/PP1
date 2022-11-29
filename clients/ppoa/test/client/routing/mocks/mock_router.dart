// Package imports:
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:ppoa/client/routing/app_router.gr.dart';

class MockRouter extends Mock implements AppRouter {
  MockRouter() {
    when(() => push(any())).thenAnswer((_) async => Future.value(null));
  }
}
