// Flutter imports:
import 'dart:math';

import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/annotations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/behaviours/positive_comment_pagination_behaviour.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/post/post_comment_box.dart';
import 'package:app/widgets/organisms/post/vms/post_view_model.dart';
import '../../../providers/profiles/profile_controller.dart';

@RoutePage()
class PostPage extends ConsumerWidget {
  const PostPage({
    required this.activity,
    required this.feed,
    super.key,
  });

  final Activity activity;
  final TargetFeed feed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final AppRouter router = ref.read(appRouterProvider);

    final PostViewModelProvider provider = postViewModelProvider(activity.flMeta!.id!, feed);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    final PostViewModel viewModel = ref.read(provider.notifier);
    final PostViewModelState state = ref.watch(provider);

    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);
    final List<Widget> actions = [];

    if (profileControllerState.currentProfile != null) {
      actions.addAll(profileControllerState.currentProfile!.buildCommonProfilePageActions());
    }

    final String publisherID = activity.publisherInformation?.publisherId ?? '';
    final String userID = profileControllerState.currentProfile?.flMeta?.id ?? '';

    final List<String> members = [publisherID, userID];
    final Relationship relationship = cacheController.getFromCache(members.asGUID) ?? Relationship.empty(members);

    late bool isCommentsEnabled;
    late bool isUserAbleToComment;

    switch (activity.securityConfiguration?.commentMode) {
      case const ActivitySecurityConfigurationMode.public():
        isUserAbleToComment = true;
        isCommentsEnabled = true;
        break;
      case const ActivitySecurityConfigurationMode.connections():
        isUserAbleToComment = relationship.connected;
        isCommentsEnabled = true;
        break;
      case const ActivitySecurityConfigurationMode.followersAndConnections():
        isUserAbleToComment = relationship.connected || relationship.following;
        isCommentsEnabled = true;
        break;
      default:
        isUserAbleToComment = false;
        isCommentsEnabled = false;
    }

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double maxSafePadding = PostCommentBox.calculateHeight(mediaQuery);

    return PositiveScaffold(
      isBusy: state.isBusy,
      onWillPopScope: viewModel.onWillPopScope,
      visibleComponents: const {
        PositiveScaffoldComponent.headingWidgets,
        PositiveScaffoldComponent.decorationWidget,
      },
      decorationColor: colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: isCommentsEnabled && isUserAbleToComment
          ? PostCommentBox(
              mediaQuery: MediaQuery.of(context),
              commentTextController: viewModel.commentTextController,
              onCommentChanged: viewModel.onCommentChanged,
              onPostCommentRequested: (_) => viewModel.onPostCommentRequested(),
              isBusy: state.isBusy,
            )
          : null,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          horizontalPadding: kPaddingNone,
          appBarSpacing: kPaddingNone,
          appBarLeading: PositiveButton.appBarIcon(
            colors: colors,
            primaryColor: colors.black,
            icon: UniconsLine.angle_left_b,
            onTapped: () => viewModel.onWillPopScope(),
          ),
          appBarTrailing: [
            for (final Widget actionWidget in actions) ...<Widget>[
              Align(
                alignment: Alignment.center,
                child: actionWidget,
              ),
            ],
          ],
          children: <Widget>[
            PositiveActivityWidget(
              activity: activity,
              targetFeed: feed,
              isFullscreen: true,
              isEnabled: !state.isBusy,
              onHeaderTapped: () {},
              onImageTapped: (media) => router.push(MediaRoute(media: media)),
            ),
          ],
        ),
        if ((activity.flMeta?.id?.isNotEmpty ?? false) && isCommentsEnabled) ...<Widget>[
          const SliverToBoxAdapter(
            child: SizedBox(height: kPaddingSmall),
          ),
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(kBorderRadiusMassive),
                  ),
                ),
                width: kPaddingMassive,
                height: kPaddingExtraSmall,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: kPaddingExtraSmall)),
          PositiveCommentPaginationBehaviour(
            commentMode: activity.securityConfiguration?.commentMode,
            activityId: activity.flMeta!.id!,
            feed: feed,
          ),

          //! Apply extra padding for the comment box assuming one line height.
          SliverToBoxAdapter(child: Container(height: maxSafePadding + kPaddingMedium, color: colors.white)),
        ],
      ],
    );
  }
}
