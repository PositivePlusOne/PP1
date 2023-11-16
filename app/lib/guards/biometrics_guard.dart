// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';
import '../providers/system/security_controller.dart';
import '../providers/user/user_controller.dart';

// import '../constants/key_constants.dart';
// import '../gen/app_router.dart';

class BiometricsGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final AsyncValue<SecurityControllerState> securityControllerAsync = providerContainer.read(asyncSecurityControllerProvider);
    final AsyncValue<SharedPreferences> sharedPreferencesAsync = providerContainer.read(sharedPreferencesProvider);
    final UserController userController = providerContainer.read(userControllerProvider.notifier);
    final User? user = userController.currentUser;

    if (user == null || !securityControllerAsync.hasValue || !sharedPreferencesAsync.hasValue) {
      resolver.next(true);
      return;
    }

    // final SharedPreferences sharedPreferences = sharedPreferencesAsync.value!;
    // final bool biometricPreferencesSet = sharedPreferences.getBool(kBiometricsAcceptedKey) != null;

    // Come back this post-launch
    // if (!biometricPreferencesSet) {
    //   router.removeWhere((route) => true);
    //   router.push(const BiometricsPreferencesRoute());
    //   resolver.next(false);
    //   return;
    // }

    resolver.next(true);
  }
}
