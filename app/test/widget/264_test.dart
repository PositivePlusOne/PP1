// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/registration/registration_account_page.dart';
import '../helpers/material_test_wrapper.dart';
import '../mocks/mock_fallbacks.dart';
import '../mocks/third_party/mock_app_router.dart';
import '../mocks/third_party/mock_firebase_auth.dart';
import '../mocks/third_party/mock_firebase_functions.dart';
import '../mocks/third_party/mock_google_sign_in.dart';
import '../mocks/third_party/mock_logger.dart';
import '../mocks/third_party/mock_mixpanel.dart';

void main() => group('User registers for PP1 with Google', () {
      registerMockFallbacks();
      testWidgets('Happy path with mocks as a new user', testHappyPathWidgets);
    });

Future<void> testHappyPathWidgets(WidgetTester widgetTester) async {
  // Arrange
  final MockAppRouter appRouter = MockAppRouter();
  final MockLogger logger = MockLogger();
  final MockMixpanel mixpanel = MockMixpanel();

  final MockGoogleSignIn googleSignIn = MockGoogleSignIn();
  final MockGoogleSignInAccount account = MockGoogleSignInAccount();
  final MockGoogleSignInAuthentication authentication = MockGoogleSignInAuthentication();
  final MockFirebaseAuth firebaseAuth = MockFirebaseAuth();
  final MockFirebaseUserCredential firebaseUserCredential = MockFirebaseUserCredential();
  final MockFirebaseUser firebaseUser = MockFirebaseUser();
  final MockFirebaseFunctions firebaseFunctions = MockFirebaseFunctions();
  final MockHttpCallable callable = MockHttpCallable.fromData(UserProfile.empty().toJson());

  final ProviderContainer container = ProviderContainer(
    overrides: [
      appRouterProvider.overrideWithValue(appRouter),
      loggerProvider.overrideWithValue(logger),
      mixpanelProvider.overrideWith((_) => mixpanel),
      firebaseAuthProvider.overrideWith((_) => firebaseAuth),
      googleSignInProvider.overrideWith((_) => googleSignIn),
      firebaseFunctionsProvider.overrideWith((_) => firebaseFunctions),
    ],
  );

  final Widget child = MaterialTestWrapper(
    container: container,
    child: const RegistrationAccountPage(),
  );

  // Act
  authentication.withMockIdToken('idToken');
  authentication.withMockAccessToken('accessToken');
  account.withMockAuthentication(authentication);
  googleSignIn.withMockNoUser();
  googleSignIn.withMockSignInAccount(account);
  firebaseUserCredential.withMockUserInformation(AdditionalUserInfo(isNewUser: true));
  firebaseUserCredential.withMockUser(firebaseUser);
  firebaseAuth.withMockUserCredential(firebaseUserCredential);
  firebaseFunctions.withHttpsCallable('profile-getProfile', callable);

  await widgetTester.pumpWidget(child);

  final Finder googleSignInButton = find.byWidgetPredicate((widget) => widget is PositiveButton && widget.label == 'Continue with Google');
  await widgetTester.tap(googleSignInButton);
  await widgetTester.pumpAndSettle();

  // Assert
  verify(() => appRouter.push(const HomeRoute())).called(1);
  expect(() => container.read(userControllerProvider).user, isNotNull);
  verify(() => mixpanel.track('Sign Up With Google', properties: any(named: 'properties'))).called(1);
}
