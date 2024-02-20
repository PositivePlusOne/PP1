// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';

class OrganisationSetupGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final ProfileFormController profileFormController = providerContainer.read(profileFormControllerProvider.notifier);
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);

    final Profile? currentProfile = profileControllerState.currentProfile;
    final bool isOrganisation = currentProfile?.isOrganisation ?? false;

    // If the user is not an organisation, carry on as normal
    if (!isOrganisation) {
      resolver.next(true);
      return;
    }

    final bool hasName = currentProfile?.name.isNotEmpty ?? false;
    final bool hasDisplayName = currentProfile?.displayName.isNotEmpty ?? false;

    if (!hasName || !hasDisplayName) {
      profileFormController.resetState(FormMode.create);

      // Get the user's name from the user object if it exists
      if (hasName) {
        profileFormController.onNameChanged(currentProfile!.name);
      }

      if (hasDisplayName) {
        profileFormController.onDisplayNameChanged(currentProfile!.displayName);
      }

      router.replaceAll([const OrganisationNameSetupRoute()]);
      resolver.next(false);
      return;
    }

    resolver.next(true);
  }
}
