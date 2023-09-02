// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/widgets/organisms/profile/dialogs/post_report_dialog.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_report_dialog.dart';
import '../../../../gen/app_router.dart';
import '../../../../providers/system/design_controller.dart';
import '../../../../services/third_party.dart';
import '../../../atoms/indicators/positive_snackbar.dart';
import '../../../molecules/dialogs/positive_dialog.dart';

enum ProfileModalDialogOptionType {
  viewProfile(0),
  follow(1),
  connect(2),
  message(3),
  hidePosts(4),
  block(5),
  report(6),
  mute(7),
  reportPost(8);

  const ProfileModalDialogOptionType([this.order = 0]);

  final int order;
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
    this.postID = "",
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
  final String postID;

  final Set<ProfileModalDialogOptionType> types;

  static const String kProfileDialogHeroTag = 'profile_modal_dialog';

  @override
  ProfileModalDialogState createState() => ProfileModalDialogState();
}

class ProfileModalDialogState extends ConsumerState<ProfileModalDialog> {
  bool isBusy = false;
  late Relationship _currentRelationship;
  late final StreamSubscription<CacheKeyUpdatedEvent> _cacheUpdatedSubscription;

  @override
  void initState() {
    super.initState();

    _currentRelationship = widget.relationship;
    setupListeners();
  }

  void setupListeners() {
    final EventBus eventBus = ref.read(eventBusProvider);
    _cacheUpdatedSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyChanged);
  }

  @override
  void dispose() {
    _cacheUpdatedSubscription.cancel();
    super.dispose();
  }

  void onCacheKeyChanged(CacheKeyUpdatedEvent event) {
    final String key = widget.profile.flMeta?.id ?? '';
    if (!mounted || key.isEmpty) {
      return;
    }

    if (event.key.contains(key) && event.value is Relationship) {
      _currentRelationship = event.value;
      setState(() {});
    }
  }

  Future<void> onOptionSelected(ProfileModalDialogOptionType type) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final String flamelinkId = widget.profile.flMeta?.id ?? '';
    final BuildContext context = appRouter.navigatorKey.currentContext!;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    if (!mounted || flamelinkId.isEmpty) {
      return;
    }

    setState(() {
      isBusy = true;
    });

    final UserController userController = ref.read(userControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);
    final Set<RelationshipState> relationshipStates = _currentRelationship.relationshipStatesForEntity(userController.currentUser?.uid ?? '');

    try {
      switch (type) {
        case ProfileModalDialogOptionType.viewProfile:
          await appRouter.pop();
          await ref.read(profileControllerProvider.notifier).viewProfile(widget.profile);
          break;
        case ProfileModalDialogOptionType.follow:
          var following = relationshipStates.contains(RelationshipState.sourceFollowed);
          following ? await relationshipController.unfollowRelationship(flamelinkId) : await relationshipController.followRelationship(flamelinkId);
          ScaffoldMessenger.of(context).showSnackBar(PositiveFollowSnackBar(text: '${!following ? 'You are now' : 'You have stopped'} following ${widget.profile.displayName.asHandle}'));
          break;
        case ProfileModalDialogOptionType.connect:
          relationshipStates.contains(RelationshipState.sourceConnected) ? await relationshipController.disconnectRelationship(flamelinkId) : await relationshipController.connectRelationship(flamelinkId);
          break;
        case ProfileModalDialogOptionType.message:
          await getStreamController.createConversation([flamelinkId], shouldPopDialog: true);
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
          await appRouter.pop();
          await PositiveDialog.show(
            context: context,
            useSafeArea: false,
            title: localizations.shared_profile_report_modal_title(widget.profile.displayName.asHandle),
            child: ProfileReportDialog(currentUserProfile: profileController.state.currentProfile!, targetProfile: widget.profile),
          );
          break;
        case ProfileModalDialogOptionType.reportPost:
          if (widget.postID.isEmpty) {
            await appRouter.pop();
            break;
          }
          await appRouter.pop();

          await PositiveDialog.show(
            context: context,
            useSafeArea: false,
            title: localizations.shared_profile_report_modal_title(widget.profile.displayName.asHandle),
            child: PostReportDialog(targetPost: widget.postID!, currentUserProfile: profileController.state.currentProfile!, targetProfile: widget.profile),
          );
          break;
      }
    } finally {
      if (mounted) {
        setState(() => isBusy = false);
      }
    }
  }

  bool canDisplayOptionType(RelationshipControllerState relationshipState, UserControllerState userControllerState, ProfileModalDialogOptionType option) {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final String flamelinkId = widget.profile.flMeta?.id ?? '';
    final String currentUserId = userController.currentUser?.uid ?? '';
    final bool isSelf = flamelinkId == currentUserId;

    if (flamelinkId.isEmpty || isSelf) {
      return false;
    }

    final String userId = userController.currentUser?.uid ?? '';
    final Set<RelationshipState> relationshipStates = _currentRelationship.relationshipStatesForEntity(userId);
    final bool isSourceBlocked = relationshipStates.contains(RelationshipState.sourceBlocked);
    final bool isTargetBlocked = relationshipStates.contains(RelationshipState.targetBlocked);
    final bool isBlocked = isSourceBlocked || isTargetBlocked;
    final bool isConnected = relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected);

    switch (option) {
      case ProfileModalDialogOptionType.connect:
      case ProfileModalDialogOptionType.follow:
      case ProfileModalDialogOptionType.mute:
      case ProfileModalDialogOptionType.viewProfile:
        return !isBlocked;
      case ProfileModalDialogOptionType.message:
        return !isBlocked && isConnected;
      default:
        break;
    }

    return true;
  }

  Widget buildOption(AppLocalizations localizations, RelationshipControllerState relationshipState, DesignColorsModel colors, ProfileModalDialogOptionType type) {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final String flamelinkId = widget.profile.flMeta?.id ?? '';
    final String displayName = widget.profile.displayName;
    if (flamelinkId.isEmpty) {
      return const SizedBox.shrink();
    }

    final String userId = userController.currentUser?.uid ?? '';
    final Set<RelationshipState> relationshipStates = _currentRelationship.relationshipStatesForEntity(userId);
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
            forceIconPadding: true,
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
        forceIconPadding: true,
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
      case ProfileModalDialogOptionType.reportPost:
        return buttonFromOptionType(type, UniconsLine.exclamation_circle, localizations.shared_profile_modal_action_report_post);
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

    final RelationshipControllerState relationshipState = ref.read(relationshipControllerProvider);
    final UserControllerState userControllerState = ref.read(userControllerProvider);

    final List<Widget> children = [];
    final List<ProfileModalDialogOptionType> optionTypes = widget.types.toList();

    // Order the options based on the order of the types
    optionTypes.sort((a, b) => a.order.compareTo(b.order));

    for (final ProfileModalDialogOptionType optionType in optionTypes) {
      if (canDisplayOptionType(relationshipState, userControllerState, optionType)) {
        children.add(buildOption(localizations, relationshipState, colors, optionType));
      }
    }

    return Column(
      children: children.spaceWithVertical(kPaddingMedium),
    );
  }
}
