// Package imports:
import 'dart:async';

import 'package:app/gen/app_router.dart';
import 'package:app/widgets/organisms/splash/splash_page.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/hooks/lifecycle_hook.dart';

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
    await Future<void>.delayed(splashDuration);

    final int newIndex = SplashStyle.values.indexOf(style) + 1;
    final bool exceedsEnumLength = newIndex >= SplashStyle.values.length;
    if (!exceedsEnumLength) {
      await router.push(SplashRoute(style: SplashStyle.values[newIndex]));
      return;
    }

    //* Remove all routes from the stack before pushing the next route
    router.removeWhere((route) => true);

    await router.push(const OnboardingWelcomeRoute());
    return;
  }
}
