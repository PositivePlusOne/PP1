// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import '../../../providers/system/design_controller.dart';
import 'enumerations/positive_button_layout.dart';
import 'enumerations/positive_button_size.dart';
import 'enumerations/positive_button_style.dart';

class PositiveInvisibleButton extends ConsumerWidget {
  const PositiveInvisibleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    return Opacity(
      opacity: 0.0,
      child: PositiveButton(
        colors: colors,
        onTapped: () {},
        style: PositiveButtonStyle.outline,
        icon: UniconsLine.multiply,
        size: PositiveButtonSize.medium,
        isActive: true,
        layout: PositiveButtonLayout.iconOnly,
        label: '',
      ),
    );
  }
}
