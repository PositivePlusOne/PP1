// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_dropdown.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/tiles/positive_profile_list_tile.dart';

class PositiveCommunitiesDialog extends StatefulHookConsumerWidget {
  const PositiveCommunitiesDialog({
    required this.selectedCommunityType,
    required this.supportedCommunityTypes,
    this.mode = CommunitiesDialogMode.view,
    this.actionLabel,
    this.canCallToAction = true,
    this.onActionPressed,
    this.onProfileSelected,
    this.selectedProfiles = const <String>[],
    this.isEnabled = true,
    super.key,
  });

  final CommunityType selectedCommunityType;
  final List<CommunityType> supportedCommunityTypes;
  final CommunitiesDialogMode mode;

  // Select mode controls
  final String? actionLabel;
  final bool canCallToAction;
  final Future<void> Function()? onActionPressed;
  final void Function(String)? onProfileSelected;
  final List<String> selectedProfiles;
  final bool isEnabled;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PositiveCommunitiesDialogState();
}

enum CommunitiesDialogMode {
  view,
  select;

  PositiveProfileListTileType get toProfileListTileType {
    switch (this) {
      case CommunitiesDialogMode.view:
        return PositiveProfileListTileType.view;
      case CommunitiesDialogMode.select:
        return PositiveProfileListTileType.selectable;
    }
  }
}

class PositiveCommunitiesDialogState extends ConsumerState<PositiveCommunitiesDialog> {
  late PagingController<String, String> _followingPagingController;
  late PagingController<String, String> _followersPagingController;
  late PagingController<String, String> _connectionsPagingController;
  late PagingController<String, String> _blockedPagingController;

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

    _followingPagingController.value = PagingState<String, String>(
      nextPageKey: controller.state.followingPaginationCursor,
      itemList: controller.state.followingProfileIds.toList(),
    );

    _followersPagingController.value = PagingState<String, String>(
      nextPageKey: controller.state.followerPaginationCursor,
      itemList: controller.state.followerProfileIds.toList(),
    );

    _connectionsPagingController.value = PagingState<String, String>(
      nextPageKey: controller.state.connectedPaginationCursor,
      itemList: controller.state.connectedProfileIds.toList(),
    );

    _blockedPagingController.value = PagingState<String, String>(
      nextPageKey: controller.state.blockedPaginationCursor,
      itemList: controller.state.blockedProfileIds.toList(),
    );

    // Add listeners
    _followingPagingController.addPageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.following));
    _followersPagingController.addPageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.followers));
    _connectionsPagingController.addPageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.connected));
    _blockedPagingController.addPageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.blocked));
  }

  Future<void> requestRefresh() async {
    final Logger logger = ref.read(loggerProvider);
    final CommunitiesController controller = ref.read(communitiesControllerProvider.notifier);
    final CommunityType communityType = controller.state.selectedCommunityType;

    try {
      logger.d('PositiveCommunitiesDialog - requestRefresh - Loading next community data: $communityType');
      controller.resetCommunityDataForType(type: communityType);
      await controller.loadNextCommunityData(type: communityType);
      setupControllers(setupRefreshController: false);
    } catch (ex) {
      logger.e('CommunitiesController - requestRefresh - Failed to load next community data - ex: $ex');
      appendPagingError(ex, communityType);
    }
  }

  Future<void> requestNextPage(String cursor, CommunityType communityType) async {
    final CommunitiesController controller = ref.read(communitiesControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final bool canLoadNext = switch (communityType) {
      CommunityType.following => !controller.state.hasMoreFollowing,
      CommunityType.followers => !controller.state.hasMoreFollowers,
      CommunityType.connected => !controller.state.hasMoreConnected,
      CommunityType.blocked => !controller.state.hasMoreBlocked,
    };

    if (!canLoadNext) {
      logger.d('No more pages to load: $communityType');
      switch (communityType) {
        case CommunityType.following:
          _followingPagingController.appendSafeLastPage<String>([]);
          break;
        case CommunityType.followers:
          _followersPagingController.appendSafeLastPage<String>([]);
          break;
        case CommunityType.connected:
          _connectionsPagingController.appendSafeLastPage<String>([]);
          break;
        case CommunityType.blocked:
          _blockedPagingController.appendSafeLastPage<String>([]);
          break;
      }

      return;
    }

    try {
      await controller.loadNextCommunityData(type: communityType);
      () => switch (communityType) {
            CommunityType.following => _followingPagingController.appendSafePage(controller.state.followingProfileIds.toList(), controller.state.followingPaginationCursor),
            CommunityType.followers => _followersPagingController.appendSafePage(controller.state.followerProfileIds.toList(), controller.state.followerPaginationCursor),
            CommunityType.connected => _connectionsPagingController.appendSafePage(controller.state.connectedProfileIds.toList(), controller.state.connectedPaginationCursor),
            CommunityType.blocked => _blockedPagingController.appendSafePage(controller.state.blockedProfileIds.toList(), controller.state.blockedPaginationCursor),
          };
    } catch (ex) {
      logger.e('Error loading next page: $ex');
      appendPagingError(ex, communityType);
    }
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

  void onCommunityTypeChanged(CommunityType value) {
    final CommunitiesController communitiesController = ref.read(communitiesControllerProvider.notifier);
    communitiesController.setSelectedCommunityType(value);

    final bool hasMoreData = switch (value) {
      CommunityType.following => communitiesController.state.hasMoreFollowing,
      CommunityType.followers => communitiesController.state.hasMoreFollowers,
      CommunityType.connected => communitiesController.state.hasMoreConnected,
      CommunityType.blocked => communitiesController.state.hasMoreBlocked,
    };

    final String cursor = switch (value) {
      CommunityType.following => communitiesController.state.followingPaginationCursor,
      CommunityType.followers => communitiesController.state.followerPaginationCursor,
      CommunityType.connected => communitiesController.state.connectedPaginationCursor,
      CommunityType.blocked => communitiesController.state.blockedPaginationCursor,
    };

    if (hasMoreData) {
      requestNextPage(cursor, value);
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
    final ProfileControllerState profileController = ref.watch(profileControllerProvider);
    final Profile? currentProfile = profileController.currentProfile;

    final CacheController cacheController = ref.read(cacheControllerProvider);

    return PositiveScaffold(
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: false,
          children: <Widget>[
            buildAppBar(context, colors),
            const SizedBox(height: kPaddingSmall),
            if (widget.supportedCommunityTypes.length >= 2) ...<Widget>[
              PositiveTextFieldDropdown<CommunityType>(
                values: CommunityType.values,
                initialValue: ref.watch(communitiesControllerProvider).selectedCommunityType,
                onValueChanged: (value) => onCommunityTypeChanged(value),
                backgroundColour: colors.white,
                labelText: 'User Type',
                valueStringBuilder: (value) => (value as CommunityType).toLocale,
                placeholderStringBuilder: (value) => (value as CommunityType).toLocale,
              ),
              const SizedBox(height: kPaddingSmall),
            ],
            AnimatedSwitcher(
              duration: kAnimationDurationRegular,
              child: switch (ref.watch(communitiesControllerProvider).selectedCommunityType) {
                CommunityType.following => buildRelationshipList(
                    context: context,
                    controller: _followingPagingController,
                    cacheController: cacheController,
                    senderProfile: currentProfile,
                  ),
                CommunityType.followers => buildRelationshipList(
                    context: context,
                    controller: _followersPagingController,
                    cacheController: cacheController,
                    senderProfile: currentProfile,
                  ),
                CommunityType.connected => buildRelationshipList(
                    context: context,
                    controller: _connectionsPagingController,
                    cacheController: cacheController,
                    senderProfile: currentProfile,
                  ),
                CommunityType.blocked => buildRelationshipList(
                    context: context,
                    controller: _blockedPagingController,
                    cacheController: cacheController,
                    senderProfile: currentProfile,
                  ),
              },
            ),
          ],
        ),
      ],
      footerWidgets: <Widget>[
        if (widget.mode == CommunitiesDialogMode.select) ...<Widget>[
          PositiveButton.standardPrimary(
            colors: colors,
            label: widget.actionLabel ?? 'Done',
            onTapped: () => widget.onActionPressed?.call(),
            isDisabled: !widget.isEnabled || !widget.canCallToAction,
          ),
        ],
      ],
    );
  }

  Widget buildRelationshipList({
    required BuildContext context,
    required Profile? senderProfile,
    required CacheController cacheController,
    required PagingController<String, String> controller,
  }) {
    const Widget loadingIndicator = Align(alignment: Alignment.center, child: PositiveLoadingIndicator());
    return PagedListView.separated(
      shrinkWrap: true,
      pagingController: controller,
      separatorBuilder: (context, index) => const SizedBox(height: kPaddingSmall),
      padding: EdgeInsets.zero,
      builderDelegate: PagedChildBuilderDelegate<String>(
        animateTransitions: true,
        transitionDuration: kAnimationDurationRegular,
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
        newPageProgressIndicatorBuilder: (context) => loadingIndicator,
        itemBuilder: (context, item, index) {
          final Profile? targetProfile = cacheController.get(item);
          final String targetProfileId = targetProfile?.flMeta?.id ?? '';
          final String relationshipId = [senderProfile?.flMeta?.id ?? '', targetProfileId].asGUID;
          final Relationship? relationship = cacheController.get(relationshipId);

          return buildProfileTile(
            context: context,
            senderProfile: senderProfile,
            targetProfile: targetProfile,
            relationship: relationship,
          );
        },
      ),
    );
  }

  Widget buildProfileTile({
    required BuildContext context,
    required Profile? senderProfile,
    required Profile? targetProfile,
    required Relationship? relationship,
  }) {
    if (targetProfile == null) {
      return const SizedBox();
    }

    final String targetProfileId = targetProfile.flMeta?.id ?? '';
    final bool isSelected = widget.selectedProfiles.contains(targetProfileId);

    return PositiveProfileListTile(
      targetProfile: targetProfile,
      senderProfile: senderProfile,
      relationship: relationship,
      type: widget.mode.toProfileListTileType,
      isSelected: isSelected,
      onSelected: () => widget.onProfileSelected?.call(targetProfileId),
      isEnabled: widget.isEnabled,
    );
  }

  Widget buildAppBar(BuildContext context, DesignColorsModel colors) {
    final AppRouter appRouter = providerContainer.read(appRouterProvider);
    return Row(
      children: [
        PositiveButton(
          colors: colors,
          onTapped: () => appRouter.pop(),
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
