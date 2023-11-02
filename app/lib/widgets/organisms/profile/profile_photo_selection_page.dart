// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_photo_dialog.dart';
import 'package:app/widgets/organisms/profile/vms/profile_photo_view_model.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../resources/resources.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../molecules/layouts/positive_basic_sliver_list.dart';
import '../../molecules/prompts/positive_hint.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';

@RoutePage()
class ProfilePhotoSelectionPage extends ConsumerWidget {
  const ProfilePhotoSelectionPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfilePhotoViewModel viewModel = ref.watch(profilePhotoViewModelProvider.notifier);
    final ProfilePhotoViewModelState state = ref.watch(profilePhotoViewModelProvider);

    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveScaffold(
      onWillPopScope: viewModel.onWillPopScope,
      forceDecorationMaxSize: true,
      decorationWidget: Image.asset(
        MockImages.bike,
        fit: BoxFit.cover,
      ),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Row(
              children: [
                PositiveButton(
                  colors: colors,
                  onTapped: () => ref.read(profileFormControllerProvider.notifier).onBackSelected(ProfilePhotoSelectionRoute),
                  label: localizations.shared_actions_back,
                  primaryColor: colors.black,
                  isDisabled: state.isBusy,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
                PositivePageIndicator(
                  color: colors.black,
                  pagesNum: 6,
                  currentPage: 4,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_photo_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_photo_body,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  label: localizations.shared_form_information_display,
                  size: PositiveButtonSize.small,
                  style: PositiveButtonStyle.text,
                  onTapped: () => viewModel.moreInformation(context),
                ),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
          ],
        ),
      ],
      trailingWidgets: <Widget>[
        PositiveHint.alwaysVisible(localizations.molecule_display_in_app_always_display, colors),
        const SizedBox(height: kPaddingMedium),
      ],
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          isDisabled: state.isBusy,
          label: state.isBusy ? localizations.shared_actions_uploading : localizations.page_profile_photo_continue,
          onTapped: () => PositiveDialog.show(
            title: 'Photo options',
            context: context,
            child: ProfilePhotoDialog(
              onCameraSelected: () => viewModel.onSelectCamera(context),
              onImagePickerSelected: viewModel.onImagePicker,
            ),
          ),
        ),
      ],
    );
  }
}
