// Dart imports:
import 'dart:async';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/page_refresh_hook.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/search/vms/search_view_model.dart';

// Enumeration for NavigationBarIndex
enum NavigationBarIndex { hub, search, chat, add, guidance }

class PositiveNavigationBar extends HookConsumerWidget implements PreferredSizeWidget {
  const PositiveNavigationBar({
    required this.mediaQuery,
    this.index = NavigationBarIndex.hub,
    this.isDisabled = false,
    this.scrollController,
    super.key,
  });

  final MediaQueryData mediaQuery;
  final NavigationBarIndex index;
  final bool isDisabled;

  final ScrollController? scrollController;

  static double calculateHeight(MediaQueryData mediaQuery) {
    return kBottomNavigationBarHeight + (kBottomNavigationBarVerticalMargin * 2) + mediaQuery.padding.bottom + kBottomNavigationBarBorderWidth;
  }

  @override
  Size get preferredSize => Size.fromHeight(calculateHeight(mediaQuery));

  static const String kHeroTag = 'pp1-components-nav-bar';

  static const double kBottomNavigationBarHeight = 80.0;
  static const double kBottomNavigationBarBorderRadius = 40.0;
  static const double kBottomNavigationBarBorderWidth = 1.0;
  static const double kBottomNavigationBarHorizontalMargin = 10.0;
  static const double kBottomNavigationBarVerticalMargin = 10.0;
  static const double kBottomNavigationBarSigmaBlur = 10.0;
  static const double kBottomNavigationBarOpacity = 0.9;

  static const EdgeInsets kBottonNavigationBarPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);
    final int badgeCount = getStreamController.getUnreadBadgeCount();

    usePageRefreshHook();

    return SizedBox(
      height: preferredSize.height,
      child: Stack(
        children: <Widget>[
          const Positioned.fill(
            child: PositiveNavigationBarShade(),
          ),
          Positioned(
            top: kBottomNavigationBarVerticalMargin,
            left: kBottomNavigationBarHorizontalMargin,
            right: kBottomNavigationBarHorizontalMargin,
            bottom: PositiveNavigationBar.kBottomNavigationBarVerticalMargin + mediaQuery.padding.bottom,
            child: Hero(
              placeholderBuilder: (BuildContext context, Size heroSize, Widget? child) => SizedBox(
                height: heroSize.height,
                width: heroSize.width,
              ),
              tag: PositiveNavigationBar.kHeroTag,
              child: PositiveNavigationBarContent(
                index: index,
                isDisabled: isDisabled,
                scrollController: scrollController,
                badgeCount: badgeCount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PositiveNavigationBarShade extends ConsumerWidget {
  const PositiveNavigationBarShade({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return IgnorePointer(
      ignoring: true,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              colors.white.withOpacity(kOpacityNone),
              colors.white,
            ],
          ),
        ),
      ),
    );
  }
}

class PositiveNavigationBarContent extends ConsumerWidget {
  const PositiveNavigationBarContent({
    super.key,
    required this.index,
    required this.isDisabled,
    this.scrollController,
    this.badgeCount = 0,
  });

  final NavigationBarIndex index;
  final bool isDisabled;
  final ScrollController? scrollController;
  final int badgeCount;

  Future<void> onIndexSelected(WidgetRef ref, NavigationBarIndex newIndex) async {
    final AppRouter router = ref.read(appRouterProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    final bool isOnHomeRoute = router.current.name == HomeRoute.name;
    if (isOnHomeRoute && newIndex == NavigationBarIndex.hub) {
      // If we are on the home route and we want to navigate to the hub...
      // Then scroll to the top of the feed
      scrollController?.jumpTo(0.0);
      return;
    }

    late final PageRouteInfo routeInfo;
    switch (newIndex) {
      case NavigationBarIndex.add:
        routeInfo = CreatePostRoute();
        analyticsController.trackEvent(AnalyticEvents.postCreationStarted);
        break;
      case NavigationBarIndex.guidance:
        routeInfo = const GuidanceRoute();
        break;
      case NavigationBarIndex.chat:
        routeInfo = const ChatConversationsRoute();
        break;
      case NavigationBarIndex.search:
        routeInfo = SearchRoute(defaultTab: SearchTab.posts);
        break;
      case NavigationBarIndex.hub:
      default:
        routeInfo = const HomeRoute();
        break;
    }

    // Check if we are currently on the route we want to navigate to
    // If so, do nothing.
    if (router.current.name == routeInfo.routeName) {
      return;
    }

    // Check if we require a logged in user
    final bool isSignedIn = userController.currentUser != null;
    final bool requiresSignIn = switch (routeInfo.routeName) {
      CreatePostRoute.name => true,
      ChatConversationsRoute.name => true,
      SearchRoute.name => true,
      _ => false,
    };

    // Check if that route is in our history, if so pop to it
    if (router.stack.any((route) => route.name == routeInfo.routeName)) {
      router.popUntil((route) => route.data?.name == routeInfo.routeName);
      return;
    }

    // If we require a logged in user and we are not logged in...
    // Then push the login reminder page
    if (requiresSignIn && !isSignedIn) {
      await router.push(const HomeLoginPromptRoute());
      return;
    }

    // Else push the route
    await router.push(routeInfo);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return ClipRRect(
      borderRadius: BorderRadius.circular(PositiveNavigationBar.kBottomNavigationBarBorderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: PositiveNavigationBar.kBottomNavigationBarSigmaBlur, sigmaY: PositiveNavigationBar.kBottomNavigationBarSigmaBlur),
        child: Container(
          height: PositiveNavigationBar.kBottomNavigationBarHeight,
          width: double.infinity,
          padding: PositiveNavigationBar.kBottonNavigationBarPadding,
          decoration: BoxDecoration(
            color: colors.white.withOpacity(PositiveNavigationBar.kBottomNavigationBarOpacity),
            border: Border.all(color: colors.colorGray1, width: PositiveNavigationBar.kBottomNavigationBarBorderWidth),
            borderRadius: BorderRadius.circular(PositiveNavigationBar.kBottomNavigationBarBorderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildNavigationBarButton(ref: ref, colors: colors, isDisabled: isDisabled, label: 'Hub', icon: UniconsLine.estate, buttonIndex: NavigationBarIndex.hub),
              const SizedBox(width: kPaddingExtraSmall),
              buildNavigationBarButton(ref: ref, colors: colors, isDisabled: isDisabled, label: 'Search', icon: UniconsLine.search, buttonIndex: NavigationBarIndex.search),
              const SizedBox(width: kPaddingExtraSmall),
              buildNavigationBarButton(ref: ref, colors: colors, isDisabled: isDisabled, label: 'Add', icon: UniconsLine.plus_circle, buttonIndex: NavigationBarIndex.add, isPrimary: true),
              const SizedBox(width: kPaddingExtraSmall),
              buildNavigationBarButton(ref: ref, colors: colors, isDisabled: isDisabled, label: 'Chat', icon: UniconsLine.comment, buttonIndex: NavigationBarIndex.chat, badgeCount: badgeCount),
              const SizedBox(width: kPaddingExtraSmall),
              buildNavigationBarButton(ref: ref, colors: colors, isDisabled: isDisabled, label: 'Guidance', icon: UniconsLine.book_alt, buttonIndex: NavigationBarIndex.guidance),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavigationBarButton({
    required WidgetRef ref,
    required DesignColorsModel colors,
    required bool isDisabled,
    required String label,
    required IconData icon,
    required NavigationBarIndex buttonIndex,
    bool isPrimary = false,
    int badgeCount = 0,
  }) {
    Widget child = PositiveButton(
      colors: colors,
      primaryColor: isPrimary ? colors.black : colors.purple,
      onTapped: () => onIndexSelected(ref, buttonIndex),
      label: label,
      tooltip: label,
      icon: icon,
      style: isPrimary ? PositiveButtonStyle.primary : PositiveButtonStyle.navigation,
      layout: PositiveButtonLayout.iconOnly,
      size: PositiveButtonSize.large,
      isActive: index == buttonIndex,
      isDisabled: isDisabled,
      includeBadge: badgeCount > 0,
    );

    // If the button is not primary...
    // Then it should be expanded to maintain the circular shape of primary buttons
    if (!isPrimary) {
      child = Expanded(
        child: child,
      );
    }

    return child;
  }
}
