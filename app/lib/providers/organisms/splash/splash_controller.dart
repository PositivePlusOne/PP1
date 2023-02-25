// Dart imports:
import 'dart:async';

// Package imports:
import 'package:app/providers/user/messaging_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
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
    final AppRouter router = ref.read(appRouterProvider);
    final Logger log = ref.read(loggerProvider);

    final int newIndex = SplashStyle.values.indexOf(style) + 1;
    final bool exceedsEnumLength = newIndex >= SplashStyle.values.length;

    if (!exceedsEnumLength) {
      await Future<void>.delayed(splashDuration);
      await router.push(SplashRoute(style: SplashStyle.values[newIndex]));
      return;
    }

    //* Store a key so that we know to skip the extended splash screen next time
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    await sharedPreferences.setBool(kSplashOnboardedKey, true);

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    try {
      await profileController.loadProfile();
    } catch (ex) {
      log.i('[SplashController] bootstrap() failed to load profile');
    }

    try {
      await profileController.updateFirebaseMessagingToken();
    } catch (ex) {
      log.i('[SplashController] bootstrap() failed to update firebase messaging token');
    }

    //* Remove all routes from the stack before pushing the next route
    router.removeWhere((route) => true);
    await router.push(const HomeRoute());
  }
}
