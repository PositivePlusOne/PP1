// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import '../../../../../providers/system/design_controller.dart';

class ProfilePhotoDialog extends ConsumerStatefulWidget {
  const ProfilePhotoDialog({
    required this.onCameraSelected,
    required this.onImagePickerSelected,
    super.key,
  });

  final VoidCallback onCameraSelected;
  final VoidCallback onImagePickerSelected;

  @override
  ProfilePhotoDialogState createState() => ProfilePhotoDialogState();
}

class ProfilePhotoDialogState extends ConsumerState<ProfilePhotoDialog> {
  bool _isBusy = false;

  Future<void> onOptionSelected() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isBusy = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveDialog(
      title: 'Photo options',
      children: <Widget>[
        PositiveButton(
          colors: colors,
          onTapped: widget.onCameraSelected,
          label: localizations.page_profile_photo_dialogue_take,
          primaryColor: colors.white,
          style: PositiveButtonStyle.primary,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: widget.onImagePickerSelected,
          label: localizations.page_profile_photo_dialogue_camera_roll,
          primaryColor: colors.black,
          style: PositiveButtonStyle.primary,
        ),
      ],
    );
  }
}
