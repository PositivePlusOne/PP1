// Dart imports:
import 'dart:async';

// Package imports:
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/security_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/messaging_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freerasp/talsec_app.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/user/pledge_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/organisms/splash/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/key_constants.dart';
import '../../../services/third_party.dart';

part 'splash_controller.freezed.dart';
part 'splash_controller.g.dart';

@freezed
class SplashControllerState with _$SplashControllerState {
  const factory SplashControllerState({
    required SplashStyle style,
  }) = _SplashControllerState;

  factory SplashControllerState.fromStyle(SplashStyle style) => SplashControllerState(style: style);
}

@riverpod
class SplashController extends _$SplashController with LifecycleMixin {
  @override
  SplashControllerState build(SplashStyle style) {
    return SplashControllerState.fromStyle(style);
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
    final Logger logger = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);

    await Future<void>.delayed(splashDuration);

    final int newIndex = SplashStyle.values.indexOf(style) + 1;
    final bool exceedsEnumLength = newIndex >= SplashStyle.values.length;
    if (!exceedsEnumLength) {
      await router.push(SplashRoute(style: SplashStyle.values[newIndex]));
      return;
    }

    final UserController userController = ref.read(userControllerProvider.notifier);
    final MessagingController messagingController = ref.read(messagingControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);

    //* Load initial user data
    if (userController.isUserLoggedIn) {
      //! Check this out!
      await profileController.loadProfile().onError((error, stackTrace) => logger.d('Failed to load profile', error, stackTrace)).then(
            (_) async => await Future.wait([
              messagingController.updateStreamToken().onError((error, stackTrace) => logger.d('Failed to update stream token', error, stackTrace)),
              profileController.updateFirebaseMessagingToken().onError((error, stackTrace) => logger.d('Failed to update firebase messaging token', error, stackTrace)),
            ]),
          );
    }

    //* Store a key so that we know to skip the extended splash screen next time
    await sharedPreferences.setBool(kSplashOnboardedKey, true);

    //* Remove all routes from the stack before pushing the next route
    router.removeWhere((route) => true);
    await router.push(const HomeRoute());
  }
}
