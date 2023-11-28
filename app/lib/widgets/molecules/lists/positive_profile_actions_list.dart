// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/content/events/request_refresh_event.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_disconnect_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_unblock_dialog.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/database/profile/profile.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/indicators/positive_snackbar.dart';
import '../../organisms/profile/dialogs/profile_modal_dialog.dart';

class PositiveProfileActionsList extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const PositiveProfileActionsList({
    required this.currentProfile,
    required this.targetProfile,
    required this.relationship,
    super.key,
  }) : height = currentProfile == null ? 0.0 : kButtonListHeight;

  final Profile? currentProfile;
  final Profile targetProfile;
  final Relationship? relationship;
  final double height;

  static const double kButtonListHeight = 42.0;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PositiveProfileActionsListState();
}

class _PositiveProfileActionsListState extends ConsumerState<PositiveProfileActionsList> {
  bool isBusy = false;

  Future<void> onEditProfileTapped() async {
    if (!mounted) {
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('Edit profile tapped');
    appRouter.push(const AccountProfileEditSettingsRoute());
  }

  Future<void> onFollowTapped() async {
    if (!mounted) {
      return;
    }

    final String targetUserId = widget.targetProfile.flMeta?.id ?? '';
    final Logger logger = ref.read(loggerProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);
    final String currentProfileId = widget.currentProfile?.flMeta?.id ?? '';
    logger.d('Follow tapped');

    if (targetUserId.isEmpty || currentProfileId.isEmpty) {
      logger.e('Failed to follow user: targetUserId is empty');
      return;
    }

    setState(() {
      isBusy = true;
    });

    try {
      await relationshipController.followRelationship(targetUserId);
      eventBus.fire(RequestRefreshEvent());
      ScaffoldMessenger.of(context).showSnackBar(PositiveFollowSnackBar(text: 'You are now following ${widget.targetProfile.displayName.asHandle}'));
    } catch (e) {
      logger.e('Failed to follow user. Error: $e');
    } finally {
      setState(() {
        isBusy = false;
      });
    }
  }

  Future<void> onUnblockTapped() async {
    if (!mounted) {
      return;
    }

    final String targetUserId = widget.targetProfile.flMeta?.id ?? '';
    final Logger logger = ref.read(loggerProvider);
    final String currentProfileId = widget.currentProfile?.flMeta?.id ?? '';
    logger.d('Unblock tapped');

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    if (targetUserId.isEmpty || currentProfileId.isEmpty) {
      logger.e('Failed to unblock user: targetUserId is empty');
      return;
    }

    final String targetDisplayNameHandle = widget.targetProfile.displayName.asHandle;
    await PositiveDialog.show(
      context: context,
      useSafeArea: false,
      title: localizations.shared_profile_modal_action_block(targetDisplayNameHandle),
      child: ProfileUnblockDialog(
        targetProfileId: targetUserId,
        currentProfileId: currentProfileId,
      ),
    );
  }

  Future<void> onUnfollowTapped() async {
    if (!mounted) {
      return;
    }

    final String targetUserId = widget.targetProfile.flMeta?.id ?? '';
    final Logger logger = ref.read(loggerProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);
    final String currentProfileId = widget.currentProfile?.flMeta?.id ?? '';
    logger.d('Unfollow tapped');

    if (targetUserId.isEmpty || currentProfileId.isEmpty) {
      logger.e('Failed to unfollow user: targetUserId is empty');
      return;
    }

    setState(() {
      isBusy = true;
    });

    try {
      await relationshipController.unfollowRelationship(targetUserId);
      eventBus.fire(RequestRefreshEvent());
      ScaffoldMessenger.of(context).showSnackBar(PositiveFollowSnackBar(text: 'You have stopped following ${widget.targetProfile.displayName.asHandle}'));
    } catch (e) {
      logger.e('Failed to unfollow user. Error: $e');
    } finally {
      setState(() {
        isBusy = false;
      });
    }
  }

  Future<void> onConnectTapped() async {
    if (!mounted) {
      return;
    }

    final String targetUserId = widget.targetProfile.flMeta?.id ?? '';
    final Logger logger = ref.read(loggerProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    logger.d('Connect tapped');

    if (targetUserId.isEmpty) {
      logger.e('Failed to connect user: targetUserId is empty');
      return;
    }

    setState(() {
      isBusy = true;
    });

    try {
      await relationshipController.connectRelationship(targetUserId);
    } catch (e) {
      logger.e('Failed to connect user. Error: $e');
    } finally {
      setState(() {
        isBusy = false;
      });
    }
  }

  Future<void> onMoreActionsTapped() async {
    if (!mounted) {
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    final String targetUserId = widget.targetProfile.flMeta?.id ?? '';
    final String currentUserId = widget.currentProfile?.flMeta?.id ?? '';

    logger.d('User profile modal requested: $targetUserId');

    await PositiveDialog.show(
      context: context,
      child: ProfileModalDialog(
        targetProfileId: targetUserId,
        currentProfileId: currentUserId,
        types: const {
          ProfileModalDialogOptionType.hidePosts,
          ProfileModalDialogOptionType.block,
          ProfileModalDialogOptionType.report,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((design) => design.colors));
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);

    if (profileController.currentProfileId == null) {
      return const SizedBox.shrink();
    }

    final Color accentColor = widget.targetProfile.accentColor.toSafeColorFromHex(defaultColor: colors.black);
    final Color expectedButtonColor = accentColor.complimentTextColor;

    final Set<RelationshipState> relationshipStates = widget.relationship?.relationshipStatesForEntity(profileController.currentProfileId!) ?? {};
    final String flamelinkId = widget.targetProfile.flMeta?.id ?? '';

    final bool isSourceOrganisation = widget.currentProfile?.isOrganisation ?? false;
    final bool isTargetOrganisation = widget.targetProfile.isOrganisation;
    final bool relationshipContainsOrganisation = isSourceOrganisation || isTargetOrganisation;

    bool isCurrentUser = false;
    bool hasFollowedTargetUser = false;
    bool hasConnectedToTargetUser = false;
    bool hasPendingConnectionToTargetUser = false;
    bool isRelationshipBlocked = false;

    if (widget.targetProfile.flMeta?.id?.isNotEmpty ?? false) {
      isCurrentUser = widget.targetProfile.flMeta!.id == profileController.currentProfileId;
      hasFollowedTargetUser = relationshipStates.contains(RelationshipState.sourceFollowed);
      hasConnectedToTargetUser = relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected);
      isRelationshipBlocked = relationshipStates.contains(RelationshipState.sourceBlocked) || relationshipStates.contains(RelationshipState.targetBlocked);
      hasPendingConnectionToTargetUser = relationshipStates.contains(RelationshipState.sourceConnected) && !relationshipStates.contains(RelationshipState.targetConnected);
    }

    final List<Widget> children = <Widget>[];

    //* Add the optional edit profile button
    if (isCurrentUser) {
      final Widget editProfileAction = PositiveButton(
        colors: colors,
        primaryColor: expectedButtonColor,
        onTapped: onEditProfileTapped,
        label: localizations.page_account_actions_edit_profile,
        icon: UniconsLine.pen,
        layout: PositiveButtonLayout.iconRight,
        size: PositiveButtonSize.medium,
        forceIconPadding: true,
        isDisabled: isBusy,
      );

      children.add(editProfileAction);
    }

    // Add the optional unblock action
    if (isRelationshipBlocked) {
      final Widget unblockAction = PositiveButton(
        colors: colors,
        primaryColor: expectedButtonColor,
        onTapped: onUnblockTapped,
        label: localizations.shared_actions_unblock,
        icon: UniconsLine.ban,
        layout: PositiveButtonLayout.iconLeft,
        size: PositiveButtonSize.medium,
        forceIconPadding: true,
        isDisabled: isBusy,
      );

      children.add(unblockAction);
    }

    // Add the optional follow action
    if (!isRelationshipBlocked && !isCurrentUser && !hasFollowedTargetUser) {
      final Widget followAction = PositiveButton(
        colors: colors,
        primaryColor: expectedButtonColor,
        onTapped: onFollowTapped,
        label: localizations.shared_actions_follow,
        icon: UniconsLine.plus_circle,
        layout: PositiveButtonLayout.iconRight,
        size: PositiveButtonSize.medium,
        forceIconPadding: true,
        isDisabled: isBusy || isRelationshipBlocked,
      );

      children.add(followAction);
    }

    // Add the optional unfollow action
    if (!isCurrentUser && hasFollowedTargetUser) {
      final Widget unfollowAction = PositiveButton(
        colors: colors,
        primaryColor: expectedButtonColor,
        onTapped: onUnfollowTapped,
        icon: UniconsLine.check_circle,
        tooltip: localizations.shared_actions_unfollow,
        layout: PositiveButtonLayout.iconOnly,
        size: PositiveButtonSize.medium,
        isDisabled: isBusy || isRelationshipBlocked,
      );

      children.add(unfollowAction);
    }

    if (!isCurrentUser && hasPendingConnectionToTargetUser && !relationshipContainsOrganisation) {
      final Widget disconnectAction = PositiveButton(
        colors: colors,
        primaryColor: expectedButtonColor,
        onTapped: () => PositiveDialog.show(
          title: 'Remove Connection',
          context: context,
          child: const ProfileDisconnectDialog(),
        ),
        label: localizations.shared_actions_connect,
        icon: UniconsLine.hourglass,
        tooltip: hasPendingConnectionToTargetUser ? localizations.shared_actions_connection_pending : localizations.shared_actions_disconnect,
        layout: PositiveButtonLayout.iconRight,
        size: PositiveButtonSize.medium,
        forceIconPadding: true,
        isDisabled: true,
      );

      children.add(disconnectAction);
    }

    if (!isRelationshipBlocked && !isCurrentUser && !hasConnectedToTargetUser && !hasPendingConnectionToTargetUser && !relationshipContainsOrganisation) {
      final Widget connectAction = PositiveButton(
        colors: colors,
        primaryColor: expectedButtonColor,
        onTapped: onConnectTapped,
        label: localizations.shared_actions_connect,
        icon: UniconsLine.user_plus,
        layout: PositiveButtonLayout.iconRight,
        size: PositiveButtonSize.medium,
        forceIconPadding: true,
        isDisabled: isBusy || isRelationshipBlocked,
      );

      children.add(connectAction);
    }

    if (!isCurrentUser && hasConnectedToTargetUser && !relationshipContainsOrganisation) {
      final Widget disconnectAction = PositiveButton(
        colors: colors,
        primaryColor: expectedButtonColor,
        onTapped: () => PositiveDialog.show(
          title: 'Remove Connection',
          context: context,
          child: const ProfileDisconnectDialog(),
        ),
        icon: UniconsLine.user_check,
        tooltip: hasPendingConnectionToTargetUser ? localizations.shared_actions_connection_pending : localizations.shared_actions_disconnect,
        layout: PositiveButtonLayout.iconOnly,
        size: PositiveButtonSize.medium,
        isDisabled: isBusy || isRelationshipBlocked,
      );

      children.add(disconnectAction);
    }

    if ((!isCurrentUser && hasConnectedToTargetUser) || (!isCurrentUser && relationshipContainsOrganisation)) {
      final Widget messageAction = PositiveButton(
        colors: colors,
        primaryColor: expectedButtonColor,
        onTapped: () async => await getStreamController.createConversation([flamelinkId], shouldPopDialog: true),
        icon: UniconsLine.comment,
        tooltip: 'Message',
        layout: PositiveButtonLayout.iconOnly,
        size: PositiveButtonSize.medium,
        forceIconPadding: true,
        isDisabled: isBusy || isRelationshipBlocked,
      );

      children.add(messageAction);
    }

    // Add the more actions button
    if (!isCurrentUser) {
      final Widget moreActionsButton = PositiveButton(
        colors: colors,
        primaryColor: expectedButtonColor,
        onTapped: onMoreActionsTapped,
        icon: UniconsLine.ellipsis_h,
        tooltip: localizations.shared_actions_more,
        layout: PositiveButtonLayout.iconOnly,
        size: PositiveButtonSize.medium,
        style: PositiveButtonStyle.outline,
        isDisabled: isBusy,
      );

      children.add(moreActionsButton);
    }

    return SizedBox(
      height: PositiveProfileActionsList.kButtonListHeight,
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingSmallMedium),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: children.spaceWithHorizontal(kPaddingSmall),
        ),
      ),
    );
  }
}
