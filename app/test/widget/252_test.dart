// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/registration/registration_account_page.dart';
import '../helpers/material_test_wrapper.dart';
import '../mocks/mock_fallbacks.dart';
import '../mocks/third_party/mock_app_router.dart';
import '../mocks/third_party/mock_firebase_auth.dart';
import '../mocks/third_party/mock_logger.dart';
import '../mocks/third_party/mock_mixpanel.dart';

void main() => group('Widget tests for 252', () {
      registerMockFallbacks();
      testWidgets('Happy path with mocks as a new user', testHappyPathWidgets);
    });

Future<void> testHappyPathWidgets(WidgetTester widgetTester) async {
  // Arrange
  final MockAppRouter appRouter = MockAppRouter();
  final MockLogger logger = MockLogger();
  final MockMixpanel mixpanel = MockMixpanel();

  final MockFirebaseAuth firebaseAuth = MockFirebaseAuth();
  final MockFirebaseUserCredential firebaseUserCredential = MockFirebaseUserCredential();
  final MockFirebaseUser firebaseUser = MockFirebaseUser();

  final ProviderContainer container = ProviderContainer(
    overrides: [
      appRouterProvider.overrideWithValue(appRouter),
      loggerProvider.overrideWithValue(logger),
      mixpanelProvider.overrideWith((_) => mixpanel),
      firebaseAuthProvider.overrideWith((_) => firebaseAuth),
    ],
  );

  final Widget child = MaterialTestWrapper(
    container: container,
    child: const RegistrationAccountPage(),
  );

  // Act
  firebaseUserCredential.withMockUserInformation(AdditionalUserInfo(isNewUser: true));
  firebaseUserCredential.withMockUser(firebaseUser);
  firebaseAuth.withMockUserCredential(firebaseUserCredential);

  await widgetTester.pumpWidget(child);

  final Finder appleSignInButton = find.byWidgetPredicate((widget) => widget is PositiveButton && widget.label == 'Continue with Apple');
  await widgetTester.tap(appleSignInButton);

  // Assert
  verify(() => appRouter.push(const HomeRoute())).called(1);
  // expect(() => container.read(userControllerProvider).user, isNotNull);
  verify(() => mixpanel.track('Sign Up With Apple', properties: any(named: 'properties'))).called(1);
}
