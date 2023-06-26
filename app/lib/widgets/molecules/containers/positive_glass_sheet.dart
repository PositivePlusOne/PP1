// Dart imports:
import 'dart:async';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/behaviours/positive_blur_behaviour.dart';

class PositiveGlassSheet extends ConsumerWidget {
  const PositiveGlassSheet({
    required this.children,
    this.onDismissRequested,
    this.mainAxisSize = MainAxisSize.min,
    this.sigmaBlur = kGlassContainerSigmaBlur,
    this.excludeBlur = false,
    this.heroTag = '',
    this.isBusy = false,
    super.key,
  });

  final FutureOr<void> Function()? onDismissRequested;

  final List<Widget> children;

  final MainAxisSize mainAxisSize;

  final double sigmaBlur;
  final bool excludeBlur;

  final String heroTag;

  final bool isBusy;

  static const double kGlassContainerPadding = 15.0;
  static const double kGlassContainerCloseButtonPadding = 20.0;
  static const double kGlassContainerBorderRadius = 40.0;
  static const double kGlassContainerOpacity = 0.15;
  static const double kGlassContainerSigmaBlur = 5.0;
  static const double kGlassContainerDismissIconRadius = 24.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    Widget child = IgnorePointer(
      ignoring: isBusy,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PositiveGlassSheet.kGlassContainerBorderRadius),
        child: PositiveBlurBehaviour(
          excludeBlur: excludeBlur,
          child: AnimatedContainer(
            duration: kAnimationDurationRegular,
            width: double.infinity,
            padding: const EdgeInsets.all(PositiveGlassSheet.kGlassContainerPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PositiveGlassSheet.kGlassContainerBorderRadius),
              color: isBusy ? colors.white : colors.colorGray2.withOpacity(PositiveGlassSheet.kGlassContainerOpacity),
            ),
            child: Column(
              mainAxisSize: mainAxisSize,
              children: <Widget>[
                if (onDismissRequested != null) ...<Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      type: MaterialType.transparency,
                      borderRadius: BorderRadius.circular(PositiveGlassSheet.kGlassContainerDismissIconRadius),
                      child: IconButton(
                        icon: const Icon(UniconsLine.multiply),
                        iconSize: PositiveGlassSheet.kGlassContainerDismissIconRadius,
                        splashRadius: PositiveGlassSheet.kGlassContainerDismissIconRadius,
                        padding: EdgeInsets.zero,
                        color: colors.black,
                        onPressed: onDismissRequested,
                      ),
                    ),
                  ),
                  const SizedBox(height: PositiveGlassSheet.kGlassContainerCloseButtonPadding),
                ],
                ...children,
              ],
            ),
          ),
        ),
      ),
    );

    if (heroTag.isNotEmpty) {
      child = Hero(
        tag: heroTag,
        child: child,
      );
    }

    return child;
  }
}
