// Flutter imports:
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/organisms/registration/registration_email_entry_page.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/registration/registration_account_page.dart';
import '../helpers/material_test_wrapper.dart';
import '../mocks/mock_fallbacks.dart';
import '../mocks/third_party/mock_app_router.dart';
import '../mocks/third_party/mock_firebase_auth.dart';
import '../mocks/third_party/mock_logger.dart';
import '../mocks/third_party/mock_mixpanel.dart';

void main() => group('Widget tests for 253', () {
      registerMockFallbacks();
      testWidgets('Verify can travel to email entry page', testTravelToEmailEntry);
      testWidgets('Verify email entry validation', testEmailEntryValidation);
    });

Future<void> testEmailEntryValidation(WidgetTester widgetTester) async {
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
    child: const RegistrationEmailEntryPage(),
  );

  firebaseUserCredential.withMockUserInformation(AdditionalUserInfo(isNewUser: true));
  firebaseUserCredential.withMockUser(firebaseUser);
  firebaseAuth.withMockUserCredential(firebaseUserCredential);

  await widgetTester.pumpWidget(child);

  //* Find the text field and enter an invalid email
  final Finder emailTextField = find.byType(PositiveTextField);
  await widgetTester.enterText(emailTextField, 'incorrectemail');

  //* Verify the continue button is disabled
  final Finder continueButton = find.byWidgetPredicate((widget) => widget is PositiveButton && widget.label == 'Continue');
  PositiveButton continueButtonWidget = widgetTester.widget(continueButton) as PositiveButton;
  expect(continueButtonWidget.isDisabled, isTrue);

  //* Enter a valid email and verify the continue button is enabled
  await widgetTester.enterText(emailTextField, 'test@test.com');
  await widgetTester.pumpAndSettle();
  continueButtonWidget = widgetTester.widget(continueButton) as PositiveButton;
  expect(continueButtonWidget.isDisabled, isFalse);
}

Future<void> testTravelToEmailEntry(WidgetTester widgetTester) async {
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

  firebaseUserCredential.withMockUserInformation(AdditionalUserInfo(isNewUser: true));
  firebaseUserCredential.withMockUser(firebaseUser);
  firebaseAuth.withMockUserCredential(firebaseUserCredential);

  await widgetTester.pumpWidget(child);

  //* Attempt to continue
  final Finder emailSignInButton = find.byWidgetPredicate((widget) => widget is PositiveButton && widget.label == 'Continue with Email');
  await widgetTester.tap(emailSignInButton);

  //* Verify the app router has received a push for the email entry page
  verify(() => appRouter.push(const RegistrationEmailEntryRoute())).called(1);
}
