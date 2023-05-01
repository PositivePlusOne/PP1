// Dart imports:
import 'dart:async';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/content/gender_controller.dart';
import 'package:app/providers/content/hiv_status_controller.dart';
import 'package:app/providers/content/interests_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/organisms/splash/splash_page.dart';
import '../../../../constants/key_constants.dart';
import '../../../../providers/content/events_controller.dart';
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
    final BuildContext context = router.navigatorKey.currentState!.context;
    final AppLocalizations localizations = AppLocalizations.of(context)!;
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

    try {
      final SystemController systemController = ref.read(systemControllerProvider.notifier);
      await systemController.preloadBuildInformation();
    } catch (ex) {
      log.e('Failed to preload build information', ex);
      router.removeWhere((route) => false);
      await router.push(ErrorRoute(errorMessage: localizations.shared_errors_service_unavailable));
      return;
    }

    //* Wait until the required splash length has been reached
    final Duration remainingDuration = requiredSplashLength.difference(DateTime.now());
    if (remainingDuration > Duration.zero) {
      await Future<void>.delayed(remainingDuration);
    }

    //* Remove all routes from the stack before pushing the next route
    router.removeWhere((route) => true);

    //* Display various welcome back pages based on system state
    PageRouteInfo? nextRoute = const HomeRoute();
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    if (profileController.isSettingUpUserProfile) {
      nextRoute = ProfileWelcomeBackRoute(nextPage: const HomeRoute());
    }

    await router.push(nextRoute);
  }
}
