// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import '../../../../providers/system/design_controller.dart';

enum ProfileModalDialogOptions {
  viewProfile,
  follow,
  connect,
  message,
  block,
  report,
  mutePosts,
}

class ProfileModalDialog extends ConsumerStatefulWidget {
  const ProfileModalDialog({
    required this.userProfile,
    this.options = const {
      ProfileModalDialogOptions.viewProfile,
      ProfileModalDialogOptions.follow,
      ProfileModalDialogOptions.connect,
      ProfileModalDialogOptions.message,
      ProfileModalDialogOptions.block,
      ProfileModalDialogOptions.report,
      ProfileModalDialogOptions.mutePosts,
    },
    super.key,
  });

  final UserProfile userProfile;
  final Set<ProfileModalDialogOptions> options;

  @override
  ProfileModalDialogState createState() => ProfileModalDialogState();
}

class ProfileModalDialogState extends ConsumerState<ProfileModalDialog> {
  bool _isBusy = false;

  Future<void> onOptionSelected(ProfileModalDialogOptions option) async {
    final String flamelinkId = widget.userProfile.flMeta?.id ?? '';
    if (!mounted || flamelinkId.isEmpty) {
      return;
    }

    setState(() {
      _isBusy = true;
    });

    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final String userId = widget.userProfile.flMeta?.id ?? '';

    final bool isBlocked = relationshipController.state.blockedRelationships.contains(flamelinkId);
    final bool isConnected = relationshipController.state.connections.contains(flamelinkId);
    final bool isMuted = relationshipController.state.mutedRelationships.contains(flamelinkId);
    final bool isFollowing = relationshipController.state.following.contains(flamelinkId);

    if (userId.isEmpty) {
      return;
    }

    try {
      switch (option) {
        case ProfileModalDialogOptions.viewProfile:
          await ref.read(profileControllerProvider.notifier).viewProfile(widget.userProfile);
          break;
        case ProfileModalDialogOptions.follow:
          isFollowing ? await relationshipController.unfollowRelationship(userId) : await relationshipController.followRelationship(userId);
          break;
        case ProfileModalDialogOptions.connect:
          isConnected ? await relationshipController.disconnectRelationship(userId) : await relationshipController.connectRelationship(userId);
          break;
        case ProfileModalDialogOptions.message:
          break;
        case ProfileModalDialogOptions.block:
          isBlocked ? await relationshipController.unblockRelationship(userId) : await relationshipController.blockRelationship(userId);
          break;
        case ProfileModalDialogOptions.mutePosts:
          isMuted ? await relationshipController.unmuteRelationship(userId) : await relationshipController.muteRelationship(userId);
          break;
        case ProfileModalDialogOptions.report:
          break;
      }
    } finally {
      setState(() {
        _isBusy = false;
      });
    }
  }

  bool canDisplayOption(RelationshipControllerState relationshipState, ProfileModalDialogOptions option) {
    final String flamelinkId = widget.userProfile.flMeta?.id ?? '';

    if (flamelinkId.isEmpty) {
      return false;
    }

    final bool isBlocked = relationshipState.blockedRelationships.contains(flamelinkId);

    switch (option) {
      case ProfileModalDialogOptions.connect:
        return !isBlocked;
      case ProfileModalDialogOptions.follow:
        return !isBlocked;
      case ProfileModalDialogOptions.message:
        return !isBlocked && relationshipState.connections.contains(flamelinkId);
      default:
        break;
    }

    return true;
  }

  Widget buildOption(AppLocalizations localizations, RelationshipControllerState relationshipState, DesignColorsModel colors, ProfileModalDialogOptions option) {
    final String flamelinkId = widget.userProfile.flMeta?.id ?? '';
    if (flamelinkId.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool isBlocked = relationshipState.blockedRelationships.contains(flamelinkId);
    final bool isConnected = relationshipState.connections.contains(flamelinkId);
    final bool isMuted = relationshipState.mutedRelationships.contains(flamelinkId);
    final bool isFollowing = relationshipState.following.contains(flamelinkId);

    buttonFromOption(ProfileModalDialogOptions option, IconData? icon, String label) => PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          label: label,
          icon: icon,
          onTapped: () => onOptionSelected(option),
          isDisabled: _isBusy,
        );

    switch (option) {
      case ProfileModalDialogOptions.viewProfile:
        return buttonFromOption(option, UniconsLine.user_circle, localizations.shared_profile_modal_action_view_profile);
      case ProfileModalDialogOptions.follow:
        return buttonFromOption(option, UniconsLine.user_plus, isFollowing ? localizations.shared_profile_modal_action_unfollow : localizations.shared_profile_modal_action_follow);
      case ProfileModalDialogOptions.connect:
        return buttonFromOption(option, UniconsLine.link, isConnected ? localizations.shared_profile_modal_action_disconnect : localizations.shared_profile_modal_action_connect);
      case ProfileModalDialogOptions.message:
        return buttonFromOption(option, UniconsLine.envelope, localizations.shared_profile_modal_action_message);
      case ProfileModalDialogOptions.block:
        return buttonFromOption(option, UniconsLine.ban, isBlocked ? localizations.shared_profile_modal_action_unblock : localizations.shared_profile_modal_action_block);
      case ProfileModalDialogOptions.report:
        return buttonFromOption(option, UniconsLine.exclamation_circle, localizations.shared_profile_modal_action_report);
      case ProfileModalDialogOptions.mutePosts:
        return buttonFromOption(option, UniconsLine.volume_mute, isMuted ? localizations.shared_profile_modal_action_mute_posts : localizations.shared_profile_modal_action_unmute_posts);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final RelationshipControllerState relationshipState = ref.watch(relationshipControllerProvider);

    final List<Widget> children = [];
    for (final ProfileModalDialogOptions option in widget.options) {
      if (canDisplayOption(relationshipState, option)) {
        children.add(buildOption(localizations, relationshipState, colors, option));
      }
    }

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(kPaddingSmall),
      child: PositiveGlassSheet(
        onDismissRequested: () => Navigator.of(context).pop(),
        children: children.spaceWithVertical(kPaddingMedium),
      ),
    );
  }
}
