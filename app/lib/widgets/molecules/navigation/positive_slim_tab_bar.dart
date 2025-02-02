// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';

class PositiveSlimTabBar extends ConsumerWidget implements PreferredSizeWidget {
  const PositiveSlimTabBar({
    required this.tabs,
    required this.onTapped,
    required this.tabColours,
    this.index = -1,
    this.unselectedColour,
    this.tappablePadding = const EdgeInsets.symmetric(vertical: kPaddingSmall),
    super.key,
  }) : assert(tabColours.length == tabs.length);

  final List<String> tabs;
  final int index;
  final FutureOr<void> Function(int index) onTapped;

  final List<Color> tabColours;
  final Color? unselectedColour;

  ///? padding around the small buttons to aid in accesability
  final EdgeInsets tappablePadding;

  static const double kBaseHeight = 20.0;
  static const double kBorderRadius = 200.0;

  ///? Total height including the additional tappable area
  double get totalHeight => kBaseHeight + tappablePadding.top + tappablePadding.bottom;

  @override
  Size get preferredSize => Size.fromHeight(totalHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return SizedBox(
      width: double.infinity,
      height: totalHeight,
      child: Stack(
        children: [
          //! Due to unkown rounding issues in the engine, some phones have a single pixel around the edge, this jank hides that
          Positioned(
            top: tappablePadding.top + kPaddingThin,
            bottom: tappablePadding.bottom + kPaddingThin,
            left: kPaddingThin,
            right: kPaddingThin,
            child: Container(
              decoration: BoxDecoration(
                color: unselectedColour ?? colors.white.withOpacity(kOpacityVignette),
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              children: <Widget>[
                for (final String tab in tabs) ...<Widget>[
                  Expanded(
                    child: PositiveSlimTabItem(
                      label: tab,
                      primaryColour: colors.white,
                      isSelected: tabs.indexOf(tab) == index,
                      onTapped: () => onTapped(tabs.indexOf(tab)),
                      selectedBackgroundColour: tabColours[tabs.indexOf(tab)],
                      tappablePadding: tappablePadding,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PositiveSlimTabItem extends ConsumerWidget {
  const PositiveSlimTabItem({
    required this.label,
    required this.onTapped,
    required this.primaryColour,
    required this.isSelected,
    required this.selectedBackgroundColour,
    required this.tappablePadding,
    super.key,
  });

  final String label;
  final FutureOr<void> Function() onTapped;
  final bool isSelected;

  ///? padding around the small buttons to aid in accesability
  final EdgeInsets tappablePadding;

  /// Primary text colour
  final Color primaryColour;

  /// Selected background colour
  final Color selectedBackgroundColour;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final Color selectedTextColour = isSelected
        ? selectedBackgroundColour.exceedsBrightnessUpperRestriction
            ? colours.colorGray7
            : colours.white
        : primaryColour.exceedsBrightnessUpperRestriction
            ? colours.colorGray6
            : colours.white;
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return PositiveTapBehaviour(
      onTap: (c) {
        onTapped();
      },
      hitTestBehaviourOverride: HitTestBehavior.translucent,
      child: Padding(
        padding: tappablePadding,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? selectedBackgroundColour : colours.transparent,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: typography.styleSubtextBold.copyWith(color: selectedTextColour),
          ),
        ),
      ),
    );
  }
}
