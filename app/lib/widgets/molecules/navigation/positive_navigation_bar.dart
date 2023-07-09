// Dart imports:
import 'dart:async';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';

// Enumeration for NavigationBarIndex
enum NavigationBarIndex { hub, search, chat, add, guidance }

class PositiveNavigationBar extends ConsumerWidget implements PreferredSizeWidget {
  const PositiveNavigationBar({
    required this.mediaQuery,
    this.index = NavigationBarIndex.hub,
    this.isDisabled = false,
    Key? key,
  }) : super(key: key);

  final MediaQueryData mediaQuery;
  final NavigationBarIndex index;
  final bool isDisabled;

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
  static const double kBottomNavigationBarVerticalMargin = 20.0;
  static const double kBottomNavigationBarSigmaBlur = 10.0;
  static const double kBottomNavigationBarOpacity = 0.9;

  static const EdgeInsets kBottonNavigationBarPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Hero(
      tag: kHeroTag,
      child: SizedBox(
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
              child: PositiveNavigationBarContent(
                index: index,
                isDisabled: isDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PositiveNavigationBarShade extends ConsumerWidget {
  const PositiveNavigationBarShade({Key? key}) : super(key: key);

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
    Key? key,
    required this.index,
    required this.isDisabled,
  }) : super(key: key);

  final NavigationBarIndex index;
  final bool isDisabled;

  Future<void> onIndexSelected(WidgetRef ref, NavigationBarIndex index) async {
    final AppRouter router = ref.read(appRouterProvider);

    // You must be able to navigate back from the post route
    if (index != NavigationBarIndex.add) {
      router.removeWhere((route) => true);
    }

    switch (index) {
      case NavigationBarIndex.add:
        await router.push(const PostRoute());
        break;
      case NavigationBarIndex.guidance:
        await router.push(const GuidanceRoute());
        break;
      case NavigationBarIndex.chat:
        await router.push(const ChatConversationsRoute());
        break;
      case NavigationBarIndex.search:
        await router.push(const SearchRoute());
        break;
      case NavigationBarIndex.hub:
      default:
        await router.push(const HomeRoute());
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final UserController userController = ref.read(userControllerProvider.notifier);
    final bool isUserLoggedIn = userController.currentUser != null;

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
              buildNavigationBarButton(ref, colors, isDisabled, 'Hub', UniconsLine.estate, NavigationBarIndex.hub),
              const SizedBox(width: kPaddingExtraSmall),
              buildNavigationBarButton(ref, colors, isDisabled || !isUserLoggedIn, 'Search', UniconsLine.search, NavigationBarIndex.search),
              const SizedBox(width: kPaddingExtraSmall),
              buildNavigationBarButton(ref, colors, isDisabled || !isUserLoggedIn, 'Add', UniconsLine.plus_circle, NavigationBarIndex.add, isPrimary: true),
              const SizedBox(width: kPaddingExtraSmall),
              buildNavigationBarButton(ref, colors, isDisabled || !isUserLoggedIn, 'Chat', UniconsLine.comment, NavigationBarIndex.chat),
              const SizedBox(width: kPaddingExtraSmall),
              buildNavigationBarButton(ref, colors, isDisabled, 'Guidance', UniconsLine.book_alt, NavigationBarIndex.guidance),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavigationBarButton(WidgetRef ref, DesignColorsModel colors, bool isDisabled, String label, IconData icon, NavigationBarIndex buttonIndex, {bool isPrimary = false}) {
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
