// Flutter imports:
import 'package:app/extensions/profile_extensions.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/annotations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/behaviours/positive_comment_pagination_behaviour.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
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

    final PostViewModel viewModel = ref.read(provider.notifier);
    final PostViewModelState state = ref.watch(provider);

    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);
    final List<Widget> actions = [];

    if (profileControllerState.currentProfile != null) {
      actions.addAll(profileControllerState.currentProfile!.buildCommonProfilePageActions());
    }

    return PositiveScaffold(
      isBusy: state.isBusy,
      onRefresh: viewModel.onRefresh,
      refreshController: viewModel.refreshController,
      refreshBackgroundColor: colors.white,
      visibleComponents: const {
        PositiveScaffoldComponent.headingWidgets,
        PositiveScaffoldComponent.decorationWidget,
        PositiveScaffoldComponent.footerPadding,
      },
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          horizontalPadding: kPaddingNone,
          appBarSpacing: kPaddingNone,
          appBarLeading: PositiveButton.appBarIcon(
            colors: colors,
            primaryColor: colors.black,
            icon: UniconsLine.angle_left_b,
            onTapped: () => router.removeLast(),
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
            Padding(
              padding: const EdgeInsets.all(kPaddingMedium),
              child: PositiveTextField(
                hintText: 'Write a comment...',
                textEditingController: viewModel.commentTextController,
                onTextChanged: viewModel.onCommentChanged,
                onTextSubmitted: (_) => viewModel.onPostCommentRequested(),
                isEnabled: !state.isBusy,
              ),
            ),
          ],
        ),
        if (activity.flMeta?.id?.isNotEmpty ?? false) ...<Widget>[
          PositiveCommentPaginationBehaviour(
            activityId: activity.flMeta!.id!,
            refreshController: viewModel.refreshController,
            feed: feed,
          ),
        ],
      ],
    );
  }
}
