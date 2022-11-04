// Flutter imports:
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:unicons/unicons.dart';

class PPOGlassContainer extends StatefulWidget {
  const PPOGlassContainer({
    required this.brand,
    required this.children,
    this.onDismissRequested,
    super.key,
  });

  final DesignSystemBrand brand;
  final Future<void> Function()? onDismissRequested;

  final List<Widget> children;

  static const double kGlassContainerPadding = 15.0;
  static const double kGlassContainerBorderRadia = 40.0;
  static const double kGlassContainerOpacity = 0.25;
  static const double kGlassContainerSigmaBlur = 10.0;
  static const double kGlassContainerDismissIconRadius = 24.0;

  @override
  State<PPOGlassContainer> createState() => _PPOGlassContainerState();
}

class _PPOGlassContainerState extends State<PPOGlassContainer> {
  bool _isBusy = false;

  Future<void> _onDismissTapped() async {
    if (widget.onDismissRequested == null) {
      return;
    }

    setState(() => _isBusy = true);

    try {
      await widget.onDismissRequested!();
    } finally {
      setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(PPOGlassContainer.kGlassContainerBorderRadia),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: PPOGlassContainer.kGlassContainerSigmaBlur, sigmaY: PPOGlassContainer.kGlassContainerSigmaBlur),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(PPOGlassContainer.kGlassContainerPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PPOGlassContainer.kGlassContainerBorderRadia),
            color: widget.brand.colorGray2.toColorFromHex().withOpacity(PPOGlassContainer.kGlassContainerOpacity),
          ),
          child: Column(
            children: <Widget>[
              if (widget.onDismissRequested != null) ...<Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: IgnorePointer(
                    ignoring: _isBusy,
                    child: IconButton(
                      icon: const Icon(UniconsLine.multiply),
                      iconSize: PPOGlassContainer.kGlassContainerDismissIconRadius,
                      splashRadius: PPOGlassContainer.kGlassContainerDismissIconRadius,
                      padding: EdgeInsets.zero,
                      color: widget.brand.colorBlack.toColorFromHex(),
                      onPressed: _onDismissTapped,
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
    );
  }
}
