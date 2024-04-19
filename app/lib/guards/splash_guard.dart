// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/constants/application_constants.dart';
import 'package:app/main.dart';
import 'package:app/widgets/organisms/splash/splash_page.dart';
import '../gen/app_router.dart';
import '../services/third_party.dart';

/// SplashGuard is a guard that will skip the splash screen if the user has already onboarded.
class SplashGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final AsyncValue<SharedPreferences> sharedPreferencesValue = providerContainer.read(sharedPreferencesProvider);
    final bool hasSharedPreferences = sharedPreferencesValue.value != null;
    if (!hasSharedPreferences) {
      resolver.next(true);
      return;
    }

    final args = resolver.route.args;
    if (args is SplashRouteArgs && args.style == SplashStyle.tomorrowStartsNow) {
      resolver.next(true);
      return;
    }

    final SharedPreferences sharedPreferences = sharedPreferencesValue.value!;
    final bool hasSplashKey = sharedPreferences.containsKey(kSplashOnboardedKey) && sharedPreferences.getBool(kSplashOnboardedKey)!;
    if (hasSplashKey) {
      router.replaceAll([SplashRoute(style: SplashStyle.tomorrowStartsNow)]);
      resolver.next(false);
      return;
    }

    resolver.next(true);
  }
}
