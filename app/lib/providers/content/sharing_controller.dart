// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
import 'package:app/providers/content/universal_links_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/services/reaction_api_service.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';

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

typedef SharePostOptions = (Activity activity, String origin, String currentProfileId);
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
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final sourceUid = postOptions?.$3;
    String displayName = getSafeDisplayNameFromProfile(profileController.state.currentProfile);
    if (sourceUid != null) {
      // there is a third variable in the options - this being the author of the post - so let's show this as the source of the post
      final sourceProfile = await profileController.getProfile(sourceUid);
      displayName = getSafeDisplayNameFromProfile(sourceProfile);
    }
    // create the link to the post
    final String externalLink = switch (target) {
      ShareTarget.post => universalLinksController
          .buildPostRouteLink(
            postOptions!.$1.flMeta!.id!,
            '',
            postOptions.$2,
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
    final CommunitiesController communitiesController = ref.read(communitiesControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final bool hasConnections = communitiesController.state.connectedProfileIds.isNotEmpty;
    final bool hasValidProfile = profileController.state.currentProfile != null;

    return [
      if (hasValidProfile) ...<Widget>[
        PositiveButton.standardPrimaryWithIcon(
          colors: colors,
          label: 'Repost on Your Feed',
          icon: UniconsLine.file_share_alt,
          onTapped: () => shareToFeed(context, postOptions: postOptions),
        ),
      ],
      if (hasConnections) ...<Widget>[
        PositiveButton.standardPrimaryWithIcon(
          colors: colors,
          label: 'Share with a Connection',
          icon: UniconsLine.chat_bubble_user,
          onTapped: () => shareViaConnections(context, postOptions: postOptions),
        ),
      ],
      PositiveButton.standardPrimaryWithIcon(
        colors: colors,
        label: 'Share Via...',
        icon: UniconsLine.share_alt,
        onTapped: () => shareExternally(context, ShareTarget.post, origin, postOptions: postOptions),
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

    final String activityID = postOptions?.$1.flMeta?.id ?? '';
    final String origin = postOptions?.$2 ?? '';
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

    logger.d('Sharing via connection chat');
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final SharePostOptions postOptions = (activity, origin, currentProfileId);
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

    logger.d('Sharing to feed');
    final String activityId = postOptions.$1.flMeta?.id ?? '';
    if (activityId.isEmpty) {
      throw Exception('Activity is missing an ID');
    }

    final EndpointResponse response = await reactionApiService.sharePostToFeed(activityId: activityId);
    final List activityDataRaw = response.data.containsKey('activities') ? response.data['activities'] as List<dynamic> : [];
    final List<Activity> activities = activityDataRaw.map((dynamic data) => Activity.fromJson(json.decodeSafe(data))).toList();
    final Activity? sharedActivity = activities.firstOrNull;

    sharedActivity?.appendActivityToProfileFeeds(postOptions.$3);

    await appRouter.pop();

    Future<void>.delayed(kAnimationDurationDebounce, () {
      ScaffoldMessenger.of(context).showSnackBar(PositiveSnackBar(content: const Text('Post shared to your feed')));
    });
  }
}
