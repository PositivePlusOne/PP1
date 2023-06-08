// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/content/conversation_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_report_dialog.dart';
import '../../../../providers/system/design_controller.dart';

enum ProfileModalDialogOptionType {
  viewProfile,
  follow,
  connect,
  message,
  block,
  report,
  mute,
  hidePosts;
}

class ProfileModalDialogOption {
  const ProfileModalDialogOption({
    required this.icon,
    required this.title,
    this.primaryColor = Colors.black,
    this.isDisabled = false,
  });

  final IconData icon;
  final String title;

  final Color primaryColor;
  final bool isDisabled;
}

class ProfileModalDialog extends ConsumerStatefulWidget {
  const ProfileModalDialog({
    required this.profile,
    required this.relationship,
    this.styleOverrides = const {},
    this.types = const {
      ProfileModalDialogOptionType.viewProfile,
      ProfileModalDialogOptionType.follow,
      ProfileModalDialogOptionType.connect,
      ProfileModalDialogOptionType.message,
      ProfileModalDialogOptionType.block,
      ProfileModalDialogOptionType.report,
      ProfileModalDialogOptionType.hidePosts,
    },
    super.key,
  });

  final Profile profile;
  final Relationship relationship;
  final Map<ProfileModalDialogOptionType, ProfileModalDialogOption> styleOverrides;

  final Set<ProfileModalDialogOptionType> types;

  static const String kProfileDialogHeroTag = 'profile_modal_dialog';

  @override
  ProfileModalDialogState createState() => ProfileModalDialogState();
}

class ProfileModalDialogState extends ConsumerState<ProfileModalDialog> {
  bool isBusy = false;

  Future<void> onOptionSelected(ProfileModalDialogOptionType type) async {
    final String flamelinkId = widget.profile.flMeta?.id ?? '';
    if (!mounted || flamelinkId.isEmpty) {
      return;
    }

    setState(() {
      isBusy = true;
    });

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final Set<RelationshipState> relationshipStates = widget.relationship.relationshipStatesForEntity(widget.profile.flMeta?.id ?? '');

    try {
      switch (type) {
        case ProfileModalDialogOptionType.viewProfile:
          await ref.read(profileControllerProvider.notifier).viewProfile(widget.profile);
          break;
        case ProfileModalDialogOptionType.follow:
          relationshipStates.contains(RelationshipState.sourceFollowed) ? await relationshipController.unfollowRelationship(flamelinkId) : await relationshipController.followRelationship(flamelinkId);
          break;
        case ProfileModalDialogOptionType.connect:
          relationshipStates.contains(RelationshipState.sourceConnected) ? await relationshipController.disconnectRelationship(flamelinkId) : await relationshipController.connectRelationship(flamelinkId);
          break;
        case ProfileModalDialogOptionType.message:
          if (relationshipStates.contains(RelationshipState.sourceConnected)) {
            setState(() {
              isBusy = true;
            });
            await ref.read(conversationControllerProvider.notifier).createConversation([flamelinkId]);
            setState(() {
              isBusy = false;
            });
          }
          break;
        case ProfileModalDialogOptionType.block:
          relationshipStates.contains(RelationshipState.sourceBlocked) ? await relationshipController.unblockRelationship(flamelinkId) : await relationshipController.blockRelationship(flamelinkId);
          break;
        case ProfileModalDialogOptionType.mute:
          relationshipStates.contains(RelationshipState.sourceMuted) ? await relationshipController.unmuteRelationship(flamelinkId) : await relationshipController.muteRelationship(flamelinkId);
          break;
        case ProfileModalDialogOptionType.hidePosts:
          relationshipStates.contains(RelationshipState.sourceHidden) ? await relationshipController.unhideRelationship(flamelinkId) : await relationshipController.hideRelationship(flamelinkId);
          break;
        case ProfileModalDialogOptionType.report:
          Navigator.of(context).pop();
          await PositiveDialog.show(context: context, dialog: ProfileReportDialog(targetProfile: widget.profile, currentUserProfile: profileController.state.userProfile!));
          break;
      }
    } finally {
      if (mounted) {
        setState(() => isBusy = false);
      }
    }
  }

  bool canDisplayOptionType(RelationshipControllerState relationshipState, UserControllerState userControllerState, ProfileModalDialogOptionType option) {
    final String flamelinkId = widget.profile.flMeta?.id ?? '';
    final String currentUserId = userControllerState.user?.uid ?? '';
    final bool isSelf = flamelinkId == currentUserId;

    if (flamelinkId.isEmpty || isSelf) {
      return false;
    }

    final Set<RelationshipState> relationshipStates = widget.relationship.relationshipStatesForEntity(widget.profile.flMeta?.id ?? '');
    final bool isSourceBlocked = relationshipStates.contains(RelationshipState.sourceBlocked);
    final bool isTargetBlocked = relationshipStates.contains(RelationshipState.targetBlocked);
    final bool isConnected = relationshipStates.contains(RelationshipState.sourceConnected) || relationshipStates.contains(RelationshipState.targetConnected);

    // If the target has blocked the source, the source cannot do anything to the target
    if (isTargetBlocked) {
      return false;
    }

    switch (option) {
      case ProfileModalDialogOptionType.connect:
      case ProfileModalDialogOptionType.follow:
      case ProfileModalDialogOptionType.hidePosts:
      case ProfileModalDialogOptionType.mute:
      case ProfileModalDialogOptionType.report:
      case ProfileModalDialogOptionType.viewProfile:
        return !isSourceBlocked;
      case ProfileModalDialogOptionType.message:
        return !isSourceBlocked && isConnected;
      default:
        break;
    }

    return true;
  }

  Widget buildOption(AppLocalizations localizations, RelationshipControllerState relationshipState, DesignColorsModel colors, ProfileModalDialogOptionType type) {
    final String flamelinkId = widget.profile.flMeta?.id ?? '';
    final String displayName = widget.profile.displayName;
    if (flamelinkId.isEmpty) {
      return const SizedBox.shrink();
    }

    final Set<RelationshipState> relationshipStates = widget.relationship.relationshipStatesForEntity(widget.profile.flMeta?.id ?? '');
    final bool isSourceBlocked = relationshipStates.contains(RelationshipState.sourceBlocked);
    final bool isConnected = relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected);
    final bool isPendingConnection = relationshipStates.contains(RelationshipState.sourceConnected) && !relationshipStates.contains(RelationshipState.targetConnected);
    final bool isMuted = relationshipStates.contains(RelationshipState.sourceMuted);
    final bool isHidden = relationshipStates.contains(RelationshipState.sourceHidden);
    final bool isFollowing = relationshipStates.contains(RelationshipState.sourceFollowed);

    Widget buttonFromOptionType(ProfileModalDialogOptionType type, IconData? icon, String label, {bool highlightOption = false, bool isDisabled = false}) {
      if (widget.styleOverrides.containsKey(type)) {
        final ProfileModalDialogOption? styleOverride = widget.styleOverrides[type];
        if (styleOverride != null) {
          return PositiveButton(
            colors: colors,
            primaryColor: styleOverride.primaryColor,
            label: styleOverride.title,
            icon: styleOverride.icon,
            onTapped: () => onOptionSelected(type),
            isDisabled: isBusy || styleOverride.isDisabled,
          );
        }
      }

      return PositiveButton(
        colors: colors,
        primaryColor: highlightOption ? colors.yellow : colors.black,
        label: label,
        icon: icon,
        onTapped: () => onOptionSelected(type),
        isDisabled: isBusy || isDisabled,
      );
    }

    switch (type) {
      case ProfileModalDialogOptionType.viewProfile:
        return buttonFromOptionType(type, UniconsLine.user_circle, localizations.shared_profile_modal_action_view_profile);
      case ProfileModalDialogOptionType.follow:
        return buttonFromOptionType(type, UniconsLine.user_plus, isFollowing ? localizations.shared_profile_modal_action_unfollow(displayName.asHandle) : localizations.shared_profile_modal_action_follow(displayName.asHandle), highlightOption: isFollowing);
      case ProfileModalDialogOptionType.connect:
        String label = isConnected ? localizations.shared_profile_modal_action_disconnect : localizations.shared_profile_modal_action_connect;
        if (isPendingConnection) {
          label = localizations.shared_actions_connection_pending;
        }

        return buttonFromOptionType(type, UniconsLine.link, label, highlightOption: isConnected, isDisabled: isPendingConnection);
      case ProfileModalDialogOptionType.message:
        return buttonFromOptionType(type, UniconsLine.envelope, localizations.shared_profile_modal_action_message(displayName.asHandle));
      case ProfileModalDialogOptionType.block:
        return buttonFromOptionType(type, UniconsLine.ban, isSourceBlocked ? localizations.shared_profile_modal_action_unblock(displayName.asHandle) : localizations.shared_profile_modal_action_block(displayName.asHandle), highlightOption: isSourceBlocked);
      case ProfileModalDialogOptionType.report:
        return buttonFromOptionType(type, UniconsLine.exclamation_circle, localizations.shared_profile_modal_action_report(displayName.asHandle));
      case ProfileModalDialogOptionType.hidePosts:
        return buttonFromOptionType(type, isHidden ? UniconsLine.eye_slash : UniconsLine.eye, isHidden ? localizations.shared_profile_modal_action_unhide_posts(displayName.asHandle) : localizations.shared_profile_modal_action_hide_posts(displayName.asHandle), highlightOption: isHidden);
      case ProfileModalDialogOptionType.mute:
        return buttonFromOptionType(type, isMuted ? UniconsLine.volume : UniconsLine.volume_mute, isMuted ? localizations.shared_profile_modal_action_unmute(displayName.asHandle) : localizations.shared_profile_modal_action_mute(displayName.asHandle), highlightOption: isMuted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final RelationshipControllerState relationshipState = ref.watch(relationshipControllerProvider);
    final UserControllerState userControllerState = ref.watch(userControllerProvider);

    final List<Widget> children = [];
    for (final ProfileModalDialogOptionType optionType in widget.types) {
      if (canDisplayOptionType(relationshipState, userControllerState, optionType)) {
        children.add(buildOption(localizations, relationshipState, colors, optionType));
      }
    }

    return PositiveDialog(
      title: '',
      children: children.spaceWithVertical(kPaddingMedium),
    );
  }
}
