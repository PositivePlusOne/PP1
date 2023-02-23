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

    //* Setup required services without concrete implementations
    await Firebase.initializeApp();

    //* Setup providers
    await ref.read(asyncPledgeControllerProvider.future);
    await ref.read(asyncSecurityControllerProvider.future);

    final TalsecApp talsecApp = await ref.read(talsecAppProvider.future);
    talsecApp.start();

    final UserController userController = ref.read(userControllerProvider.notifier);
    await userController.setupListeners();

    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.flushEvents();

    final SystemController systemController = ref.read(systemControllerProvider.notifier);
    await systemController.requestPushNotificationPermissions();
    await systemController.setupPushNotificationListeners();
    await systemController.setupCrashlyticListeners();

    final MessagingController messagingController = ref.read(messagingControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    if (userController.isUserLoggedIn) {
      try {
        await profileController.loadProfile();
      } catch (e) {
        logger.e('[Splash Service] - Error loading profile: $e');
      }

      try {
        await profileController.updateFirebaseMessagingToken();
      } catch (e) {
        logger.e('[Splash Service] - Error updating FCM token: $e');
      }

      try {
        await messagingController.updateStreamToken();
      } catch (e) {
        logger.e('[Splash Service] - Error updating Stream token: $e');
      }
    }

    //* Remove all routes from the stack before pushing the next route
    router.removeWhere((route) => true);

    await router.push(const HomeRoute());
  }
}
