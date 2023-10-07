// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

// Flutter imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final Profile? currentProfile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));
    final User? currentUser = ref.watch(firebaseAuthProvider.select((value) => value.currentUser));

    final CommunitiesControllerProvider provider = communitiesControllerProvider(currentProfile: currentProfile, currentUser: currentUser);

    return PositiveCommunitiesDialog(
      controllerProvider: provider,
    );
  }
}
