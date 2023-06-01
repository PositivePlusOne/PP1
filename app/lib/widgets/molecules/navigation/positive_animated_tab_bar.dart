// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';

class PositiveTabBar extends ConsumerWidget implements PreferredSizeWidget {
  const PositiveTabBar({
    required this.tabs,
    required this.onTapped,
    this.margin = const EdgeInsets.all(kPaddingMedium),
    this.index = -1,
    super.key,
  });

  final List<String> tabs;
  final int index;
  final Future<void> Function(int index) onTapped;

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
          for (final String tab in tabs) ...<Widget>[
            Expanded(
              child: PositiveTabItem(
                label: tab,
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
    this.isSelected = false,
    super.key,
  });

  final String label;
  final Future<void> Function() onTapped;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    return PositiveButton(
      colors: colors,
      label: label,
      primaryColor: isSelected ? colors.green : colors.white,
      style: PositiveButtonStyle.tab,
      size: PositiveButtonSize.small,
      onTapped: onTapped,
    );
  }
}
