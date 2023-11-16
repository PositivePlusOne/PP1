// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../providers/system/design_controller.dart';

class CameraFloatingButton extends ConsumerWidget {
  const CameraFloatingButton({
    required this.active,
    required this.onTap,
    required this.iconData,
    this.backgroundColour,
    this.iconColour,
    this.removeBorder = false,
    this.isDisplayed = true,
    super.key,
  });

  final bool active;
  final void Function(BuildContext context) onTap;
  final IconData iconData;
  final bool removeBorder;
  final Color? iconColour;
  final Color? backgroundColour;
  final bool? isDisplayed;

  factory CameraFloatingButton.close({
    required bool active,
    required void Function(BuildContext context) onTap,
    bool? isDisplayed,
    Color? backgroundColour,
    Color? iconColour,
  }) {
    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      iconData: UniconsLine.multiply,
      isDisplayed: isDisplayed,
      backgroundColour: backgroundColour,
      iconColour: iconColour,
    );
  }

  factory CameraFloatingButton.changeCamera({
    required bool active,
    required void Function(BuildContext context) onTap,
  }) {
    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      iconData: UniconsLine.sync,
    );
  }

  factory CameraFloatingButton.skipMedia({
    required bool active,
    required void Function(BuildContext context) onTap,
  }) {
    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      iconData: UniconsLine.file_alt,
    );
  }

  factory CameraFloatingButton.showCamera({
    required bool active,
    required void Function(BuildContext context) onTap,
  }) {
    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      iconData: UniconsLine.camera_change,
    );
  }

  factory CameraFloatingButton.addImage({
    required bool active,
    required void Function(BuildContext context) onTap,
  }) {
    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      iconData: UniconsLine.image_plus,
    );
  }

  factory CameraFloatingButton.postWithoutImage({
    required bool active,
    required void Function(BuildContext context) onTap,
  }) {
    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      iconData: UniconsLine.image_block,
    );
  }

  factory CameraFloatingButton.timer({
    required bool active,
    required bool isOn,
    required Color iconColour,
    required Color backgroundColour,
    required void Function(BuildContext context) onTap,
  }) {
    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      backgroundColour: isOn ? backgroundColour : null,
      iconColour: isOn ? iconColour : null,
      iconData: UniconsLine.stopwatch,
    );
  }

  factory CameraFloatingButton.filters({
    required bool active,
    required bool isOn,
    required void Function(BuildContext context) onTap,
  }) {
    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      iconData: UniconsLine.sliders_v_alt,
    );
  }

  factory CameraFloatingButton.flash({
    required bool active,
    required void Function(BuildContext context) onTap,
    required FlashMode flashMode,
  }) {
    late IconData icon;

    switch (flashMode) {
      case FlashMode.none:
        icon = UniconsLine.bolt_slash;
        break;
      case FlashMode.auto:
        icon = UniconsLine.auto_flash;
        break;
      default:
        icon = UniconsLine.bolt;
    }

    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      iconData: icon,
      removeBorder: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    return PositiveTapBehaviour(
      onTap: onTap,
      isEnabled: active,
      child: SizedBox(
        height: kIconLarge,
        width: kIconLarge,
        child: Align(
          child: AnimatedContainer(
            duration: kAnimationDurationVeryFast,
            height: (isDisplayed ?? true) ? kIconLarge : kPaddingNone,
            width: (isDisplayed ?? true) ? kIconLarge : kPaddingNone,
            alignment: Alignment.center,
            decoration: !removeBorder
                ? BoxDecoration(
                    color: backgroundColour ?? colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(kIconSmall),
                    border: Border.all(
                      color: iconColour ?? colors.white,
                      width: kBorderThicknessSmall,
                    ),
                  )
                : null,
            child: AnimatedScale(
              duration: kAnimationDurationVeryFast,
              scale: (isDisplayed ?? true) ? 1.0 : 0.0,
              child: Icon(
                iconData,
                color: iconColour ?? colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
