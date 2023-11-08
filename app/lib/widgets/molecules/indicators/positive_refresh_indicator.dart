// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/resources/resources.dart';

class PositiveRefreshIndicator extends StatefulHookConsumerWidget {
  const PositiveRefreshIndicator({
    required this.controller,
    required this.child,
    required this.onRefresh,
    super.key,
  });

  final Widget child;
  final Future<void> Function() onRefresh;
  final IndicatorController controller;

  @override
  ConsumerState<PositiveRefreshIndicator> createState() => _PositiveRefreshIndicatorState();
}

class _PositiveRefreshIndicatorState extends ConsumerState<PositiveRefreshIndicator> {
  ScrollDirection prevScrollDirection = ScrollDirection.idle;

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    return CustomMaterialIndicator(
      onRefresh: widget.onRefresh,
      durations: const RefreshIndicatorDurations(
        completeDuration: Duration(seconds: 1),
      ),
      indicatorBuilder: (BuildContext context, IndicatorController controller) {
        final Container svg = Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            color: colors.white,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            SvgImages.logosCircular,
            height: 24,
            width: 24,
            color: colors.black,
          ),
        );

        return AnimatedContainer(
          duration: kAnimationDurationEntry,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.white,
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: controller.state == IndicatorState.finalizing || controller.state == IndicatorState.complete
                ? svg
                : SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colors.black),
                    ),
                  ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
