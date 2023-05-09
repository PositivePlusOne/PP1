// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
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
    super.key,
  });

  final bool active;
  final VoidCallback onTap;
  final IconData iconData;

  factory CameraFloatingButton.close({
    required bool active,
    required VoidCallback onTap,
  }) {
    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      iconData: UniconsLine.times,
    );
  }

  factory CameraFloatingButton.changeCamera({
    required bool active,
    required VoidCallback onTap,
  }) {
    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      iconData: UniconsLine.sync,
    );
  }

  factory CameraFloatingButton.addImage({
    required bool active,
    required VoidCallback onTap,
  }) {
    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      iconData: UniconsLine.image_plus,
    );
  }

  factory CameraFloatingButton.removeImage({
    required bool active,
    required VoidCallback onTap,
  }) {
    return CameraFloatingButton(
      active: active,
      onTap: onTap,
      iconData: UniconsLine.image_block,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    return PositiveTapBehaviour(
      onTap: onTap,
      isEnabled: active,
      showDisabledState: true,
      child: Container(
        height: kIconLarge,
        width: kIconLarge,
        decoration: BoxDecoration(
          color: colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(kIconSmall),
          border: Border.all(
            color: colors.white.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        child: Icon(
          iconData,
          color: colors.white,
        ),
      ),
    );
  }
}
