// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';

class PositiveTabEntry {
  const PositiveTabEntry({
    required this.title,
    required this.colour,
    this.isEnabled = true,
  });

  final String title;
  final Color colour;
  final bool isEnabled;
}

class PositiveTabBar extends ConsumerWidget implements PreferredSizeWidget {
  const PositiveTabBar({
    required this.tabs,
    required this.onTapped,
    this.margin = const EdgeInsets.all(kPaddingMedium),
    this.index = -1,
    super.key,
  });

  final List<PositiveTabEntry> tabs;
  final int index;
  final FutureOr<void> Function(int index) onTapped;

  final EdgeInsets? margin;

  static const double kBaseHeight = 30.0;
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
        color: colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Row(
        children: <Widget>[
          for (final tab in tabs.where((element) => element.isEnabled)) ...<Widget>[
            Expanded(
              child: PositiveTabItem(
                label: tab.title,
                primaryColour: tab.colour,
                isEnabled: tab.isEnabled,
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

class PositiveTabItem extends ConsumerWidget {
  const PositiveTabItem({
    required this.label,
    required this.onTapped,
    required this.primaryColour,
    this.isSelected = false,
    this.isEnabled = true,
    super.key,
  });

  final String label;
  final FutureOr<void> Function() onTapped;
  final bool isSelected;
  final bool isEnabled;
  final Color primaryColour;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final Color selectedTextColour = primaryColour.exceedsBrightnessUpperRestriction ? colours.colorGray7 : colours.white;
    return PositiveButton(
      colors: colours,
      isDisabled: !isEnabled,
      iconColorOverride: isSelected ? selectedTextColour : colours.colorGray6,
      label: label,
      primaryColor: isSelected ? primaryColour : colours.white,
      style: PositiveButtonStyle.tab,
      size: PositiveButtonSize.small,
      onTapped: onTapped,
    );
  }
}
