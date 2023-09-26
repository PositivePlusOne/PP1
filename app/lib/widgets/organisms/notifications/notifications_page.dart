// Flutter imports:
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/behaviours/positive_notification_pagination_behaviour.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/switchers/positive_profile_segmented_switcher.dart';
import 'package:app/widgets/organisms/notifications/vms/notifications_view_model.dart';
import 'package:app/widgets/state/positive_notifications_state.dart';

@RoutePage()
class NotificationsPage extends HookConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    final NotificationsViewModel viewModel = ref.read(notificationsViewModelProvider.notifier);
    final NotificationsViewModelState state = ref.watch(notificationsViewModelProvider);

    final Profile? currentProfile = viewModel.getCurrentProfile();

    final List<Widget> actions = [];
    final List<String> cacheKeys = [];
    bool hasNotifications = false;

    if (currentProfile?.flMeta?.id?.isNotEmpty ?? false) {
      actions.addAll(currentProfile!.buildCommonProfilePageActions(disableNotifications: true));
      final String notificationCacheKey = PositiveNotificationsPaginationBehaviourState.getExpectedCacheKey(currentProfile.flMeta!.id!);
      final PositiveNotificationsState? cachedFeedState = cacheController.getFromCache(notificationCacheKey);
      hasNotifications = cachedFeedState?.pagingController.itemList?.isNotEmpty ?? false;
      cacheKeys.add(notificationCacheKey);
    }

    cacheKeys.addAll(viewModel.getSupportedProfileIds());
    ref.watch(profileControllerProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    useCacheHook(keys: cacheKeys);
    useLifecycleHook(viewModel);

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      visibleComponents: {
        PositiveScaffoldComponent.headingWidgets,
        if (!hasNotifications) PositiveScaffoldComponent.decorationWidget,
      },
      decorations: !hasNotifications ? buildType3ScaffoldDecorations(colours) : [],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          appBarTrailing: actions,
          appBarSpacing: kPaddingNone,
          children: <Widget>[
            if (viewModel.canSwitchProfile) ...<Widget>[
              PositiveProfileSegmentedSwitcher(mixin: viewModel),
              const SizedBox(height: kPaddingMedium),
            ],
          ],
        ),
        if (currentProfile?.flMeta?.id?.isNotEmpty ?? false) ...<Widget>[
          //TODO: load additional profile notification data after loading first profile
          PositiveNotificationsPaginationBehaviour(uid: currentProfile!.flMeta!.id!),
          const SliverToBoxAdapter(child: SizedBox(height: kPaddingSmall)),
          SliverToBoxAdapter(child: SizedBox(height: PositiveNavigationBar.calculateHeight(mediaQueryData))),
        ],
      ],
    );
  }
}
