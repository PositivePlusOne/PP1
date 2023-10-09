// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/company_sectors_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_page_indicator.dart';
import 'package:app/widgets/atoms/input/positive_text_field_dropdown.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';

@RoutePage()
class ProfileCompanySectorSelectPage extends ConsumerWidget {
  const ProfileCompanySectorSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    // final bool hasCompanySectorsVisibilityFlag = ref.watch(profileFormControllerProvider).visibilityFlags[kVisibilityFlagCompanySectors] ?? false;

    final ProfileControllerState profileController = ref.watch(profileControllerProvider);
    final ProfileFormController formController = ref.read(profileFormControllerProvider.notifier);
    final ProfileFormState formControllerState = ref.watch(profileFormControllerProvider);

    // final bool isBusy = ref.watch(profileFormControllerProvider.select((value) => value.isBusy));

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Profile? currentProfile = profileController.currentProfile;
    final bool isSameCompanySector = currentProfile?.companySectors.length == formControllerState.companySectors.length && (currentProfile?.companySectors.containsAll(formControllerState.companySectors) ?? false);
    final bool isSameVisibility = currentProfile?.visibilityFlags.contains(kVisibilityFlagCompanySectors) == formControllerState.visibilityFlags[kVisibilityFlagCompanySectors];
    final bool isUpdateDisabled = isSameCompanySector && isSameVisibility && formControllerState.formMode == FormMode.edit;

    final ScrollController scrollController = ScrollController();
    final GlobalKey selectionDropdownKey = GlobalKey();

    return PositiveScaffold(
      onWillPopScope: () async => formController.onBackSelected(ProfileCompanySectorSelectRoute),
      controller: scrollController,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: [
            Row(
              children: <Widget>[
                PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  onTapped: () => formController.onBackSelected(ProfileCompanySectorSelectRoute),
                  label: localizations.shared_actions_back,
                  isDisabled: formControllerState.isBusy,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
                if (formControllerState.formMode == FormMode.create)
                  PositivePageIndicator(
                    color: colors.black,
                    pagesNum: 9,
                    currentPage: 3,
                  ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_registration_company_sectors_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Text(
              localizations.page_registration_company_sectors_subtitle,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  label: localizations.shared_form_information_display,
                  size: PositiveButtonSize.small,
                  style: PositiveButtonStyle.text,
                  onTapped: () => formController.onCompanySectorHelpRequested(context),
                ),
              ),
            ),
            const SizedBox(height: kPaddingLarge),
            _SelectionDropdown(key: selectionDropdownKey),
          ],
        ),
      ],
      trailingWidgets: const [],
      // hiding the visibity button as company sectors are always visible
      /*<Widget>[
        PositiveVisibilityHint(
          toggleState: PositiveTogglableState.fromBool(hasCompanySectorsVisibilityFlag),
          onTap: formController.onCompanySectorsVisibilityToggleRequested,
          isEnabled: !isBusy,
        ),
        const SizedBox(height: kPaddingMedium),
      ],*/
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          isDisabled: formControllerState.companySectors.isEmpty || formControllerState.isBusy || isUpdateDisabled,
          onTapped: () {
            formController.onCompanySectorConfirmed(context);
          },
          label: formControllerState.formMode == FormMode.edit ? localizations.shared_actions_update : localizations.shared_actions_continue,
          layout: PositiveButtonLayout.textOnly,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.black,
        ),
      ],
    );
  }
}

class _SelectionDropdown extends ConsumerWidget {
  const _SelectionDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(companySectorsControllerProvider);

    final profileFormController = ref.watch(profileFormControllerProvider);
    final ProfileFormController profileFormControllerNotifier = ref.read(profileFormControllerProvider.notifier);

    // what's the currently selected option?
    CompanySectorsOption initialOption = viewModel.options.last;
    if (profileFormController.companySectors.isNotEmpty) {
      // we have some, just use the first as the selection
      final currentSelection = profileFormController.companySectors.first;
      initialOption = viewModel.options.firstWhere((element) => element.value == currentSelection, orElse: () => viewModel.options.last);
    }

    return PositiveTextFieldDropdown<CompanySectorsOption>(
        initialValue: initialOption,
        onValueChanged: (value) {
          if (value != null && value is CompanySectorsOption) {
            profileFormControllerNotifier.onCompanySectorSelected(value.value);
          }
        },
        values: viewModel.options,
        placeholderStringBuilder: (value) => value == null ? '' : (value as CompanySectorsOption).label,
        valueStringBuilder: (value) {
          if (value != null && value is CompanySectorsOption) {
            return value.label;
          } else {
            return '';
          }
        });
  }
}
