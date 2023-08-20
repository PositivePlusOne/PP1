// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/helpers/profile_helpers.dart';
import 'package:app/providers/content/universal_links_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
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
  ShareMessage getShareMessage(BuildContext context, ShareTarget target, {SharePostOptions? postOptions});
  Iterable<Widget> buildShareActions(BuildContext context, Rect origin, ShareTarget target, {SharePostOptions? postOptions});
  Iterable<Widget> buildSharePostActions(BuildContext context, Rect origin, SharePostOptions postOptions);
  Future<void> showShareDialog(BuildContext context, ShareTarget target, {SharePostOptions? postOptions});
  Future<void> shareExternally(BuildContext context, ShareTarget target, Rect origin, {SharePostOptions? postOptions});
  Future<void> shareToFeed(BuildContext context, {SharePostOptions? postOptions});
  Future<void> shareViaConnections(BuildContext context, {SharePostOptions? postOptions});
}

enum ShareTarget {
  post,
}

typedef SharePostOptions = (Activity activity, String feed);
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
  ShareMessage getShareMessage(BuildContext context, ShareTarget target, {SharePostOptions? postOptions}) {
    // final AppLocalizations localizations = AppLocalizations.of(context)!;
    final UniversalLinksController universalLinksController = ref.read(universalLinksControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final String displayName = getSafeDisplayNameFromProfile(profileController.state.currentProfile);
    final String externalLink = switch (target) {
      ShareTarget.post => universalLinksController.buildPostRouteLink(postOptions!.$1.flMeta!.id!, postOptions.$2).toString(),
    };

    //* Mock message, this is to be replaced with a proper message
    const String title = 'Psst!';
    final String message = 'Check out this post from $displayName.\n$externalLink';

    return (title, message);
  }

  @override
  List<Widget> buildShareActions(BuildContext context, Rect origin, ShareTarget target, {SharePostOptions? postOptions}) {
    return switch (target) {
      ShareTarget.post => buildSharePostActions(context, origin, postOptions!),
    };
  }

  @override
  List<Widget> buildSharePostActions(BuildContext context, Rect origin, SharePostOptions postOptions) {
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
    final ShareMessage message = getShareMessage(context, target, postOptions: postOptions);

    final String title = message.$1;
    final String text = message.$2;

    logger.i('Sharing externally');
    await Share.share(text, subject: title, sharePositionOrigin: origin);
  }

  @override
  Future<void> shareToFeed(BuildContext context, {SharePostOptions? postOptions}) async {}

  @override
  Future<void> shareViaConnections(BuildContext context, {SharePostOptions? postOptions}) async {}
}
