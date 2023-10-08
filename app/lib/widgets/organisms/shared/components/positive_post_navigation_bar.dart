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
import '../../post/vms/create_post_data_structures.dart';

class PositivePostNavigationBar extends HookConsumerWidget {
  const PositivePostNavigationBar({
    required this.onTapPost,
    required this.onTapClip,
    required this.onTapEvent,
    required this.onTapFlex,
    required this.activeButton,
    required this.flexCaption,
    required this.isEnabled,
    this.height = kCreatePostNavigationHeight,
    super.key,
  });

  final void Function(BuildContext context) onTapPost;
  final void Function(BuildContext context) onTapClip;
  final void Function(BuildContext context) onTapEvent;

  final bool isEnabled;

  final void Function(BuildContext context) onTapFlex;
  final PositivePostNavigationActiveButton activeButton;
  final String flexCaption;

  final double height;

  static const double kGlassContainerOpacity = 0.1;
  static const double kGlassContainerSigmaBlur = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double availableWidth = screenWidth - kPaddingSmall * 2 - kPaddingSmallMedium * 2;
    final double buttonWidth = (availableWidth - kPaddingExtraSmall * 2) / 3;

    final Widget buttonFlex = PositivePostNavigationBarButton(
      buttonStyle: PositivePostNavigationButtonStyle.filled,
      textColour: colours.black,
      caption: flexCaption,
      onTap: onTapFlex,
      width: availableWidth,
      isEnabled: isEnabled,
    );

    final Widget buttonPost = PositivePostNavigationBarButton(
      buttonStyle: activeButton == PositivePostNavigationActiveButton.post ? PositivePostNavigationButtonStyle.filled : PositivePostNavigationButtonStyle.disabled,
      textColour: colours.white,
      caption: localizations.page_home_post_post,
      onTap: activeButton == PositivePostNavigationActiveButton.post ? (_) {} : onTapPost,
      width: buttonWidth,
      isEnabled: isEnabled,
    );

    final Widget buttonClip = PositivePostNavigationBarButton(
      buttonStyle: activeButton == PositivePostNavigationActiveButton.clip ? PositivePostNavigationButtonStyle.filled : PositivePostNavigationButtonStyle.disabled,
      textColour: activeButton == PositivePostNavigationActiveButton.clip ? colours.black : colours.white,
      caption: localizations.page_home_post_clip,
      onTap: activeButton == PositivePostNavigationActiveButton.clip ? (_) {} : onTapClip,
      width: activeButton == PositivePostNavigationActiveButton.flex ? 0.0 : buttonWidth,
      isEnabled: isEnabled,
    );

    final Widget buttonEvent = PositivePostNavigationBarButton(
      buttonStyle: activeButton == PositivePostNavigationActiveButton.event ? PositivePostNavigationButtonStyle.filled : PositivePostNavigationButtonStyle.disabled,
      textColour: activeButton == PositivePostNavigationActiveButton.event ? colours.black : colours.white,
      caption: localizations.page_home_post_event,
      onTap: activeButton == PositivePostNavigationActiveButton.event ? (_) {} : onTapEvent,
      width: activeButton == PositivePostNavigationActiveButton.flex ? 0.0 : buttonWidth,
      isEnabled: isEnabled,
    );

    final Widget animatedPadding = AnimatedSize(
      duration: kAnimationDurationRegular,
      child: SizedBox(width: activeButton == PositivePostNavigationActiveButton.flex ? 0.0 : kPaddingExtraSmall),
    );

    late double animatedPaddingSize;
    switch (activeButton) {
      case PositivePostNavigationActiveButton.clip:
        animatedPaddingSize = buttonWidth + kPaddingExtraSmall;
        break;
      case PositivePostNavigationActiveButton.event:
        animatedPaddingSize = (buttonWidth + kPaddingExtraSmall) * 2;
        break;
      case PositivePostNavigationActiveButton.post:
      case PositivePostNavigationActiveButton.flex:
      default:
        animatedPaddingSize = 0;
    }

    late Color animatedButtonColour;
    switch (activeButton) {
      case PositivePostNavigationActiveButton.post:
        animatedButtonColour = colours.purple;
        break;
      case PositivePostNavigationActiveButton.clip:
        animatedButtonColour = colours.yellow;
        break;
      case PositivePostNavigationActiveButton.event:
        animatedButtonColour = colours.teal;
        break;
      case PositivePostNavigationActiveButton.flex:
      default:
        animatedButtonColour = colours.white;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadiusMassive),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: kGlassContainerSigmaBlur, sigmaY: kGlassContainerSigmaBlur),
        child: Container(
          width: double.infinity,
          height: height,
          padding: const EdgeInsets.all(kPaddingSmallMedium),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadiusMassive),
            color: colours.colorGray3.withOpacity(kOpacityQuarter),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                left: animatedPaddingSize,
                top: kPaddingNone,
                bottom: kPaddingNone,
                duration: kAnimationDurationFast,
                child: AnimatedContainer(
                  width: activeButton == PositivePostNavigationActiveButton.flex ? availableWidth : buttonWidth,
                  duration: kAnimationDurationFast,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: animatedButtonColour,
                    borderRadius: BorderRadius.circular(kBorderRadiusHuge),
                  ),
                ),
              ),
              if (activeButton == PositivePostNavigationActiveButton.flex) buttonFlex,
              if (activeButton != PositivePostNavigationActiveButton.flex)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buttonPost,
                    animatedPadding,
                    buttonClip,
                    animatedPadding,
                    buttonEvent,
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PositivePostNavigationBarButton extends HookConsumerWidget {
  const PositivePostNavigationBarButton({
    required this.buttonStyle,
    required this.textColour,
    required this.caption,
    required this.onTap,
    required this.width,
    required this.isEnabled,
    super.key,
  });

  final PositivePostNavigationButtonStyle buttonStyle;
  final Color textColour;
  final String caption;
  final void Function(BuildContext context) onTap;
  final double width;
  final bool isEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return PositiveTapBehaviour(
      onTap: onTap,
      isEnabled: isEnabled,
      child: AnimatedContainer(
        duration: kAnimationDurationRegular,
        height: kPaddingLarge,
        width: width,
        decoration: BoxDecoration(
          color: colors.transparent,
          border: Border.all(
            color: colors.transparent,
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
