// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:app/constants/router_constants.dart';
import 'package:app/main.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';

class ProfileDisplayGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final ProfileViewModelState profileViewModelState = providerContainer.read(profileViewModelProvider);
    final bool hasProfile = profileViewModelState.targetProfileId?.isNotEmpty == true;

    // If the user is logged in but doesn't have a profile, redirect to the account created page
    if (!hasProfile) {
      router.removeWhere((route) => true);
      router.push(kDefaultRoute);
      resolver.next(false);
      return;
    }

    resolver.next(true);
  }
}
