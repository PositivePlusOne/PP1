// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/providers/system/design_controller.dart';

class PositiveTextFieldIcon extends ConsumerWidget {
  const PositiveTextFieldIcon({
    super.key,
    this.size = 40.0,
    this.icon = Icons.clear,
    this.color = Colors.blue,
  });

  factory PositiveTextFieldIcon.error(DesignColorsModel colors) {
    return PositiveTextFieldIcon(
      icon: UniconsLine.multiply,
      color: colors.red,
    );
  }

  factory PositiveTextFieldIcon.success(DesignColorsModel colors) {
    return PositiveTextFieldIcon(
      icon: UniconsLine.check,
      color: colors.green,
    );
  }

  factory PositiveTextFieldIcon.calender(DesignColorsModel colors) {
    return PositiveTextFieldIcon(
      icon: UniconsLine.calender,
      color: colors.black,
    );
  }

  final double size;

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: const Alignment(0.0, 0.0),
          children: <Widget>[
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            Icon(
              icon,
              size: size * 0.6,
              color: color.complimentTextColor,
            )
          ],
        ));
  }
}
