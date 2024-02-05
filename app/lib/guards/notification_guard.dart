// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/constants/application_constants.dart';
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';
import '../gen/app_router.dart';
import '../providers/user/user_controller.dart';

class NotificationGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final AsyncValue<SharedPreferences> sharedPreferencesAsync = providerContainer.read(sharedPreferencesProvider);
    final UserController userController = providerContainer.read(userControllerProvider.notifier);
    final User? user = userController.currentUser;

    if (!sharedPreferencesAsync.hasValue || user == null) {
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
