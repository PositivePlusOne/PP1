// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

// Flutter imports:
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/widgets/molecules/dialogs/positive_communities_dialog.dart';

@RoutePage()
class AccountCommunitiesPage extends HookConsumerWidget {
  const AccountCommunitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileController profileController = ref.watch(profileControllerProvider.notifier);
    final bool isManaged = profileController.isCurrentManagedProfile;

    final CommunitiesControllerProvider communitiesControllerProvider = CommunitiesControllerProvider(initialType: isManaged ? CommunityType.managed : CommunityType.connected);
    final CommunitiesControllerState communitiesControllerState = ref.watch(communitiesControllerProvider);
    final CommunitiesController communitiesController = ref.read(communitiesControllerProvider.notifier);

    return PositiveCommunitiesDialog(
      communitiesController: communitiesController,
      selectedCommunityType: communitiesControllerState.selectedCommunityType,
      supportedCommunityTypes: isManaged ? CommunityType.managedProfileCommunityTypes : CommunityType.userProfileCommunityTypes,
    );
  }
}
