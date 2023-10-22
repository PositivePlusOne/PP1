// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';
import '../../../../resources/resources.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_button.dart';

enum PositiveAppBarTrailType {
  none,
  convex,
  concave,
}

class PositiveAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PositiveAppBar({
    this.title = '',
    this.centerTitle = false,
    this.includeLogoWherePossible = true,
    this.leading,
    this.trailing = const <Widget>[],
    this.bottom,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.decorationColor = Colors.white,
    this.backgroundImage,
    this.applyLeadingandTrailingPadding = false,
    this.safeAreaQueryData,
    this.trailType = PositiveAppBarTrailType.none,
    super.key,
  });

  final String title;
  final bool centerTitle;
  final bool includeLogoWherePossible;

  final Color foregroundColor;
  final Color backgroundColor;
  final Color decorationColor;
  final Media? backgroundImage;

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
    final double decorationHeight = getDecorationHeight;

    const double width = double.infinity;
    final double height = baseHeight + paddingHeight + marginHeight + bottomHeight + decorationHeight;

    return Size(width, height);
  }

  double get getDecorationHeight => trailType == PositiveAppBarTrailType.concave
      ? kPositiveAppBarRadius * 2
      : trailType == PositiveAppBarTrailType.convex
          ? kPositiveAppBarRadius
          : 0;

  static const String kPositiveLogoTag = 'pp1-app-bar-hero';
  static const double kPositiveAppBarRadius = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return SizedBox(
      height: preferredSize.height,
      width: preferredSize.width,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: kPaddingNone,
            left: kPaddingNone,
            top: kPaddingNone,
            bottom: getDecorationHeight,
            child: AnimatedContainer(
              color: backgroundColor,
              duration: kAnimationDurationExtended,
            ),
          ),
          if (backgroundImage != null) ...<Widget>[
            Positioned.fill(
              child: PositiveMediaImage(
                media: backgroundImage!,
                fit: BoxFit.cover,
                thumbnailTargetSize: PositiveThumbnailTargetSize.large,
              ),
            ),
            //* Use the background color as a darkening overlay
            //! TODO(ryan): Chat to Chris about how this needs to appear. (Color burns, requirements, etc).
            Positioned.fill(
              child: Container(
                color: backgroundColor.withOpacity(kOpacityVignette),
              ),
            ),
          ],
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: _PositiveAppBarContent(
                  title: title,
                  titleStyle: typography.styleTitleTwo.copyWith(color: foregroundColor),
                  centerTitle: centerTitle,
                  backgroundColor: Colors.transparent,
                  applyLeadingandTrailingPadding: applyLeadingandTrailingPadding,
                  safeAreaQueryData: safeAreaQueryData,
                  foregroundColor: foregroundColor,
                  leading: leading,
                  trailing: trailing,
                  includeLogoWherePossible: includeLogoWherePossible,
                ),
              ),
              if (bottom != null) ...<Widget>[
                AnimatedContainer(
                  color: Colors.transparent,
                  duration: kAnimationDurationRegular,
                  padding: const EdgeInsets.only(top: kPaddingSmall),
                  child: bottom,
                ),
              ],
              if (trailType == PositiveAppBarTrailType.concave) ...<Widget>[
                _PositiveAppBarTrailConcave(
                  backgroundColor: Colors.transparent,
                  decorationColor: decorationColor,
                  trailType: trailType,
                ),
              ],
              if (trailType == PositiveAppBarTrailType.convex) ...<Widget>[
                _PositiveAppBarTrailConvex(
                  backgroundColor: decorationColor,
                  trailType: trailType,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _PositiveAppBarContent extends ConsumerWidget {
  const _PositiveAppBarContent({
    required this.title,
    required this.titleStyle,
    required this.centerTitle,
    required this.backgroundColor,
    required this.applyLeadingandTrailingPadding,
    required this.safeAreaQueryData,
    required this.foregroundColor,
    required this.leading,
    required this.trailing,
    required this.includeLogoWherePossible,
  });

  final String title;
  final TextStyle titleStyle;
  final bool centerTitle;

  final Color backgroundColor;
  final bool applyLeadingandTrailingPadding;
  final MediaQueryData? safeAreaQueryData;
  final Color foregroundColor;
  final Widget? leading;
  final List<Widget> trailing;
  final bool includeLogoWherePossible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: kAnimationDurationRegular,
      color: backgroundColor,
      padding: EdgeInsets.only(
        left: applyLeadingandTrailingPadding ? kPaddingMedium : 0,
        right: applyLeadingandTrailingPadding ? kPaddingMedium : 0,
        top: safeAreaQueryData?.padding.top ?? 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (leading != null) ...<Widget>[
            leading!,
            const SizedBox(width: kPaddingSmall),
          ],
          if (title.isEmpty && includeLogoWherePossible) ...<Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onLongPress: ref.read(systemControllerProvider.notifier).launchDevelopmentTooling,
                  child: Hero(
                    tag: PositiveAppBar.kPositiveLogoTag,
                    child: SvgPicture.asset(
                      SvgImages.logosFooter,
                      width: kLogoMaximumWidth,
                      colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (title.isNotEmpty) ...<Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                child: Text(
                  title.asHandle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                  style: titleStyle,
                ),
              ),
            ),
          ],
          if (title.isEmpty && !includeLogoWherePossible) ...<Widget>[
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
    return AnimatedContainer(
      duration: kAnimationDurationExtended,
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
          AnimatedContainer(
            duration: kAnimationDurationRegular,
            height: kPositiveConcavePillHeight,
            width: kPositiveConcavePillWidth,
            decoration: BoxDecoration(
              color: decorationColor,
              borderRadius: BorderRadius.circular(kPositiveConcavePillRadius),
            ),
          ),
          const SizedBox(height: kPaddingExtraSmall),
          AnimatedContainer(
            duration: kAnimationDurationRegular,
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
