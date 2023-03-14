// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/providers/system/system_controller.dart';
import '../../../../resources/resources.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_button.dart';

enum PositiveAppBarTrailType {
  none,
  convex,
  concave,
}

class PositiveAppBar extends ConsumerWidget with PreferredSizeWidget {
  const PositiveAppBar({
    this.title = '',
    this.leading,
    this.trailing = const <Widget>[],
    this.bottom,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.decorationColor = Colors.white,
    this.applyLeadingandTrailingPadding = false,
    this.safeAreaQueryData,
    this.trailType = PositiveAppBarTrailType.none,
    super.key,
  });

  final String title;

  final Color foregroundColor;
  final Color backgroundColor;
  final Color decorationColor;

  final bool applyLeadingandTrailingPadding;
  final MediaQueryData? safeAreaQueryData;

  final Widget? leading;
  final List<Widget> trailing;
  final PreferredSizeWidget? bottom;

  final PositiveAppBarTrailType trailType;

  @override
  Size get preferredSize {
    final double baseHeight = PositiveButton.kButtonIconRadiusRegular + PositiveButton.kButtonPaddingMedium.vertical;
    const double paddingHeight = kPaddingSmall * 2;
    final double marginHeight = safeAreaQueryData?.padding.top ?? 0;
    final double bottomHeight = bottom == null ? 0 : bottom!.preferredSize.height + kPaddingSmall;

    //* The decoration height is the height of the concave or convex trail
    final double decorationHeight = trailType == PositiveAppBarTrailType.concave
        ? kPositiveAppBarRadius * 2
        : trailType == PositiveAppBarTrailType.convex
            ? kPositiveAppBarRadius
            : 0;

    const double width = double.infinity;
    final double height = baseHeight + paddingHeight + marginHeight + bottomHeight + decorationHeight;

    return Size(width, height);
  }

  static const String kPositiveLogoTag = 'pp1-app-bar-hero';
  static const double kPositiveAppBarRadius = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return SizedBox(
      height: preferredSize.height,
      width: preferredSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: _PositiveAppBarContent(
              title: title,
              titleStyle: typography.styleTitleTwo.copyWith(color: foregroundColor),
              backgroundColor: backgroundColor,
              applyLeadingandTrailingPadding: applyLeadingandTrailingPadding,
              safeAreaQueryData: safeAreaQueryData,
              kPositiveLogoTag: kPositiveLogoTag,
              foregroundColor: foregroundColor,
              leading: leading,
              trailing: trailing,
            ),
          ),
          if (bottom != null) ...<Widget>[
            Container(
              color: backgroundColor,
              padding: const EdgeInsets.only(top: kPaddingSmall),
              child: bottom,
            ),
          ],
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

class _PositiveAppBarContent extends ConsumerWidget {
  const _PositiveAppBarContent({
    required this.title,
    required this.backgroundColor,
    required this.applyLeadingandTrailingPadding,
    required this.safeAreaQueryData,
    required this.kPositiveLogoTag,
    required this.foregroundColor,
    required this.leading,
    required this.trailing,
    required this.titleStyle,
  });

  final String title;
  final Color backgroundColor;
  final bool applyLeadingandTrailingPadding;
  final MediaQueryData? safeAreaQueryData;
  final String kPositiveLogoTag;
  final Color foregroundColor;
  final Widget? leading;
  final List<Widget> trailing;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          if (leading != null) ...<Widget>[
            leading!,
            const Spacer(),
          ],
          if (title.isEmpty) ...<Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Hero(
                tag: kPositiveLogoTag,
                child: GestureDetector(
                  onLongPress: ref.read(systemControllerProvider.notifier).launchDevelopmentTooling,
                  child: SvgPicture.asset(
                    SvgImages.logosFooter,
                    width: kLogoMaximumWidth,
                    color: foregroundColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
          if (title.isNotEmpty) ...<Widget>[
            Text(
              title.asHandle,
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            const Spacer(),
          ],
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
