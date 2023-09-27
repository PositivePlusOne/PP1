// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/providers/system/design_controller.dart';

class PositiveSlimTabBar extends ConsumerWidget implements PreferredSizeWidget {
  const PositiveSlimTabBar({
    required this.tabs,
    required this.onTapped,
    required this.tabColours,
    this.margin = const EdgeInsets.all(kPaddingMedium),
    this.index = -1,
    super.key,
  }) : assert(tabColours.length == tabs.length);

  final List<String> tabs;
  final int index;
  final FutureOr<void> Function(int index) onTapped;

  final List<Color> tabColours;

  final EdgeInsets? margin;

  static const double kBaseHeight = 20.0;
  static const double kBorderRadius = 200.0;

  double get totalHeight => kBaseHeight + (margin?.vertical ?? 0);

  @override
  Size get preferredSize => Size.fromHeight(totalHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return Container(
      height: kBaseHeight,
      width: double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        color: colors.white.withOpacity(kOpacityVignette),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Row(
        children: <Widget>[
          for (final String tab in tabs) ...<Widget>[
            Expanded(
              child: PositiveSlimTabItem(
                label: tab,
                primaryColour: tabColours[tabs.indexOf(tab)],
                isSelected: tabs.indexOf(tab) == index,
                onTapped: () => onTapped(tabs.indexOf(tab)),
              ),
            ),
          ],
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
    super.key,
  });

  final String label;
  final FutureOr<void> Function() onTapped;
  final Color primaryColour;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final Color selectedTextColour = primaryColour.exceedsBrightnessUpperRestriction ? colours.colorGray7 : colours.white;
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return PositiveTapBehaviour(
      onTap: (c) {
        onTapped();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? colours.white : colours.transparent,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: typography.styleSubtextBold.copyWith(color: selectedTextColour),
        ),
      ),
    );
  }
}
