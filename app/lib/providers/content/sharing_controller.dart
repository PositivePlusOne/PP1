// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/profile_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/universal_links_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/services/reaction_api_service.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/state/positive_community_feed_state.dart';

part 'sharing_controller.freezed.dart';
part 'sharing_controller.g.dart';

@freezed
class SharingControllerState with _$SharingControllerState {
  const factory SharingControllerState() = _SharingControllerState;

  factory SharingControllerState.initialState() => const SharingControllerState();
}

abstract class ISharingController {
  SharingControllerState build();
  Rect getShareTarget(BuildContext context);
  Future<ShareMessage> getShareMessage(BuildContext context, ShareTarget target, {SharePostOptions? postOptions});
  Iterable<Widget> buildShareActions(BuildContext context, Rect origin, ShareTarget target, {SharePostOptions? postOptions});
  Iterable<Widget> buildSharePostActions(BuildContext context, Rect origin, SharePostOptions postOptions);
  Future<void> showShareDialog(BuildContext context, ShareTarget target, {SharePostOptions? postOptions});
  Future<void> shareExternally(BuildContext context, ShareTarget target, Rect origin, {SharePostOptions? postOptions});
  Future<void> shareToFeed(BuildContext context, {SharePostOptions? postOptions});
  Future<void> shareViaConnections(BuildContext context, {SharePostOptions? postOptions});
  Future<void> shareViaConnectionChat(BuildContext context, Profile? currentProfile, Activity activity, String origin, List<String> profileIds);
}

enum ShareTarget {
  post,
}

typedef SharePostOptions = ({
  Activity activity,
  String origin,
  Profile? currentProfile,
  User? currentUser,
});

typedef ShareMessage = (String title, String message);

@Riverpod(keepAlive: true)
class SharingController extends _$SharingController implements ISharingController {
  @override
  SharingControllerState build() {
    return SharingControllerState.initialState();
  }

  @override
  Rect getShareTarget(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  @override
  Future<ShareMessage> getShareMessage(BuildContext context, ShareTarget target, {SharePostOptions? postOptions}) async {
    // final AppLocalizations localizations = AppLocalizations.of(context)!;
    final UniversalLinksController universalLinksController = ref.read(universalLinksControllerProvider.notifier);
    String displayName = getSafeDisplayNameFromProfile(postOptions?.currentProfile);

    // create the link to the post
    final String externalLink = switch (target) {
      ShareTarget.post => universalLinksController
          .buildPostRouteLink(
            postOptions!.activity.flMeta?.id ?? '',
            '',
            postOptions.origin,
          )
          .toString(),
    };

    // returning the message as created with the author and external link
    final localizations = AppLocalizations.of(context)!;
    return (localizations.post_share_message_title, localizations.post_share_message_content(displayName, externalLink));
  }

  @override
  List<Widget> buildShareActions(BuildContext context, Rect origin, ShareTarget target, {SharePostOptions? postOptions}) {
    return switch (target) {
      ShareTarget.post => buildSharePostActions(context, origin, postOptions),
    };
  }

  @override
  List<Widget> buildSharePostActions(BuildContext context, Rect origin, SharePostOptions? postOptions) {
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final CommunitiesControllerProvider communitiesControllerProvider = CommunitiesControllerProvider(
      currentUserId: postOptions?.currentUser?.uid ?? '',
      currentProfileId: postOptions?.currentProfile?.flMeta?.id ?? '',
      isManagedProfile: profileController.isCurrentlyManagedProfile,
    );

    final CommunitiesController communitiesController = providerContainer.read(communitiesControllerProvider.notifier);
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    final PositiveCommunityFeedState feedState = communitiesController.getCommunityFeedStateForType(communityType: CommunityType.connected, profile: postOptions?.currentProfile);
    final bool hasConnections = feedState.pagingController.value.itemList?.isNotEmpty == true;
    final bool hasValidProfile = profileController.state.currentProfile != null;

    // sharing is complicated, so can we share this activity as this user?
    final ActivitySecurityConfigurationMode? shareMode = postOptions?.activity.securityConfiguration?.shareMode;
    final bool canActShare = shareMode != null &&
        hasValidProfile &&
        shareMode.canActOnActivity(
          activity: postOptions?.activity,
          currentProfile: profileController.state.currentProfile,
          publisherRelationship: postOptions?.activity.getPublisherRelationship(profileController.state.currentProfile!),
        );

    return [
      if (hasValidProfile) ...<Widget>[
        PositiveButton.standardPrimaryWithIcon(
          colors: colors,
          label: 'Repost on Your Feed',
          icon: UniconsLine.file_share_alt,
          onTapped: () => shareToFeed(context, postOptions: postOptions),
          isDisabled: !canActShare,
        ),
      ],
      if (hasConnections) ...<Widget>[
        PositiveButton.standardPrimaryWithIcon(
          colors: colors,
          label: 'Share with a Connection',
          icon: UniconsLine.chat_bubble_user,
          onTapped: () => shareViaConnections(context, postOptions: postOptions),
          isDisabled: !canActShare,
        ),
      ],
      PositiveButton.standardPrimaryWithIcon(
        colors: colors,
        label: 'Share Via...',
        icon: UniconsLine.share_alt,
        onTapped: () => shareExternally(context, ShareTarget.post, origin, postOptions: postOptions),
        isDisabled: !canActShare,
      ),
    ];
  }

  @override
  Future<void> showShareDialog(BuildContext context, ShareTarget target, {SharePostOptions? postOptions}) async {
    final Logger logger = ref.read(loggerProvider);
    final Rect targetRect = getShareTarget(context);
    final List<Widget> actions = buildShareActions(context, targetRect, target, postOptions: postOptions);

    logger.i('Showing share dialog');
    await PositiveDialog.show(
      context: context,
      child: Column(
        children: actions.spaceWithVertical(kPaddingMedium),
      ),
    );
  }

  @override
  Future<void> shareExternally(BuildContext context, ShareTarget target, Rect origin, {SharePostOptions? postOptions}) async {
    final Logger logger = ref.read(loggerProvider);
    final ShareMessage message = await getShareMessage(context, target, postOptions: postOptions);
    final AppRouter appRouter = ref.read(appRouterProvider);

    final String title = message.$1;
    final String text = message.$2;

    logger.i('Sharing externally');
    await appRouter.pop();

    Future<void>.delayed(kAnimationDurationDebounce, () {
      Share.share(text, subject: title, sharePositionOrigin: origin);
    });
  }

  @override
  Future<void> shareViaConnections(BuildContext context, {SharePostOptions? postOptions}) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    logger.d('Sharing via connections');

    final String activityID = postOptions?.activity.flMeta?.id ?? '';
    final String origin = postOptions?.origin ?? '';
    if (activityID.isEmpty || origin.isEmpty) {
      throw Exception('Activity is missing an ID');
    }

    await appRouter.pop();
    Future<void>.delayed(kAnimationDurationDebounce, () {
      appRouter.push(PostShareRoute(activityId: activityID, origin: origin));
    });
  }

  @override
  Future<void> shareViaConnectionChat(BuildContext context, Profile? currentProfile, Activity activity, String origin, List<String> profileIds) async {
    final Logger logger = ref.read(loggerProvider);
    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    logger.d('Sharing via connection chat');
    final SharePostOptions postOptions = (activity: activity, origin: origin, currentProfile: currentProfile, currentUser: firebaseAuth.currentUser);
    final ShareMessage message = await getShareMessage(context, ShareTarget.post, postOptions: postOptions);

    final String title = message.$1;
    final String text = message.$2;

    await reactionApiService.sharePostToConversations(
      activityId: activity.flMeta!.id!,
      targets: profileIds,
      title: title,
      description: text,
    );
  }

  @override
  Future<void> shareToFeed(BuildContext context, {SharePostOptions? postOptions}) async {
    final Logger logger = ref.read(loggerProvider);
    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    final AppRouter appRouter = ref.read(appRouterProvider);

    if (postOptions == null) {
      throw Exception('Post options must be provided');
    }

    final String activityId = postOptions.activity.flMeta?.id ?? '';
    logger.d('Sharing activity $activityId to feed');
    if (activityId.isEmpty) {
      throw Exception('Activity is missing an ID');
    }

    await postOptions.activity.onRequestPostSharedToFeed(repostActivityId: activityId);
  }
}
