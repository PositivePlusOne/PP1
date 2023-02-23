// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';

class PositiveHint extends ConsumerWidget {
  const PositiveHint({
    required this.label,
    required this.icon,
    required this.iconColor,
    this.margin = const EdgeInsets.symmetric(horizontal: 10.0),
    super.key,
  });

  factory PositiveHint.fromError(String label, DesignColorsModel colors) {
    return PositiveHint(
      label: label,
      icon: UniconsLine.exclamation_triangle,
      iconColor: colors.red,
    );
  }

  final String label;

  final IconData icon;
  final Color iconColor;

  final EdgeInsets margin;

  static const EdgeInsets kEdgeInsets = EdgeInsets.symmetric(
    horizontal: 10.0,
    vertical: 5.0,
  );

  static const double kIconSpacing = 10.0;
  static const double kIconRadius = 22.0;

  static final BorderRadius kBorderRadius = BorderRadius.circular(10.0);
  static const double kOpacity = 0.25;
  static const double kSigmaBlur = 12.5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return ClipRRect(
      borderRadius: kBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: kSigmaBlur, sigmaY: kSigmaBlur),
        child: Container(
          padding: kEdgeInsets,
          margin: margin,
          decoration: BoxDecoration(
            color: colors.colorGray3.withOpacity(kOpacity),
            borderRadius: kBorderRadius,
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, size: kIconRadius, color: iconColor),
              const SizedBox(width: kIconSpacing),
              Expanded(
                child: Text(
                  label,
                  style: typography.styleHint.copyWith(color: colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
