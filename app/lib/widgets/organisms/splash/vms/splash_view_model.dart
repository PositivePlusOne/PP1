// ignore_for_file: avoid_public_notifier_properties

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/content/universal_links_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/pledge_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/organisms/splash/splash_page.dart';
import '../../../../constants/key_constants.dart';
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
        return const Duration(seconds: 3);
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
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final PledgeControllerState pledgeController = await ref.read(asyncPledgeControllerProvider.future);
    final UniversalLinksController universalLinksController = ref.read(universalLinksControllerProvider.notifier);
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
    if (!userController.hasRequiredProvidersLinked || !pledgeController.arePledgesAccepted) {
      await userController.signOut(shouldNavigate: false);
    }

    bool hasRestoredCache = false;
    if (firebaseAuth.currentUser != null) {
      hasRestoredCache = await cacheController.restoreCache();
    }

    if (!hasRestoredCache) {
      try {
        final SystemController systemController = ref.read(systemControllerProvider.notifier);
        await systemController.updateSystemConfiguration();
      } catch (ex) {
        log.e('Failed to preload build information. Error: $ex');
        final bool isLoggedOut = firebaseAuth.currentUser == null;
        router.removeWhere((route) => true);

        if (isLoggedOut) {
          await router.push(const HomeRoute());
          return;
        }

        await router.push(ErrorRoute(errorMessage: localizations.shared_errors_service_unavailable));
        return;
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

    router.removeWhere((route) => true);
    await router.push(nextRoute);
  }
}
