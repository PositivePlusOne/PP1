// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/annotations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/behaviours/positive_reaction_pagination_behaviour.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/post/post_comment_box.dart';
import 'package:app/widgets/organisms/post/vms/post_view_model.dart';
import '../../../providers/profiles/profile_controller.dart';

@RoutePage()
class PostPage extends HookConsumerWidget {
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

    final PostViewModel viewModel = ref.read(provider.notifier);
    final PostViewModelState state = ref.watch(provider);
    useLifecycleHook(viewModel);

    final Activity updatedActivity = state.activity ?? activity;

    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);
    final List<Widget> actions = [];

    if (profileControllerState.currentProfile != null) {
      actions.addAll(profileControllerState.currentProfile!.buildCommonProfilePageActions());
    }

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double maxSafePadding = PostCommentBox.calculateHeight(mediaQuery);

    final bool commentsDisabled = updatedActivity.securityConfiguration?.commentMode == const ActivitySecurityConfigurationMode.disabled();
    final String activityId = updatedActivity.flMeta?.id ?? '';

    final bool canComment = viewModel.checkCanComment();

    return PositiveScaffold(
      isBusy: state.isBusy,
      onWillPopScope: viewModel.onWillPopScope,
      visibleComponents: const {
        PositiveScaffoldComponent.headingWidgets,
        PositiveScaffoldComponent.decorationWidget,
      },
      decorationColor: colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: !commentsDisabled && canComment
          ? PostCommentBox(
              mediaQuery: MediaQuery.of(context),
              commentTextController: viewModel.commentTextController,
              onCommentChanged: viewModel.onCommentTextChanged,
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
              activity: updatedActivity,
              targetFeed: feed,
              isFullscreen: true,
              isEnabled: !state.isBusy,
              onHeaderTapped: () {},
              onImageTapped: (media) => router.push(MediaRoute(media: media)),
            ),
          ],
        ),
        if (activityId.isNotEmpty) ...<Widget>[
          const SliverToBoxAdapter(child: SizedBox(height: kPaddingSmall)),
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
          PositiveReactionPaginationBehaviour(
            kind: 'comment',
            reactionMode: updatedActivity.securityConfiguration?.commentMode,
            activityId: activityId,
            feed: feed,
          ),

          //! Apply extra padding for the comment box assuming one line height.
          SliverToBoxAdapter(child: Container(height: maxSafePadding + kPaddingMedium, color: colors.white)),
        ],
      ],
    );
  }
}
