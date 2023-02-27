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
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';

class PositiveNavigationBar extends ConsumerWidget with PreferredSizeWidget {
  const PositiveNavigationBar({
    required this.mediaQuery,
    this.index = -1,
    this.isDisabled = false,
    super.key,
  });

  final MediaQueryData mediaQuery;

  final int index;

  final bool isDisabled;

  @override
  Size get preferredSize => Size.fromHeight(kBottomNavigationBarHeight + kBottomNavigationBarBottomMargin + mediaQuery.padding.bottom);

  static const String kHeroTag = 'pp1-components-nav-bar';

  static const double kBottomNavigationBarHeight = 80.0;
  static const double kBottomNavigationBarBorderRadius = 40.0;
  static const double kBottomNavigationBarHorizontalMargin = 10.0;
  static const double kBottomNavigationBarBottomMargin = 20.0;

  static const EdgeInsets kBottonNavigationBarPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0);

  Future<void> onIndexSelected(WidgetRef ref, int index) async {
    final AppRouter router = ref.read(appRouterProvider);
    router.removeWhere((route) => true);

    switch (index) {
      case 2:
        await router.push(const ChatListRoute());
        break;
      case 1:
        await router.push(const SearchRoute());
        break;
      case 0:
      default:
        await router.push(const HomeRoute());
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    // TODO(anyone): Localize this
    return Hero(
      tag: kHeroTag,
      child: Container(
        height: kBottomNavigationBarHeight,
        width: double.infinity,
        padding: kBottonNavigationBarPadding,
        margin: EdgeInsets.only(
          left: kBottomNavigationBarHorizontalMargin,
          right: kBottomNavigationBarHorizontalMargin,
          bottom: kBottomNavigationBarBottomMargin + mediaQuery.padding.bottom,
        ),
        decoration: BoxDecoration(
          color: colors.colorGray1,
          borderRadius: BorderRadius.circular(kBottomNavigationBarBorderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: PositiveButton(
                colors: colors,
                primaryColor: colors.purple,
                onTapped: () => onIndexSelected(ref, 0),
                label: 'Hub',
                tooltip: 'Hub',
                icon: UniconsLine.estate,
                style: PositiveButtonStyle.navigation,
                isActive: index == 0,
                isDisabled: isDisabled,
              ),
            ),
            const SizedBox(width: kPaddingExtraSmall),
            Expanded(
              child: PositiveButton(
                colors: colors,
                primaryColor: colors.purple,
                onTapped: () => onIndexSelected(ref, 1),
                label: 'Search',
                tooltip: 'Search',
                icon: UniconsLine.search,
                style: PositiveButtonStyle.navigation,
                isActive: index == 1,
                isDisabled: isDisabled,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  onTapped: () async {},
                  label: 'Add',
                  tooltip: 'Add',
                  icon: UniconsLine.plus_circle,
                  style: PositiveButtonStyle.primary,
                  layout: PositiveButtonLayout.iconOnly,
                  size: PositiveButtonSize.large,
                  isDisabled: isDisabled,
                ),
              ),
            ),
            Expanded(
              child: PositiveButton(
                colors: colors,
                primaryColor: colors.purple,
                onTapped: () => onIndexSelected(ref, 2),
                label: 'Chat',
                tooltip: 'Chat',
                icon: UniconsLine.comment,
                style: PositiveButtonStyle.navigation,
                isActive: index == 2,
                isDisabled: isDisabled,
              ),
            ),
            const SizedBox(width: kPaddingExtraSmall),
            Expanded(
              child: PositiveButton(
                colors: colors,
                primaryColor: colors.purple,
                onTapped: () => onIndexSelected(ref, 3),
                label: 'Guidance',
                tooltip: 'Guidance',
                icon: UniconsLine.book_alt,
                style: PositiveButtonStyle.navigation,
                isActive: index == 3,
                isDisabled: isDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
