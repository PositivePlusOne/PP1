// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/main.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/key_constants.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:local_auth/local_auth.dart';

// Project imports:
import 'package:app/constants/application_constants.dart';
import 'package:app/constants/design_constants.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/content/universal_links_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/pledge_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/splash/dialogs/analytics_collection_dialog.dart';
import 'package:app/widgets/organisms/splash/splash_page.dart';
import '../../../../services/third_party.dart';

part 'splash_view_model.freezed.dart';
part 'splash_view_model.g.dart';

@freezed
class SplashViewModelState with _$SplashViewModelState {
  const factory SplashViewModelState({
    required SplashStyle style,
  }) = _SplashViewModelState;

  factory SplashViewModelState.fromStyle(SplashStyle style) => SplashViewModelState(style: style);
}

@riverpod
class SplashViewModel extends _$SplashViewModel with LifecycleMixin {
  @override
  SplashViewModelState build(SplashStyle style) {
    return SplashViewModelState.fromStyle(style);
  }

  Duration get splashDuration {
    switch (style) {
      case SplashStyle.tomorrowStartsNow:
        return const Duration(seconds: 2);
      default:
        return const Duration(milliseconds: 1500);
    }
  }

  @override
  void onFirstRender() {
    unawaited(bootstrap());
  }

  Future<void> bootstrap() async {
    final AppRouter router = ref.read(appRouterProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final BuildContext context = router.navigatorKey.currentState!.context;
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final PledgeControllerState pledgeController = await ref.read(asyncPledgeControllerProvider.future);
    final UniversalLinksController universalLinksController = ref.read(universalLinksControllerProvider.notifier);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final LocalAuthentication localAuthentication = LocalAuthentication();
    final Logger log = ref.read(loggerProvider);

    final int newIndex = SplashStyle.values.indexOf(style) + 1;
    final bool exceedsEnumLength = newIndex >= SplashStyle.values.length;

    if (!exceedsEnumLength) {
      await Future<void>.delayed(splashDuration);
      await router.push(SplashRoute(style: SplashStyle.values[newIndex]));
      return;
    }

    // Verify that the splash screen has been displayed for at least the required duration
    final DateTime requiredSplashLength = DateTime.now().add(splashDuration);

    //* Store a key so that we know to skip the extended splash screen next time
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    await sharedPreferences.setBool(kSplashOnboardedKey, true);

    // Check if the pledge has been completed or if the user has all required providers linked
    if (!userController.hasAnyProviderLinked || !pledgeController.arePledgesAccepted) {
      await userController.signOut(shouldNavigate: false);
    }

    try {
      final SystemController systemController = ref.read(systemControllerProvider.notifier);
      await systemController.updateSystemConfiguration();
    } catch (ex) {
      log.e('Failed to preload build information. Error: $ex');
      final bool isLoggedOut = firebaseAuth.currentUser == null;

      if (isLoggedOut) {
        await router.replace(const HomeRoute());
        return;
      }

      await router.replace(ErrorRoute(errorMessage: localizations.shared_errors_service_unavailable));
      return;
    }

    // Check for data collection
    // On iOS, we need to show the app tracking dialog
    // On Android, we have our own dialog
    final bool canPromptForAnalyticsCollection = analyticsController.state.canPromptForAnalytics;
    if (canPromptForAnalyticsCollection) {
      bool? shouldCollectAnalytics;

      if (UniversalPlatform.isAndroid) {
        shouldCollectAnalytics = await PositiveDialog.show(
          context: context,
          barrierDismissible: false,
          showCloseButton: false,
          title: 'Allow Positive+1 to track your activity across the application?',
          child: const AnalyticsCollectionDialog(),
        );
      }

      if (UniversalPlatform.isIOS) {
        final PermissionStatus trackingPermission = await ref.read(appTrackingTransparencyPermissionsProvider.future);
        if (trackingPermission == PermissionStatus.granted || trackingPermission == PermissionStatus.limited) {
          shouldCollectAnalytics = true;
        } else {
          shouldCollectAnalytics = false;
        }
      }

      if (shouldCollectAnalytics == true) {
        await analyticsController.toggleAnalyticsCollection(true);
      } else {
        await analyticsController.toggleAnalyticsCollection(false);
      }
    }

    //* Wait until the required splash length has been reached
    final Duration remainingDuration = requiredSplashLength.difference(DateTime.now());
    if (remainingDuration > Duration.zero) {
      await Future<void>.delayed(remainingDuration);
    }

    // Check for initial links
    final HandleLinkResult result = await universalLinksController.initialize(replaceRouteOnNavigate: true);
    if (result == HandleLinkResult.handledWithNavigation) {
      return;
    }

    //* Display various welcome back pages based on system state
    PageRouteInfo? nextRoute = const OnboardingWelcomeRoute();
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    if (profileController.currentProfileId != null && !profileController.hasSetupProfile) {
      nextRoute = ProfileWelcomeBackRoute(nextPage: const HomeRoute());
    } else if (profileController.currentProfileId != null) {
      nextRoute = const HomeRoute();
    }

    // Add a delay so that the futures can complete and settle
    await Future<void>.delayed(kAnimationDurationFast);

    final bool biometricPreferencesAgree = sharedPreferences.getBool(kBiometricsAcceptedKey) == true;

    if (biometricPreferencesAgree) {
      final bool hasReauthenticated = await localAuthentication.authenticate(localizedReason: "Positive+1 needs to verify it's you");
      if (!hasReauthenticated) {
        final UserController userController = ref.read(userControllerProvider.notifier);
        final ProfileController profileController = ref.read(profileControllerProvider.notifier);
        final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
        await userController.signOut();
        profileController.resetState();
        relationshipController.resetState();
        await router.replace(LoginRoute(senderRoute: HomeRoute));
      }
    }

    await router.replace(nextRoute);
  }
}
