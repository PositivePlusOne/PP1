// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_dropdown.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/tiles/positive_profile_list_tile.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';

@RoutePage()
class AccountCommunitiesPage extends StatefulHookConsumerWidget {
  const AccountCommunitiesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AccountCommunitiesPageState();
}

class AccountCommunitiesPageState extends ConsumerState<AccountCommunitiesPage> {
  late final RefreshController _refreshController;
  late final PagingController<String, String> _followingPagingController;
  late final PagingController<String, String> _followersPagingController;
  late final PagingController<String, String> _connectionsPagingController;
  late final PagingController<String, String> _blockedPagingController;

  @override
  void initState() {
    super.initState();
    setupControllers();
  }

  void setupControllers({bool setupRefreshController = true}) {
    final CommunitiesController controller = ref.read(communitiesControllerProvider.notifier);

    _followingPagingController = PagingController<String, String>(firstPageKey: controller.state.followingPaginationCursor);
    _followersPagingController = PagingController<String, String>(firstPageKey: controller.state.followerPaginationCursor);
    _connectionsPagingController = PagingController<String, String>(firstPageKey: controller.state.connectedPaginationCursor);
    _blockedPagingController = PagingController<String, String>(firstPageKey: controller.state.blockedPaginationCursor);

    _followingPagingController.itemList = controller.state.followingProfileIds.toList();
    _followersPagingController.itemList = controller.state.followerProfileIds.toList();
    _connectionsPagingController.itemList = controller.state.connectedProfileIds.toList();
    _blockedPagingController.itemList = controller.state.blockedProfileIds.toList();

    // Add listeners
    _followingPagingController.addPageRequestListener((cursor) => requestNextPage(cursor, CommunityType.following));
    _followersPagingController.addPageRequestListener((cursor) => requestNextPage(cursor, CommunityType.followers));
    _connectionsPagingController.addPageRequestListener((cursor) => requestNextPage(cursor, CommunityType.connected));
    _blockedPagingController.addPageRequestListener((cursor) => requestNextPage(cursor, CommunityType.blocked));

    if (setupRefreshController) {
      _refreshController = RefreshController(initialRefresh: false);
    }
  }

  Future<void> requestRefresh() async {
    final Logger logger = ref.read(loggerProvider);
    final CommunitiesController controller = ref.read(communitiesControllerProvider.notifier);
    final CommunityType communityType = controller.state.selectedCommunityType;

    try {
      logger.d('AccountCommunitiesPage - requestRefresh - Loading next community data: $communityType');
      controller.resetCommunityDataForType(type: communityType);
      await controller.loadNextCommunityData(type: communityType);
      setupControllers(setupRefreshController: true);

      _refreshController.refreshCompleted();
    } catch (ex) {
      logger.e('CommunitiesController - requestRefresh - Failed to load next community data - ex: $ex');
      _refreshController.refreshFailed();
    }
  }

  Future<void> requestNextPage(String cursor, CommunityType communityType) async {
    final CommunitiesController controller = ref.read(communitiesControllerProvider.notifier);
    if (controller.state.isBusy) {
      return;
    }

    final Logger logger = ref.read(loggerProvider);

    final bool canLoadNext = switch (communityType) {
      CommunityType.following => !controller.state.hasMoreFollowing,
      CommunityType.followers => !controller.state.hasMoreFollowers,
      CommunityType.connected => !controller.state.hasMoreConnected,
      CommunityType.blocked => !controller.state.hasMoreBlocked,
    };

    if (canLoadNext) {
      logger.d('No more pages to load: $communityType');
      return;
    }

    controller.loadNextCommunityData(type: communityType).then(
      (_) {
        return switch (communityType) {
          CommunityType.following => _followingPagingController.appendSafePage(controller.state.followingProfileIds.toList(), controller.state.followingPaginationCursor),
          CommunityType.followers => _followersPagingController.appendSafePage(controller.state.followerProfileIds.toList(), controller.state.followerPaginationCursor),
          CommunityType.connected => _connectionsPagingController.appendSafePage(controller.state.connectedProfileIds.toList(), controller.state.connectedPaginationCursor),
          CommunityType.blocked => _blockedPagingController.appendSafePage(controller.state.blockedProfileIds.toList(), controller.state.blockedPaginationCursor),
        };
      },
      onError: (error) {
        logger.e('Error loading next page: $error');
        appendPagingError(error, communityType);
      },
    );
  }

  void appendPagingError(Object error, CommunityType communityType) {
    switch (communityType) {
      case CommunityType.following:
        _followingPagingController.error = error;
        break;
      case CommunityType.followers:
        _followersPagingController.error = error;
        break;
      case CommunityType.connected:
        _connectionsPagingController.error = error;
        break;
      case CommunityType.blocked:
        _blockedPagingController.error = error;
        break;
    }
  }

  @override
  void dispose() {
    _followingPagingController.dispose();
    _followersPagingController.dispose();
    _connectionsPagingController.dispose();
    _blockedPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final CommunitiesController communitiesController = ref.read(communitiesControllerProvider.notifier);
    final CommunitiesControllerState communitiesControllerState = ref.watch(communitiesControllerProvider);

    return PositiveScaffold(
      isBusy: communitiesControllerState.isBusy,
      visibleComponents: PositiveScaffoldComponent.onlyHeadingWidgets,
      refreshController: _refreshController,
      onRefresh: requestRefresh,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: false,
          children: <Widget>[
            buildAppBar(context, colors),
            const SizedBox(height: kPaddingSmall),
            PositiveTextFieldDropdown<CommunityType>(
              values: CommunityType.values,
              initialValue: communitiesControllerState.selectedCommunityType,
              onValueChanged: (value) => communitiesController.setSelectedCommunityType(value),
              backgroundColour: colors.white,
              labelText: 'User Type',
              valueStringBuilder: (value) => (value as CommunityType).toLocale,
              placeholderStringBuilder: (value) => (value as CommunityType).toLocale,
            ),
            const SizedBox(height: kPaddingSmall),
            AnimatedSwitcher(
              duration: kAnimationDurationRegular,
              child: switch (communitiesControllerState.selectedCommunityType) {
                CommunityType.following => buildRelationshipList(context, colors, _followingPagingController),
                CommunityType.followers => buildRelationshipList(context, colors, _followersPagingController),
                CommunityType.connected => buildRelationshipList(context, colors, _connectionsPagingController),
                CommunityType.blocked => buildRelationshipList(context, colors, _blockedPagingController),
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRelationshipList(BuildContext context, DesignColorsModel colors, PagingController<String, String> controller) {
    return PagedListView.separated(
      shrinkWrap: true,
      pagingController: controller,
      separatorBuilder: (context, index) => const SizedBox(height: kPaddingSmall),
      padding: EdgeInsets.zero,
      builderDelegate: PagedChildBuilderDelegate<String>(
        newPageErrorIndicatorBuilder: (_) => const SizedBox(),
        noItemsFoundIndicatorBuilder: (_) => const SizedBox(),
        itemBuilder: (context, item, index) => buildProfileTile(context, colors, item, index),
      ),
    );
  }

  Widget buildProfileTile(BuildContext context, DesignColorsModel colors, String profileId, int index) {
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final Profile? profile = cacheController.getFromCache(profileId);

    return profile == null ? const SizedBox() : PositiveProfileListTile(profile: profile);
  }

  Widget buildAppBar(BuildContext context, DesignColorsModel colors) {
    return Row(
      children: [
        PositiveButton(
          colors: colors,
          onTapped: () => context.router.pop(),
          icon: UniconsLine.angle_left,
          style: PositiveButtonStyle.outline,
          layout: PositiveButtonLayout.iconOnly,
          size: PositiveButtonSize.medium,
          primaryColor: colors.black,
        ),
        const SizedBox(width: kPaddingMedium),
        Expanded(child: PositiveSearchField(hintText: 'Search People', onChange: (_) {}, isEnabled: false)),
      ],
    );
  }
}
