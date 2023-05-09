// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../../dtos/system/design_colors_model.dart';
import '../../../../dtos/system/design_typography_model.dart';
import '../../../../providers/system/design_controller.dart';

class PositivePostNavigationBar extends HookConsumerWidget {
  const PositivePostNavigationBar({
    required this.onTapPost,
    required this.onTapClip,
    required this.onTapEvent,
    required this.onTapFlex,
    required this.activeButton,
    required this.flexCaption,
    super.key,
  });

  final VoidCallback onTapPost;
  final VoidCallback onTapClip;
  final VoidCallback onTapEvent;

  final VoidCallback onTapFlex;
  final ActiveButton activeButton;
  final String flexCaption;

  static const double kGlassContainerPadding = 15.0;
  static const double kGlassContainerBorderRadius = 40.0;
  static const double kGlassContainerOpacity = 0.1;
  static const double kGlassContainerSigmaBlur = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double availableWidth = screenWidth - kPaddingSmall * 2 - kGlassContainerPadding * 2;
    final double buttonWidth = (availableWidth - kPaddingExtraSmall * 2) / 3;

    Widget buttonPost;

    switch (activeButton) {
      case ActiveButton.flex:
        buttonPost = PositivePostNavigationBarButton(
          buttonStyle: ButtonStyle.filled,
          backgroundColour: colors.white,
          textColour: colors.black,
          caption: flexCaption,
          onTap: onTapFlex,
          width: availableWidth,
        );
        break;
      default:
        buttonPost = PositivePostNavigationBarButton(
          buttonStyle: activeButton == ActiveButton.post ? ButtonStyle.filled : ButtonStyle.disabled,
          backgroundColour: colors.purple,
          textColour: activeButton == ActiveButton.post ? colors.white : colors.purple,
          caption: localizations.page_home_post_post,
          onTap: activeButton == ActiveButton.post ? () {} : onTapPost,
          width: buttonWidth,
        );
    }

    final Widget buttonClip = PositivePostNavigationBarButton(
      buttonStyle: activeButton == ActiveButton.clip ? ButtonStyle.filled : ButtonStyle.disabled,
      backgroundColour: colors.yellow,
      textColour: activeButton == ActiveButton.clip ? colors.white : colors.yellow,
      caption: localizations.page_home_post_clip,
      onTap: activeButton == ActiveButton.clip ? () {} : onTapClip,
      width: activeButton == ActiveButton.flex ? 0.0 : buttonWidth,
    );

    final Widget buttonEvent = PositivePostNavigationBarButton(
      buttonStyle: activeButton == ActiveButton.event ? ButtonStyle.filled : ButtonStyle.disabled,
      backgroundColour: colors.teal,
      textColour: activeButton == ActiveButton.event ? colors.white : colors.teal,
      caption: localizations.page_home_post_event,
      onTap: activeButton == ActiveButton.event ? () {} : onTapEvent,
      width: activeButton == ActiveButton.flex ? 0.0 : buttonWidth,
    );

    final Widget animatedPadding = AnimatedSize(
      duration: kAnimationDurationRegular,
      child: SizedBox(width: activeButton == ActiveButton.flex ? 0.0 : kPaddingExtraSmall),
    );

    return Padding(
      padding: const EdgeInsets.only(
        left: kPaddingSmall,
        right: kPaddingSmall,
        bottom: kPaddingSmall,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kGlassContainerBorderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: kGlassContainerSigmaBlur, sigmaY: kGlassContainerSigmaBlur),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(kGlassContainerPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kGlassContainerBorderRadius),
              color: colors.colorGray3.withOpacity(kOpacityQuarter),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buttonPost,
                animatedPadding,
                buttonClip,
                animatedPadding,
                buttonEvent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PositivePostNavigationBarButton extends HookConsumerWidget {
  const PositivePostNavigationBarButton({
    required this.buttonStyle,
    required this.backgroundColour,
    required this.textColour,
    required this.caption,
    required this.onTap,
    required this.width,
    super.key,
  });

  final ButtonStyle buttonStyle;
  final Color backgroundColour;
  final Color textColour;
  final String caption;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return PositiveTapBehaviour(
      onTap: onTap,
      child: AnimatedContainer(
        duration: kAnimationDurationRegular,
        height: kPaddingLarge,
        width: width,
        decoration: BoxDecoration(
          color: (buttonStyle == ButtonStyle.filled) ? backgroundColour : colors.transparent,
          border: Border.all(
            color: buttonStyle != ButtonStyle.disabled ? backgroundColour : colors.transparent,
            style: BorderStyle.solid,
            width: kBorderThicknessMedium,
          ),
          borderRadius: BorderRadius.circular(kBorderRadiusMassive),
        ),
        padding: const EdgeInsets.all(kPaddingExtraSmall),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            caption,
            style: typography.styleButtonBold.copyWith(color: textColour),
            overflow: TextOverflow.clip,
          ),
        ),
      ),
    );
  }
}

enum ButtonStyle {
  filled,
  disabled,
  hollow,
}

enum ActiveButton {
  post,
  clip,
  event,
  flex,
}
