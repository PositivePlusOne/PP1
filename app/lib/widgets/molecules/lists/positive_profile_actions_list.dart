// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/database/profile/profile.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../organisms/profile/dialogs/profile_modal_dialog.dart';

class PositiveProfileActionsList extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const PositiveProfileActionsList({
    super.key,
    required this.profile,
  });

  final Profile profile;

  static const double kButtonListHeight = 42.0;

  @override
  Size get preferredSize => const Size.fromHeight(kButtonListHeight);

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
    appRouter.push(const AccountDetailsRoute());
  }

  Future<void> onFollowTapped() async {
    if (!mounted) {
      return;
    }

    final String targetUserId = widget.profile.flMeta?.id ?? '';
    final Logger logger = ref.read(loggerProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    logger.d('Follow tapped');

    if (targetUserId.isEmpty) {
      logger.e('Failed to follow user: targetUserId is empty');
      return;
    }

    setState(() {
      isBusy = true;
    });

    try {
      await relationshipController.followRelationship(targetUserId);
    } catch (e) {
      logger.e('Failed to follow user', e);
    } finally {
      setState(() {
        isBusy = false;
      });
    }
  }

  Future<void> onUnfollowTapped() async {
    if (!mounted) {
      return;
    }

    final String targetUserId = widget.profile.flMeta?.id ?? '';
    final Logger logger = ref.read(loggerProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    logger.d('Unfollow tapped');

    if (targetUserId.isEmpty) {
      logger.e('Failed to unfollow user: targetUserId is empty');
      return;
    }

    setState(() {
      isBusy = true;
    });

    try {
      await relationshipController.unfollowRelationship(targetUserId);
    } catch (e) {
      logger.e('Failed to unfollow user', e);
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

    final String targetUserId = widget.profile.flMeta?.id ?? '';
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
      logger.e('Failed to connect user', e);
    } finally {
      setState(() {
        isBusy = false;
      });
    }
  }

  Future<void> onDisconnectTapped() async {
    if (!mounted) {
      return;
    }

    final String targetUserId = widget.profile.flMeta?.id ?? '';
    final Logger logger = ref.read(loggerProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    logger.d('Disconnect tapped');

    if (targetUserId.isEmpty) {
      logger.e('Failed to disconnect user: targetUserId is empty');
      return;
    }

    setState(() {
      isBusy = true;
    });

    try {
      await relationshipController.disconnectRelationship(targetUserId);
    } catch (e) {
      logger.e('Failed to disconnect user', e);
    } finally {
      setState(() {
        isBusy = false;
      });
    }
  }

  Future<void> onMessageTapped() async {
    if (!mounted) {
      return;
    }

    // TODO
  }

  Future<void> onMoreActionsTapped() async {
    if (!mounted) {
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    logger.d('User profile modal requested: ${widget.profile}');

    await PositiveDialog.show(context: context, dialog: ProfileModalDialog(profile: widget.profile));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((design) => design.colors));
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final RelationshipControllerState relationshipController = ref.watch(relationshipControllerProvider);

    bool isCurrentUser = false;
    bool isFollowing = false;
    bool isConnected = false;

    if (widget.profile.flMeta?.id?.isNotEmpty ?? false) {
      isCurrentUser = widget.profile.flMeta!.id == firebaseAuth.currentUser?.uid;
      isFollowing = relationshipController.following.contains(widget.profile.flMeta!.id);
      isConnected = relationshipController.connections.contains(widget.profile.flMeta!.id);
    }

    final List<Widget> children = <Widget>[];

    //* Add the optional edit profile button
    if (isCurrentUser) {
      final Widget editProfileAction = PositiveButton(
        colors: colors,
        primaryColor: colors.black,
        onTapped: onEditProfileTapped,
        label: localizations.page_account_actions_edit_profile,
        icon: UniconsLine.pen,
        layout: PositiveButtonLayout.iconLeft,
        size: PositiveButtonSize.medium,
        forceIconPadding: true,
        isDisabled: isBusy,
      );

      children.add(editProfileAction);
    }

    // Add the optional follow action
    if (!isCurrentUser && !isFollowing) {
      final Widget followAction = PositiveButton(
        colors: colors,
        primaryColor: colors.black,
        onTapped: onFollowTapped,
        label: localizations.shared_actions_follow,
        icon: UniconsLine.plus_circle,
        layout: PositiveButtonLayout.iconLeft,
        size: PositiveButtonSize.medium,
        forceIconPadding: true,
        isDisabled: isBusy,
      );

      children.add(followAction);
    }

    // Add the optional unfollow action
    if (!isCurrentUser && isFollowing) {
      final Widget unfollowAction = PositiveButton(
        colors: colors,
        primaryColor: colors.teal,
        onTapped: onUnfollowTapped,
        icon: UniconsLine.check_circle,
        tooltip: localizations.shared_actions_unfollow,
        layout: PositiveButtonLayout.iconOnly,
        size: PositiveButtonSize.medium,
        isDisabled: isBusy,
      );

      children.add(unfollowAction);
    }

    // Add the optional connect action
    if (!isCurrentUser && !isConnected) {
      final Widget connectAction = PositiveButton(
        colors: colors,
        primaryColor: colors.black,
        onTapped: onConnectTapped,
        label: localizations.shared_actions_connect,
        icon: UniconsLine.user_plus,
        layout: PositiveButtonLayout.iconLeft,
        size: PositiveButtonSize.medium,
        forceIconPadding: true,
        isDisabled: isBusy,
      );

      children.add(connectAction);
    }

    // Add the optional disconnect action
    if (!isCurrentUser && isConnected) {
      final Widget disconnectAction = PositiveButton(
        colors: colors,
        primaryColor: colors.teal,
        onTapped: onDisconnectTapped,
        icon: UniconsLine.user_check,
        tooltip: localizations.shared_actions_disconnect,
        layout: PositiveButtonLayout.iconOnly,
        size: PositiveButtonSize.medium,
        isDisabled: isBusy,
      );

      children.add(disconnectAction);
    }

    // Add the more actions button
    if (!isCurrentUser) {
      final Widget moreActionsButton = PositiveButton(
        colors: colors,
        primaryColor: colors.black,
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
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingLarge),
        scrollDirection: Axis.horizontal,
        children: children.spaceWithHorizontal(kPaddingSmall),
      ),
    );
  }
}
