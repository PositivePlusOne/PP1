// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import '../../../../resources/resources.dart';
import '../../../constants/design_constants.dart';
import '../../atoms/buttons/positive_button.dart';

enum PositiveAppBarTrailType {
  none,
  convex,
  concave,
}

class PositiveAppBar extends StatelessWidget with PreferredSizeWidget {
  const PositiveAppBar({
    super.key,
    this.trailing = const <Widget>[],
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.decorationColor = Colors.white,
    this.applyLeadingandTrailingPadding = false,
    this.safeAreaQueryData,
    this.trailType = PositiveAppBarTrailType.none,
  });

  final Color foregroundColor;
  final Color backgroundColor;
  final Color decorationColor;

  final bool applyLeadingandTrailingPadding;
  final MediaQueryData? safeAreaQueryData;

  final List<Widget> trailing;

  final PositiveAppBarTrailType trailType;

  @override
  Size get preferredSize {
    final double baseHeight = PositiveButton.kButtonIconRadiusRegular + PositiveButton.kButtonPaddingMedium.vertical;
    const double paddingHeight = kPaddingSmall * 2;
    final double marginHeight = safeAreaQueryData?.padding.top ?? 0;

    //* The decoration height is the height of the concave or convex trail
    final double decorationHeight = trailType == PositiveAppBarTrailType.concave
        ? kPositiveAppBarRadius * 2
        : trailType == PositiveAppBarTrailType.convex
            ? kPositiveAppBarRadius
            : 0;

    const double width = double.infinity;
    final double height = baseHeight + paddingHeight + marginHeight + decorationHeight;

    return Size(width, height);
  }

  static const String kPositiveLogoTag = 'pp1-app-bar-hero';
  static const double kPositiveAppBarRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      width: preferredSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: _PositiveAppBarContent(
              backgroundColor: backgroundColor,
              applyLeadingandTrailingPadding: applyLeadingandTrailingPadding,
              safeAreaQueryData: safeAreaQueryData,
              kPositiveLogoTag: kPositiveLogoTag,
              foregroundColor: foregroundColor,
              trailing: trailing,
            ),
          ),
          if (trailType == PositiveAppBarTrailType.concave) ...<Widget>[
            _PositiveAppBarTrailConcave(
              backgroundColor: backgroundColor,
              decorationColor: decorationColor,
              trailType: trailType,
            ),
          ],
          if (trailType == PositiveAppBarTrailType.convex) ...<Widget>[
            _PositiveAppBarTrailConvex(
              backgroundColor: backgroundColor,
              trailType: trailType,
            ),
          ],
        ],
      ),
    );
  }
}

class _PositiveAppBarContent extends StatelessWidget {
  const _PositiveAppBarContent({
    required this.backgroundColor,
    required this.applyLeadingandTrailingPadding,
    required this.safeAreaQueryData,
    required this.kPositiveLogoTag,
    required this.foregroundColor,
    required this.trailing,
  });

  final Color backgroundColor;
  final bool applyLeadingandTrailingPadding;
  final MediaQueryData? safeAreaQueryData;
  final String kPositiveLogoTag;
  final Color foregroundColor;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kAnimationDurationRegular,
      color: backgroundColor,
      padding: EdgeInsets.only(
        left: applyLeadingandTrailingPadding ? kPaddingLarge : 0,
        right: applyLeadingandTrailingPadding ? kPaddingLarge : 0,
        top: safeAreaQueryData?.padding.top ?? 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Hero(
              tag: kPositiveLogoTag,
              child: SvgPicture.asset(
                SvgImages.logosFooter,
                width: kLogoMaximumWidth,
                color: foregroundColor,
              ),
            ),
          ),
          const Spacer(),
          for (final Widget trailingWidget in trailing) ...<Widget>[
            trailingWidget,
            if (trailingWidget != trailing.last) ...<Widget>[
              const SizedBox(width: kPaddingSmall),
            ],
          ],
        ],
      ),
    );
  }
}

class _PositiveAppBarTrailConvex extends StatelessWidget {
  const _PositiveAppBarTrailConvex({
    required this.backgroundColor,
    required this.trailType,
  });

  final Color backgroundColor;
  final PositiveAppBarTrailType trailType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PositiveAppBar.kPositiveAppBarRadius,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(PositiveAppBar.kPositiveAppBarRadius * 2),
          bottomRight: Radius.circular(PositiveAppBar.kPositiveAppBarRadius * 2),
        ),
      ),
    );
  }
}

class _PositiveAppBarTrailConcave extends StatelessWidget {
  const _PositiveAppBarTrailConcave({
    required this.backgroundColor,
    required this.decorationColor,
    required this.trailType,
  });

  final Color backgroundColor;
  final Color decorationColor;
  final PositiveAppBarTrailType trailType;

  static const double kPositiveConcavePillHeight = 5.0;
  static const double kPositiveConcavePillWidth = 50.0;
  static const double kPositiveConcavePillRadius = 100.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PositiveAppBar.kPositiveAppBarRadius * 2,
      width: double.infinity,
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: kPositiveConcavePillHeight,
            width: kPositiveConcavePillWidth,
            decoration: BoxDecoration(
              color: decorationColor,
              borderRadius: BorderRadius.circular(kPositiveConcavePillRadius),
            ),
          ),
          const SizedBox(height: kPaddingExtraSmall),
          Container(
            height: PositiveAppBar.kPositiveAppBarRadius,
            width: double.infinity,
            decoration: BoxDecoration(
              color: decorationColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(PositiveAppBar.kPositiveAppBarRadius * 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
