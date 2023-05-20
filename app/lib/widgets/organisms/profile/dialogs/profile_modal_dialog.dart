// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
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
    this.types = const {
      ProfileModalDialogOptionType.viewProfile,
      ProfileModalDialogOptionType.follow,
      ProfileModalDialogOptionType.connect,
      ProfileModalDialogOptionType.message,
      ProfileModalDialogOptionType.block,
      ProfileModalDialogOptionType.report,
      ProfileModalDialogOptionType.hidePosts,
    },
    this.styleOverrides = const {},
    super.key,
  });

  final Profile profile;
  final Set<ProfileModalDialogOptionType> types;

  static const String kProfileDialogHeroTag = 'profile_modal_dialog';

  final Map<ProfileModalDialogOptionType, ProfileModalDialogOption> styleOverrides;

  @override
  ProfileModalDialogState createState() => ProfileModalDialogState();
}

class ProfileModalDialogState extends ConsumerState<ProfileModalDialog> {
  bool _isBusy = false;

  Future<void> onOptionSelected(ProfileModalDialogOptionType type) async {
    final String flamelinkId = widget.profile.flMeta?.id ?? '';
    if (!mounted || flamelinkId.isEmpty) {
      return;
    }

    setState(() {
      _isBusy = true;
    });

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);

    final bool isBlocked = relationshipController.state.blockedRelationships.contains(flamelinkId);
    final bool isConnected = relationshipController.state.connections.contains(flamelinkId);
    final bool isMuted = relationshipController.state.mutedRelationships.contains(flamelinkId);
    final bool isHidden = relationshipController.state.hiddenRelationships.contains(flamelinkId);
    final bool isFollowing = relationshipController.state.following.contains(flamelinkId);

    try {
      switch (type) {
        case ProfileModalDialogOptionType.viewProfile:
          await ref.read(profileControllerProvider.notifier).viewProfile(widget.profile);
          break;
        case ProfileModalDialogOptionType.follow:
          isFollowing ? await relationshipController.unfollowRelationship(flamelinkId) : await relationshipController.followRelationship(flamelinkId);
          break;
        case ProfileModalDialogOptionType.connect:
          isConnected ? await relationshipController.disconnectRelationship(flamelinkId) : await relationshipController.connectRelationship(flamelinkId);
          break;
        case ProfileModalDialogOptionType.message:
          break;
        case ProfileModalDialogOptionType.block:
          isBlocked ? await relationshipController.unblockRelationship(flamelinkId) : await relationshipController.blockRelationship(flamelinkId);
          break;
        case ProfileModalDialogOptionType.mute:
          isMuted ? await relationshipController.unmuteRelationship(flamelinkId) : await relationshipController.muteRelationship(flamelinkId);
          break;
        case ProfileModalDialogOptionType.hidePosts:
          isHidden ? await relationshipController.hideRelationship(flamelinkId) : await relationshipController.unhideRelationship(flamelinkId);
          break;
        case ProfileModalDialogOptionType.report:
          Navigator.of(context).pop();
          await PositiveDialog.show(context: context, dialog: ProfileReportDialog(targetProfile: widget.profile, currentUserProfile: profileController.state.userProfile!));
          break;
      }
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  bool canDisplayOptionType(RelationshipControllerState relationshipState, ProfileModalDialogOptionType option) {
    final String flamelinkId = widget.profile.flMeta?.id ?? '';

    if (flamelinkId.isEmpty) {
      return false;
    }

    final bool isBlocked = relationshipState.blockedRelationships.contains(flamelinkId);

    switch (option) {
      case ProfileModalDialogOptionType.connect:
      case ProfileModalDialogOptionType.follow:
      case ProfileModalDialogOptionType.hidePosts:
      case ProfileModalDialogOptionType.mute:
      case ProfileModalDialogOptionType.report:
      case ProfileModalDialogOptionType.viewProfile:
        return !isBlocked;
      case ProfileModalDialogOptionType.message:
        return !isBlocked && relationshipState.connections.contains(flamelinkId);

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

    final bool isBlocked = relationshipState.blockedRelationships.contains(flamelinkId);
    final bool isConnected = relationshipState.connections.contains(flamelinkId);
    final bool isMuted = relationshipState.mutedRelationships.contains(flamelinkId);
    final bool isHidden = relationshipState.hiddenRelationships.contains(flamelinkId);
    final bool isFollowing = relationshipState.following.contains(flamelinkId);

    Widget buttonFromOptionType(ProfileModalDialogOptionType type, IconData? icon, String label, {bool highlightOption = false}) {
      if (widget.styleOverrides.containsKey(type)) {
        final ProfileModalDialogOption? styleOverride = widget.styleOverrides[type];
        if (styleOverride != null) {
          return PositiveButton(
            colors: colors,
            primaryColor: styleOverride.primaryColor,
            label: styleOverride.title,
            icon: styleOverride.icon,
            onTapped: () => onOptionSelected(type),
            isDisabled: _isBusy || styleOverride.isDisabled,
          );
        }
      }

      return PositiveButton(
        colors: colors,
        primaryColor: highlightOption ? colors.yellow : colors.black,
        label: label,
        icon: icon,
        onTapped: () => onOptionSelected(type),
        isDisabled: _isBusy,
      );
    }

    switch (type) {
      case ProfileModalDialogOptionType.viewProfile:
        return buttonFromOptionType(type, UniconsLine.user_circle, localizations.shared_profile_modal_action_view_profile);
      case ProfileModalDialogOptionType.follow:
        return buttonFromOptionType(type, UniconsLine.user_plus, isFollowing ? localizations.shared_profile_modal_action_unfollow(displayName) : localizations.shared_profile_modal_action_follow(displayName), highlightOption: isFollowing);
      case ProfileModalDialogOptionType.connect:
        return buttonFromOptionType(type, UniconsLine.link, isConnected ? localizations.shared_profile_modal_action_disconnect : localizations.shared_profile_modal_action_connect, highlightOption: isConnected);
      case ProfileModalDialogOptionType.message:
        return buttonFromOptionType(type, UniconsLine.envelope, localizations.shared_profile_modal_action_message(displayName));
      case ProfileModalDialogOptionType.block:
        return buttonFromOptionType(type, UniconsLine.ban, isBlocked ? localizations.shared_profile_modal_action_unblock(displayName) : localizations.shared_profile_modal_action_block(displayName), highlightOption: isBlocked);
      case ProfileModalDialogOptionType.report:
        return buttonFromOptionType(type, UniconsLine.exclamation_circle, localizations.shared_profile_modal_action_report(displayName));
      case ProfileModalDialogOptionType.hidePosts:
        return buttonFromOptionType(type, isHidden ? UniconsLine.eye_slash : UniconsLine.eye, isHidden ? localizations.shared_profile_modal_action_hide_posts(displayName) : localizations.shared_profile_modal_action_unhide_posts(displayName), highlightOption: isHidden);
      case ProfileModalDialogOptionType.mute:
        return buttonFromOptionType(type, isMuted ? UniconsLine.volume : UniconsLine.volume_mute, isMuted ? localizations.shared_profile_modal_action_mute(displayName) : localizations.shared_profile_modal_action_unmute(displayName), highlightOption: isMuted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final RelationshipControllerState relationshipState = ref.watch(relationshipControllerProvider);

    final List<Widget> children = [];
    for (final ProfileModalDialogOptionType optionType in widget.types) {
      if (canDisplayOptionType(relationshipState, optionType)) {
        children.add(buildOption(localizations, relationshipState, colors, optionType));
      }
    }

    return PositiveDialog(
      title: '',
      children: children.spaceWithVertical(kPaddingMedium),
    );
  }
}
