import 'package:app/main.dart';
import 'package:app/services/third_party.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/key_constants.dart';
import '../gen/app_router.dart';

class NotificationGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final AsyncValue<SharedPreferences> sharedPreferencesAsync = providerContainer.read(sharedPreferencesProvider);
    if (!sharedPreferencesAsync.hasValue) {
      resolver.next(true);
      return;
    }

    final SharedPreferences sharedPreferences = sharedPreferencesAsync.value!;
    final bool notificationPreferencesSet = sharedPreferences.getBool(kNotificationsAcceptedKey) != null;
    if (!notificationPreferencesSet) {
      router.removeWhere((route) => true);
      router.push(const NotificationPreferencesRoute());
      resolver.next(false);
      return;
    }

    resolver.next(true);
  }
}
