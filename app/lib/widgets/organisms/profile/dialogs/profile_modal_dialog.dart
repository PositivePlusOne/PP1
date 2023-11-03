// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/profile/dialogs/post_report_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_block_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_hide_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_report_dialog.dart';
import '../../../../gen/app_router.dart';
import '../../../../providers/system/design_controller.dart';
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

class ProfileModalDialog extends StatefulHookConsumerWidget {
  const ProfileModalDialog({
    required this.targetProfileId,
    required this.currentProfileId,
    this.activityId = '',
    this.styleOverrides = const {},
    this.types,
    super.key,
  });

  final String currentProfileId;
  final String targetProfileId;
  final String activityId;

  final Map<ProfileModalDialogOptionType, ProfileModalDialogOption> styleOverrides;
  final Set<ProfileModalDialogOptionType>? types;
  static const String kProfileDialogHeroTag = 'profile_modal_dialog';

  @override
  ProfileModalDialogState createState() => ProfileModalDialogState();
}

class ProfileModalDialogState extends ConsumerState<ProfileModalDialog> {
  bool isBusy = false;

  static const kDefaultProfileModalActions = {
    ProfileModalDialogOptionType.viewProfile,
    ProfileModalDialogOptionType.follow,
    ProfileModalDialogOptionType.connect,
    ProfileModalDialogOptionType.message,
    ProfileModalDialogOptionType.block,
    ProfileModalDialogOptionType.report,
    ProfileModalDialogOptionType.hidePosts,
  };

  static const kDefaultOrganisationModalActions = {
    ProfileModalDialogOptionType.viewProfile,
    ProfileModalDialogOptionType.follow,
    ProfileModalDialogOptionType.message,
    ProfileModalDialogOptionType.block,
    ProfileModalDialogOptionType.report,
  };

  Future<void> onOptionSelected({
    required ProfileModalDialogOptionType type,
    required Profile? currentProfile,
    required Profile targetProfile,
    required Relationship? targetRelationship,
  }) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final BuildContext context = appRouter.navigatorKey.currentContext!;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final String targetProfileId = targetProfile.flMeta?.id ?? '';
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';

    if (!mounted || targetProfileId.isEmpty) {
      return;
    }

    setState(() {
      isBusy = true;
    });

    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final ActivitiesController activitiesController = ref.read(activitiesControllerProvider.notifier);
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);
    final Set<RelationshipState> relationshipStates = targetRelationship?.relationshipStatesForEntity(currentProfileId) ?? {};

    final String targetDisplayNameHandle = targetProfile.displayName.asHandle;

    try {
      switch (type) {
        case ProfileModalDialogOptionType.viewProfile:
          await appRouter.pop();
          await ref.read(profileControllerProvider.notifier).viewProfile(targetProfile);
          break;
        case ProfileModalDialogOptionType.follow:
          var following = relationshipStates.contains(RelationshipState.sourceFollowed);
          following ? await relationshipController.unfollowRelationship(targetProfileId) : await relationshipController.followRelationship(targetProfileId);
          await activitiesController.resetProfileFeeds(profileId: currentProfileId);
          await appRouter.pop();
          ScaffoldMessenger.of(context).showSnackBar(PositiveFollowSnackBar(text: '${!following ? 'You are now' : 'You have stopped'} following $targetDisplayNameHandle'));
          break;
        case ProfileModalDialogOptionType.connect:
          relationshipStates.contains(RelationshipState.sourceConnected) ? await relationshipController.disconnectRelationship(targetProfileId) : await relationshipController.connectRelationship(targetProfileId);
          await appRouter.pop();
          await activitiesController.resetProfileFeeds(profileId: currentProfileId);
          break;
        case ProfileModalDialogOptionType.message:
          await getStreamController.createConversation([targetProfileId], shouldPopDialog: true);
          break;
        case ProfileModalDialogOptionType.block:
          final bool hasSourceBlocked = relationshipStates.contains(RelationshipState.sourceBlocked);
          if (!hasSourceBlocked) {
            await appRouter.pop();
            await PositiveDialog.show(
              context: context,
              useSafeArea: false,
              title: localizations.shared_profile_modal_action_block(targetDisplayNameHandle),
              child: ProfileBlockDialog(
                targetProfileId: targetProfileId,
                currentProfileId: currentProfileId,
              ),
            );
          } else {
            await relationshipController.unblockRelationship(targetProfileId);
            await appRouter.pop();
            ScaffoldMessenger.of(context).showSnackBar(PositiveFollowSnackBar(text: '${relationshipStates.contains(RelationshipState.sourceBlocked) ? 'You have unblocked' : 'You have blocked'} $targetDisplayNameHandle'));
            await activitiesController.resetProfileFeeds(profileId: currentProfileId);
          }
          break;
        case ProfileModalDialogOptionType.mute:
          relationshipStates.contains(RelationshipState.sourceMuted) ? await relationshipController.unmuteRelationship(targetProfileId) : await relationshipController.muteRelationship(targetProfileId);
          await appRouter.pop();
          ScaffoldMessenger.of(context).showSnackBar(PositiveFollowSnackBar(text: '${relationshipStates.contains(RelationshipState.sourceMuted) ? 'You have unmuted' : 'You have muted'} $targetDisplayNameHandle'));
          break;
        case ProfileModalDialogOptionType.hidePosts:
          if (!relationshipStates.contains(RelationshipState.sourceHidden)) {
            await appRouter.pop();
            await PositiveDialog.show(
              context: context,
              useSafeArea: false,
              title: localizations.shared_profile_hide_modal_title(targetDisplayNameHandle),
              child: ProfileHideDialog(
                targetProfileId: targetProfileId,
                currentProfileId: currentProfileId,
              ),
            );
          } else {
            await relationshipController.unhideRelationship(targetProfileId);
            await appRouter.pop();
            ScaffoldMessenger.of(context).showSnackBar(PositiveFollowSnackBar(text: '${relationshipStates.contains(RelationshipState.sourceHidden) ? 'You have unhidden' : 'You have hidden'} $targetDisplayNameHandle\'s posts'));
          }
          break;
        case ProfileModalDialogOptionType.report:
          await appRouter.pop();
          await PositiveDialog.show(
            context: context,
            useSafeArea: false,
            title: localizations.shared_profile_report_modal_title(targetDisplayNameHandle),
            child: ProfileReportDialog(
              currentProfileId: currentProfileId,
              targetProfileId: targetProfileId,
            ),
          );
          break;
        case ProfileModalDialogOptionType.reportPost:
          if (widget.activityId.isEmpty) {
            await appRouter.pop();
            break;
          }

          await appRouter.pop();
          await PositiveDialog.show(
            context: context,
            useSafeArea: false,
            title: localizations.post_report_dialog_title,
            child: PostReportDialog(
              targetPost: widget.activityId,
              currentProfile: currentProfile,
              targetProfile: targetProfile,
            ),
          );
          break;
      }
    } finally {
      if (mounted) {
        setState(() => isBusy = false);
      }
    }
  }

  bool canDisplayOptionType({
    required Profile? currentProfile,
    required Profile targetProfile,
    required Relationship? targetRelationship,
    required ProfileModalDialogOptionType option,
  }) {
    final String targetProfileId = targetProfile.flMeta?.id ?? '';
    final String currentProfileID = currentProfile?.flMeta?.id ?? '';
    final bool isSelf = targetProfileId == currentProfileID;

    if (targetProfileId.isEmpty || isSelf) {
      return false;
    }

    final Set<RelationshipState> relationshipStates = targetRelationship?.relationshipStatesForEntity(currentProfileID) ?? {};
    final bool isSourceBlocked = relationshipStates.contains(RelationshipState.sourceBlocked);
    final bool isTargetBlocked = relationshipStates.contains(RelationshipState.targetBlocked);
    final bool isBlocked = isSourceBlocked || isTargetBlocked;
    final bool isConnected = relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected);

    final bool isSourceOrganisation = currentProfile?.isOrganisation ?? false;
    final bool isTargetOrganisation = targetProfile.isOrganisation;
    final bool relationshipContainsOrganisation = isSourceOrganisation || isTargetOrganisation;

    switch (option) {
      case ProfileModalDialogOptionType.connect:
        return !relationshipContainsOrganisation;
      case ProfileModalDialogOptionType.follow:
      case ProfileModalDialogOptionType.mute:
      case ProfileModalDialogOptionType.viewProfile:
        return !isBlocked;
      case ProfileModalDialogOptionType.message:
        return !isBlocked && (isConnected || relationshipContainsOrganisation);
      default:
        break;
    }

    return true;
  }

  Widget buildOption({
    required Profile? currentProfile,
    required Profile targetProfile,
    required Relationship? targetRelationship,
    required AppLocalizations localizations,
    required DesignColorsModel colors,
    required ProfileModalDialogOptionType type,
  }) {
    final String targetProfileId = targetProfile.flMeta?.id ?? '';
    final String targetProfileDisplayNameHandle = targetProfile.displayName.asHandle;
    if (targetProfileId.isEmpty) {
      return const SizedBox.shrink();
    }

    final Set<RelationshipState> relationshipStates = targetRelationship?.relationshipStatesForEntity(currentProfile?.flMeta?.id ?? '') ?? {};
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
            onTapped: () => onOptionSelected(
              type: type,
              currentProfile: currentProfile,
              targetProfile: targetProfile,
              targetRelationship: targetRelationship,
            ),
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
        onTapped: () => onOptionSelected(
          type: type,
          currentProfile: currentProfile,
          targetProfile: targetProfile,
          targetRelationship: targetRelationship,
        ),
        isDisabled: isBusy || isDisabled,
      );
    }

    switch (type) {
      case ProfileModalDialogOptionType.viewProfile:
        return buttonFromOptionType(type, UniconsLine.user_circle, localizations.shared_profile_modal_action_view_profile);
      case ProfileModalDialogOptionType.follow:
        return buttonFromOptionType(type, UniconsLine.user_plus, isFollowing ? localizations.shared_profile_modal_action_unfollow(targetProfileDisplayNameHandle) : localizations.shared_profile_modal_action_follow(targetProfileDisplayNameHandle), highlightOption: isFollowing);
      case ProfileModalDialogOptionType.connect:
        String label = isConnected ? localizations.shared_profile_modal_action_disconnect : localizations.shared_profile_modal_action_connect;
        if (isPendingConnection) {
          label = localizations.shared_actions_connection_pending;
        }

        return buttonFromOptionType(type, UniconsLine.link, label, highlightOption: isConnected, isDisabled: isPendingConnection);
      case ProfileModalDialogOptionType.message:
        return buttonFromOptionType(type, UniconsLine.envelope, localizations.shared_profile_modal_action_message(targetProfileDisplayNameHandle));
      case ProfileModalDialogOptionType.block:
        return buttonFromOptionType(type, UniconsLine.ban, isSourceBlocked ? localizations.shared_profile_modal_action_unblock(targetProfileDisplayNameHandle) : localizations.shared_profile_modal_action_block(targetProfileDisplayNameHandle), highlightOption: isSourceBlocked);
      case ProfileModalDialogOptionType.report:
        return buttonFromOptionType(type, UniconsLine.exclamation_circle, localizations.shared_profile_modal_action_report(targetProfileDisplayNameHandle));
      case ProfileModalDialogOptionType.reportPost:
        return buttonFromOptionType(type, UniconsLine.exclamation_circle, localizations.shared_profile_modal_action_report_post);
      case ProfileModalDialogOptionType.hidePosts:
        return buttonFromOptionType(type, isHidden ? UniconsLine.eye_slash : UniconsLine.eye, isHidden ? localizations.shared_profile_modal_action_unhide_posts(targetProfileDisplayNameHandle) : localizations.shared_profile_modal_action_hide_posts(targetProfileDisplayNameHandle), highlightOption: isHidden);
      case ProfileModalDialogOptionType.mute:
        return buttonFromOptionType(type, isMuted ? UniconsLine.volume : UniconsLine.volume_mute, isMuted ? localizations.shared_profile_modal_action_unmute(targetProfileDisplayNameHandle) : localizations.shared_profile_modal_action_mute(targetProfileDisplayNameHandle), highlightOption: isMuted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);
    final Profile? currentProfile = profileControllerState.currentProfile;
    final Profile? targetProfile = cacheController.get(widget.targetProfileId);

    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final String targetProfileId = targetProfile?.flMeta?.id ?? '';
    final String relationshipId = [currentProfileId, targetProfileId].asGUID;
    final Relationship? targetRelationship = cacheController.get(relationshipId);

    final List<Widget> children = [];
    final List<ProfileModalDialogOptionType> optionTypes = [];

    if (widget.types != null) {
      optionTypes.addAll(widget.types!);
    } else if (currentProfile?.isOrganisation == true) {
      optionTypes.addAll(kDefaultOrganisationModalActions);
    } else {
      optionTypes.addAll(kDefaultProfileModalActions);
    }

    // You can't connect to an organisation
    if (targetProfile?.isOrganisation == true) {
      optionTypes.remove(ProfileModalDialogOptionType.connect);
    }

    final List<String> expectedCacheKeys = buildExpectedCacheKeysForProfile(currentProfile, targetProfile ?? Profile.empty());
    useCacheHook(keys: expectedCacheKeys);

    // Order the options based on the order of the types
    optionTypes.sort((a, b) => a.order.compareTo(b.order));

    for (final ProfileModalDialogOptionType optionType in optionTypes) {
      if (targetProfile == null) {
        continue;
      }

      final bool canDisplay = canDisplayOptionType(
        option: optionType,
        currentProfile: currentProfile,
        targetProfile: targetProfile,
        targetRelationship: targetRelationship,
      );

      if (canDisplay) {
        final option = buildOption(
          colors: colors,
          currentProfile: currentProfile,
          localizations: localizations,
          targetProfile: targetProfile,
          targetRelationship: targetRelationship,
          type: optionType,
        );

        children.add(option);
      }
    }

    return Column(
      children: children.spaceWithVertical(kPaddingMedium),
    );
  }
}
