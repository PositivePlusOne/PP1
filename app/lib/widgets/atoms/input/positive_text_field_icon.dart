// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/extensions/color_extensions.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';

class PositiveTextFieldIcon extends ConsumerWidget {
  const PositiveTextFieldIcon({
    super.key,
    this.size = 40.0,
    this.icon = Icons.clear,
    this.color = Colors.blue,
    this.iconColor,
    this.isEnabled = true,
    this.onTap,
  });

  factory PositiveTextFieldIcon.error({required Color backgroundColor, Color? iconColor}) {
    return PositiveTextFieldIcon(
      icon: UniconsLine.multiply,
      color: backgroundColor,
      iconColor: iconColor ?? Colors.white,
    );
  }

  factory PositiveTextFieldIcon.success({required Color backgroundColor, Color? iconColor, bool isEnabled = true, Future<void> Function()? onTap}) {
    return PositiveTextFieldIcon(
      icon: UniconsLine.check,
      color: backgroundColor,
      iconColor: iconColor ?? Colors.white,
      isEnabled: isEnabled,
      onTap: onTap,
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

  factory PositiveTextFieldIcon.search({required Color backgroundColor, Color? iconColor, Future<void> Function()? onTap, bool isEnabled = true}) {
    return PositiveTextFieldIcon(
      icon: UniconsLine.search,
      color: backgroundColor,
      iconColor: Colors.white,
      onTap: onTap,
      isEnabled: isEnabled,
    );
  }

  final double size;

  final IconData icon;
  final Color color;
  final Color? iconColor;

  final bool isEnabled;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PositiveTapBehaviour(
      onTap: onTap ?? () => FocusManager.instance.primaryFocus?.unfocus(),
      isEnabled: isEnabled,
      child: SizedBox(
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
      ),
    );
  }
}
