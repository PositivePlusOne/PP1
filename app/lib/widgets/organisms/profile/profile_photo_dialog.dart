// Flutter imports:
import 'package:app/widgets/organisms/profile/vms/profile_photo_view_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import '../../../../providers/system/design_controller.dart';

class ProfilePhotoModalDialog extends ConsumerStatefulWidget {
  const ProfilePhotoModalDialog({
    required this.viewModel,
    super.key,
  });

  final ProfilePhotoViewModel viewModel;

  @override
  ProfilePhotoModalDialogState createState() => ProfilePhotoModalDialogState();
}

class ProfilePhotoModalDialogState extends ConsumerState<ProfilePhotoModalDialog> {
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
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final List<Widget> children = [
      PositiveButton(
        colors: colors,
        primaryColor: colors.transparent,
        label: localizations.page_profile_photo_dialogue_take,
        onTapped: () => widget.viewModel.onSelectCamera(),
        isDisabled: _isBusy,
      ),
      Container(
        color: colors.colorGray5,
        height: kPaddingThin,
      ),
      PositiveButton(
        colors: colors,
        primaryColor: colors.transparent,
        label: localizations.page_profile_photo_dialogue_camera_roll,
        onTapped: () => widget.viewModel.onImagePicker(),
        isDisabled: _isBusy,
      ),
    ];

    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(kPaddingSmall),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusMedium),
              color: colors.black,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: kPaddingSmall),
                ...children.spaceWithVertical(kPaddingSmall),
                const SizedBox(height: kPaddingSmall),
              ],
            ),
          ),
          const SizedBox(height: kPaddingMedium),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusMedium),
              color: colors.black,
            ),
            child: PositiveButton(
              colors: colors,
              primaryColor: colors.transparent,
              label: localizations.shared_actions_cancel,
              onTapped: () => widget.viewModel.onCancelSelectCamera(),
              isDisabled: _isBusy,
            ),
          ),
        ],
      ),
    );
  }
}
