// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

// Flutter imports:
import 'package:app/helpers/brand_helpers.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/hooks/lifecycle_hook.dart';
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
import 'package:app/widgets/molecules/containers/positive_transparent_sheet.dart';
import 'package:app/widgets/molecules/input/positive_rich_text.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/tiles/positive_profile_list_tile.dart';
import 'package:app/widgets/state/positive_community_feed_state.dart';

class PositiveCommunitiesDialog extends StatefulHookConsumerWidget {
  const PositiveCommunitiesDialog({
    required this.controllerProvider,
    this.supportedCommunityTypes,
    this.mode = CommunitiesDialogMode.view,
    this.actionLabel,
    this.canCallToAction = true,
    this.onActionPressed,
    this.onProfileSelected,
    this.selectedProfiles = const <String>[],
    this.isEnabled = true,
    this.initialCommunityType,
    super.key,
  });

  final CommunitiesControllerProvider controllerProvider;
  final CommunitiesDialogMode mode;
  final List<CommunityType>? supportedCommunityTypes;

  // Select mode controls
  final String? actionLabel;
  final bool canCallToAction;
  final Future<void> Function()? onActionPressed;
  final void Function(String)? onProfileSelected;
  final List<String> selectedProfiles;
  final bool isEnabled;

  final CommunityType? initialCommunityType;

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
  late PositiveCommunityFeedState followingPagingFeedState;
  late PositiveCommunityFeedState followersPagingFeedState;
  late PositiveCommunityFeedState connectionsPagingFeedState;
  late PositiveCommunityFeedState blockedPagingFeedState;
  late PositiveCommunityFeedState managedPagingFeedState;

  @override
  void initState() {
    super.initState();
    setupControllers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialCommunityType != null) {
        final CommunitiesController controller = providerContainer.read(widget.controllerProvider.notifier);
        controller.setSelectedCommunityType(widget.initialCommunityType!);
      }
    });
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  void didUpdateWidget(PositiveCommunitiesDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedProfiles != widget.selectedProfiles) {
      setStateIfMounted();
    }
  }

  PositiveCommunityFeedState get currentFeedState {
    final CommunitiesController controller = ref.read(widget.controllerProvider.notifier);
    return switch (controller.state.selectedCommunityType) {
      CommunityType.following => followingPagingFeedState,
      CommunityType.followers => followersPagingFeedState,
      CommunityType.connected => connectionsPagingFeedState,
      CommunityType.blocked => blockedPagingFeedState,
      CommunityType.managed => managedPagingFeedState,
      CommunityType.supported => buildPageStateFromSupportedProfiles(),
    };
  }

  PositiveCommunityFeedState buildPageStateFromSupportedProfiles() {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Set<String> supportedProfilesIds = profileController.state.availableProfileIds;

    final PagingController<String, String> pagingController = PagingController(firstPageKey: '');
    pagingController.value = PagingState(
      error: null,
      nextPageKey: null,
      itemList: supportedProfilesIds.toList(),
    );

    final PositiveCommunityFeedState feedState = PositiveCommunityFeedState.buildNewState(
      currentProfileId: '',
      communityType: CommunityType.supported,
      pagingController: pagingController,
    );

    return feedState;
  }

  void setupControllers() {
    final CommunitiesController controller = ref.read(widget.controllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Profile? currentProfile = profileController.state.currentProfile;
    if (currentProfile == null) {
      logger.d('PositiveCommunitiesDialog - setupControllers - currentProfile is null');
      return;
    }

    followingPagingFeedState = controller.getCommunityFeedStateForType(currentProfile: currentProfile, communityType: CommunityType.following);
    followersPagingFeedState = controller.getCommunityFeedStateForType(currentProfile: currentProfile, communityType: CommunityType.followers);
    connectionsPagingFeedState = controller.getCommunityFeedStateForType(currentProfile: currentProfile, communityType: CommunityType.connected);
    blockedPagingFeedState = controller.getCommunityFeedStateForType(currentProfile: currentProfile, communityType: CommunityType.blocked);
    managedPagingFeedState = controller.getCommunityFeedStateForType(currentProfile: currentProfile, communityType: CommunityType.managed);

    // Add listeners
    followingPagingFeedState.pagingController.addPageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.following));
    followersPagingFeedState.pagingController.addPageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.followers));
    connectionsPagingFeedState.pagingController.addPageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.connected));
    blockedPagingFeedState.pagingController.addPageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.blocked));
    managedPagingFeedState.pagingController.addPageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.managed));
  }

  void disposeControllers() {
    followingPagingFeedState.pagingController.removePageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.following));
    followersPagingFeedState.pagingController.removePageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.followers));
    connectionsPagingFeedState.pagingController.removePageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.connected));
    blockedPagingFeedState.pagingController.removePageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.blocked));
    managedPagingFeedState.pagingController.removePageRequestListener((cursor) async => await requestNextPage(cursor, CommunityType.managed));
  }

  Future<void> requestRefresh() async {
    final CommunitiesController controller = ref.read(widget.controllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);
    final CommunityType communityType = controller.state.selectedCommunityType;

    logger.d('PositiveCommunitiesDialog - requestRefresh - Loading next community data: $communityType');
    controller.resetCommunityDataForType(type: communityType);
  }

  Future<void> requestNextPage(String cursor, CommunityType communityType) async {
    if (!mounted) {
      return;
    }

    final CommunitiesController controller = ref.read(widget.controllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    final bool canLoadNext = currentFeedState.pagingController.value.status != PagingStatus.completed;
    if (!canLoadNext) {
      logger.d('No more pages to load: $communityType');
      return;
    }

    await controller.loadNextCommunityData(type: communityType);
    setStateIfMounted();
  }

  void onCommunityTypeChanged(CommunityType value) {
    final CommunitiesController controller = ref.read(widget.controllerProvider.notifier);
    controller.setSelectedCommunityType(value);
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);

    final FirebaseAuth auth = providerContainer.read(firebaseAuthProvider);
    final String currentAuthUserId = auth.currentUser?.uid ?? '';

    final Profile? currentProfile = profileControllerState.currentProfile;
    final bool isManagedProfile = profileController.isCurrentManagedProfile;

    final CacheController cacheController = ref.read(cacheControllerProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final CommunitiesController controller = ref.read(widget.controllerProvider.notifier);
    ref.watch(widget.controllerProvider);

    useLifecycleHook(controller);

    useCacheHook(keys: <String>[
      currentProfile?.flMeta?.id ?? '',
      currentFeedState.buildCacheKey(),
    ]);

    final Widget child = switch (controller.state.selectedCommunityType) {
      CommunityType.following => buildRelationshipList(
          context: context,
          typography: typography,
          colors: colors,
          controller: followingPagingFeedState.pagingController,
          cacheController: cacheController,
          senderProfile: currentProfile,
          noDataTitle: localizations.page_community_following_empty_title,
          noDataBody: localizations.page_community_following_empty_body,
        ),
      CommunityType.followers => buildRelationshipList(
          context: context,
          typography: typography,
          colors: colors,
          controller: followersPagingFeedState.pagingController,
          cacheController: cacheController,
          senderProfile: currentProfile,
          noDataTitle: localizations.page_community_followers_empty_title,
          noDataBody: localizations.page_community_followers_empty_body,
        ),
      CommunityType.connected => buildRelationshipList(
          context: context,
          typography: typography,
          colors: colors,
          controller: connectionsPagingFeedState.pagingController,
          cacheController: cacheController,
          senderProfile: currentProfile,
          noDataTitle: localizations.page_community_connections_empty_title,
          noDataBody: localizations.page_community_connections_empty_body,
        ),
      CommunityType.blocked => buildRelationshipList(
          context: context,
          typography: typography,
          colors: colors,
          controller: blockedPagingFeedState.pagingController,
          cacheController: cacheController,
          senderProfile: currentProfile,
          noDataTitle: localizations.page_community_blocked_empty_title,
          noDataBody: localizations.page_community_blocked_empty_body,
        ),
      CommunityType.managed => buildRelationshipList(
          context: context,
          typography: typography,
          colors: colors,
          controller: managedPagingFeedState.pagingController,
          cacheController: cacheController,
          senderProfile: currentProfile,
          noDataTitle: localizations.page_community_managed_empty_title,
          noDataBody: localizations.page_community_managed_empty_body,
        ),
      CommunityType.supported => buildRelationshipList(
          context: context,
          typography: typography,
          colors: colors,
          controller: currentFeedState.pagingController,
          cacheController: cacheController,
          senderProfile: currentProfile,
          noDataTitle: localizations.page_community_supported_empty_title,
          noDataBody: localizations.page_community_supported_empty_body,
        ),
    };

    final List<CommunityType> communityTypes = [];
    if (widget.supportedCommunityTypes != null) {
      communityTypes.addAll(widget.supportedCommunityTypes!);
    } else if (isManagedProfile) {
      communityTypes.addAll(<CommunityType>[CommunityType.managed, CommunityType.following, CommunityType.followers, CommunityType.blocked]);
    } else {
      communityTypes.addAll(<CommunityType>[CommunityType.connected, CommunityType.following, CommunityType.followers, CommunityType.blocked]);
    }

    bool isOrganisationManager = false;
    if (isManagedProfile) {
      isOrganisationManager = currentAuthUserId.isNotEmpty && currentProfile?.flMeta?.ownedBy == currentAuthUserId;
    }

    return PositiveScaffold(
      decorations: buildType3ScaffoldDecorations(colors),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: false,
          children: <Widget>[
            buildAppBar(context, colors),
            const SizedBox(height: kPaddingSmall),
            if (communityTypes.length >= 2) ...<Widget>[
              PositiveTextFieldDropdown<CommunityType>(
                values: communityTypes,
                initialValue: isManagedProfile ? CommunityType.managed : CommunityType.connected,
                onValueChanged: (value) => onCommunityTypeChanged(value),
                backgroundColour: colors.white,
                labelText: 'User Type',
                valueStringBuilder: (value) => (value as CommunityType).toLocale(isManagedProfile),
                placeholderStringBuilder: (value) => (value as CommunityType).toLocale(isManagedProfile),
              ),
              const SizedBox(height: kPaddingSmall),
            ],
            if (isOrganisationManager) ...<Widget>[
              PositiveTransparentSheet(
                children: <Widget>[
                  PositiveRichText(
                    body: 'Need to invite new people or remove somebody? Please get in touch with us at {}, or call your representative.',
                    onActionTapped: (_) => 'mailto:support@positiveplusone.com'.attemptToLaunchURL(),
                    actions: <String>[
                      localizations.shared_emails_support,
                    ],
                    style: typography.styleSubtext.copyWith(color: colors.black),
                  ),
                ],
              ),
              const SizedBox(height: kPaddingSmall),
            ],
            child,
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
    required DesignTypographyModel typography,
    required DesignColorsModel colors,
    required Profile? senderProfile,
    required CacheController cacheController,
    required PagingController<String, String> controller,
    required String noDataTitle,
    required String noDataBody,
  }) {
    const Widget loadingIndicator = Align(alignment: Alignment.center, child: PositiveLoadingIndicator());
    return PagedListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      pagingController: controller,
      separatorBuilder: (context, index) => const SizedBox(height: kPaddingSmall),
      padding: EdgeInsets.zero,
      builderDelegate: PagedChildBuilderDelegate<String>(
        animateTransitions: true,
        transitionDuration: kAnimationDurationRegular,
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
        newPageProgressIndicatorBuilder: (context) => loadingIndicator,
        // create a nice display to show when there is no content in the list
        noItemsFoundIndicatorBuilder: (context) => Column(
          children: [
            Text(
              noDataTitle,
              style: typography.styleHeroMedium,
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              noDataBody,
              style: typography.styleSubtitle,
            ),
          ],
        ),
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
      children: <Widget>[
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
