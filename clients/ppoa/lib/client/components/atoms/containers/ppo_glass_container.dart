// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:ppoa/client/constants/ppo_design_constants.dart';

// Package imports:
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';

class PPOGlassContainer extends StatefulWidget {
  const PPOGlassContainer({
    required this.brand,
    required this.children,
    this.onDismissRequested,
    this.mainAxisSize = MainAxisSize.min,
    this.sigmaBlur = kGlassContainerSigmaBlur,
    this.isBusy = false,
    super.key,
  });

  final DesignSystemBrand brand;
  final Future<void> Function()? onDismissRequested;

  final List<Widget> children;

  final MainAxisSize mainAxisSize;
  final double sigmaBlur;

  final bool isBusy;

  static const double kGlassContainerPadding = 15.0;
  static const double kGlassContainerBorderRadia = 40.0;
  static const double kGlassContainerOpacity = 0.25;
  static const double kGlassContainerSigmaBlur = 10.0;
  static const double kGlassContainerDismissIconRadius = 24.0;

  @override
  State<PPOGlassContainer> createState() => _PPOGlassContainerState();
}

class _PPOGlassContainerState extends State<PPOGlassContainer> {
  bool _isInternalBusy = false;

  Future<void> _onDismissTapped() async {
    if (widget.onDismissRequested == null) {
      return;
    }

    setState(() => _isInternalBusy = true);

    try {
      await widget.onDismissRequested!();
    } finally {
      setState(() => _isInternalBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _isInternalBusy || widget.isBusy,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PPOGlassContainer.kGlassContainerBorderRadia),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.sigmaBlur, sigmaY: widget.sigmaBlur),
          child: AnimatedContainer(
            duration: kAnimationDurationRegular,
            width: double.infinity,
            padding: const EdgeInsets.all(PPOGlassContainer.kGlassContainerPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PPOGlassContainer.kGlassContainerBorderRadia),
              color: widget.isBusy ? widget.brand.colors.white : widget.brand.colors.colorGray2.withOpacity(PPOGlassContainer.kGlassContainerOpacity),
            ),
            child: Column(
              mainAxisSize: widget.mainAxisSize,
              children: <Widget>[
                if (widget.onDismissRequested != null) ...<Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: IgnorePointer(
                      ignoring: _isInternalBusy,
                      child: Material(
                        type: MaterialType.transparency,
                        borderRadius: BorderRadius.circular(PPOGlassContainer.kGlassContainerDismissIconRadius),
                        child: IconButton(
                          icon: const Icon(UniconsLine.multiply),
                          iconSize: PPOGlassContainer.kGlassContainerDismissIconRadius,
                          splashRadius: PPOGlassContainer.kGlassContainerDismissIconRadius,
                          padding: EdgeInsets.zero,
                          color: widget.brand.colors.black,
                          onPressed: _onDismissTapped,
                        ),
                      ),
                    ),
                  ),
                  20.0.asVerticalWidget,
                ],
                ...widget.children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
