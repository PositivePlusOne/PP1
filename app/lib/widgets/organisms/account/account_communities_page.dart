// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

// Flutter imports:
import 'package:app/widgets/molecules/dialogs/positive_communities_dialog.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/providers/user/communities_controller.dart';

@RoutePage()
class AccountCommunitiesPage extends HookConsumerWidget {
  const AccountCommunitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CommunityType communityType = ref.watch(communitiesControllerProvider.select((value) => value.selectedCommunityType));

    return PositiveCommunitiesDialog(
      selectedCommunityType: communityType,
      supportedCommunityTypes: CommunityType.values,
    );
  }
}
