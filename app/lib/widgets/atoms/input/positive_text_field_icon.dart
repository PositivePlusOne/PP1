// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/extensions/color_extensions.dart';

class PositiveTextFieldIcon extends ConsumerWidget {
  const PositiveTextFieldIcon({
    super.key,
    this.size = 40.0,
    this.icon = Icons.clear,
    this.color = Colors.blue,
    this.iconColor,
  });

  factory PositiveTextFieldIcon.error({required Color backgroundColor, Color? iconColor}) {
    return PositiveTextFieldIcon(
      icon: UniconsLine.multiply,
      color: backgroundColor,
      iconColor: iconColor ?? Colors.white,
    );
  }

  factory PositiveTextFieldIcon.success({required Color backgroundColor, Color? iconColor}) {
    return PositiveTextFieldIcon(
      icon: UniconsLine.check,
      color: backgroundColor,
      iconColor: iconColor ?? Colors.white,
    );
  }

  factory PositiveTextFieldIcon.calender({required Color backgroundColor, Color? iconColor}) {
    return PositiveTextFieldIcon(
      icon: UniconsLine.calender,
      color: backgroundColor,
      iconColor: iconColor ?? Colors.white,
    );
  }

  factory PositiveTextFieldIcon.action({required Color backgroundColor, Color? iconColor}) {
    return PositiveTextFieldIcon(
      icon: UniconsLine.angle_right,
      color: backgroundColor,
      iconColor: Colors.white,
    );
  }

  final double size;

  final IconData icon;
  final Color color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            color: iconColor ?? color.complimentTextColor,
          )
        ],
      ),
    );
  }
}
