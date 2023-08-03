// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import '../../../../../providers/system/design_controller.dart';

class ProfilePhotoDialog extends ConsumerWidget {
  const ProfilePhotoDialog({
    required this.onCameraSelected,
    required this.onImagePickerSelected,
    super.key,
  });

  final VoidCallback onCameraSelected;
  final VoidCallback onImagePickerSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        PositiveButton(
          colors: colors,
          onTapped: onCameraSelected,
          label: localizations.page_profile_photo_dialogue_take,
          primaryColor: colors.white,
          style: PositiveButtonStyle.primary,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: onImagePickerSelected,
          label: localizations.page_profile_photo_dialogue_camera_roll,
          primaryColor: colors.black,
          style: PositiveButtonStyle.primary,
        ),
      ],
    );
  }
}
