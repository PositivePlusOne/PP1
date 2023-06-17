// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/buttons/select_button.dart';
import 'package:app/widgets/atoms/indicators/positive_page_indicator.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/organisms/profile/vms/gender_select_view_model.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';

@RoutePage()
class ProfileGenderSelectPage extends ConsumerStatefulWidget {
  const ProfileGenderSelectPage({super.key});

  @override
  ConsumerState<ProfileGenderSelectPage> createState() => _ProfileGenderSelectPageState();
}

class _ProfileGenderSelectPageState extends ConsumerState<ProfileGenderSelectPage> {
  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final bool hasGenderVisibilityFlag = ref.watch(profileFormControllerProvider).visibilityFlags[kVisibilityFlagGenders] ?? false;

    final ProfileFormController formController = ref.read(profileFormControllerProvider.notifier);
    final bool isBusy = ref.watch(profileFormControllerProvider.select((value) => value.isBusy));

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return Stack(
      children: [
        PositiveScaffold(
          onWillPopScope: () async => formController.onBackSelected(ProfileGenderSelectRoute),
          headingWidgets: <Widget>[
            PositiveBasicSliverList(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(profileFormControllerProvider);
                    return Row(
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final state = ref.watch(profileFormControllerProvider);
                            return PositiveButton(
                              colors: colors,
                              primaryColor: colors.black,
                              onTapped: () => formController.onBackSelected(ProfileGenderSelectRoute),
                              label: localizations.shared_actions_back,
                              isDisabled: state.isBusy,
                              style: PositiveButtonStyle.text,
                              layout: PositiveButtonLayout.textOnly,
                              size: PositiveButtonSize.small,
                            );
                          },
                        ),
                        if (state.formMode == FormMode.create)
                          PositivePageIndicator(
                            color: colors.black,
                            pagesNum: 9,
                            currentPage: 3,
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: kPaddingMedium),
                Text(
                  localizations.page_registration_gender_title,
                  style: typography.styleHero.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingSmall),
                Text(
                  localizations.page_registration_gender_subtitle,
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
                      onTapped: () => formController.onGenderHelpRequested(context),
                    ),
                  ),
                ),
                const SizedBox(height: kPaddingLarge),
                const _Search(),
                const SizedBox(height: kPaddingMedium),
                const _SelectionList(),
                if (MediaQuery.of(context).viewInsets.bottom == 0) const SizedBox(height: kPaddingSplashTextBreak),
              ],
            ),
          ],
        ),
        AnimatedPositioned(
          // only show the display in app toggle when keyboard is open
          bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? 0 : max(MediaQuery.of(context).viewInsets.bottom - 120, 0),
          right: 0,
          left: 0,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutQuad,
          child: Container(
            padding: EdgeInsets.only(
              right: kPaddingMedium,
              left: kPaddingMedium,
              top: kPaddingExtraSmall,
              bottom: MediaQuery.of(context).viewPadding.bottom,
            ),
            decoration: BoxDecoration(color: colors.colorGray1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(
                  builder: (context, ref, child) => Material(
                    child: PositiveVisibilityHint(
                      toggleState: PositiveTogglableState.fromBool(hasGenderVisibilityFlag),
                      onTap: formController.onGenderVisibilityToggleRequested,
                      isEnabled: !isBusy,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Consumer(
                  builder: (context, ref, child) {
                    final formControllerWatch = ref.watch(profileFormControllerProvider);
                    final profileController = ref.watch(profileControllerProvider);
                    final userProfile = profileController.userProfile;
                    final isSameGender = userProfile?.genders.length == formControllerWatch.genders.length && (userProfile?.genders.containsAll(formControllerWatch.genders) ?? false);
                    final isSameVisibility = userProfile?.visibilityFlags.contains(kVisibilityFlagGenders) == formControllerWatch.visibilityFlags[kVisibilityFlagGenders];
                    final isUpdateDisabled = isSameGender && isSameVisibility && formControllerWatch.formMode == FormMode.edit;
                    return PositiveGlassSheet(
                      children: [
                        PositiveButton(
                          colors: colors,
                          isDisabled: formControllerWatch.genders.isEmpty || formControllerWatch.isBusy || isUpdateDisabled,
                          onTapped: () {
                            formController.onGenderConfirmed(localizations.page_profile_thanks_gender);
                          },
                          label: formControllerWatch.formMode == FormMode.edit ? localizations.shared_actions_update : localizations.shared_actions_continue,
                          layout: PositiveButtonLayout.textOnly,
                          style: PositiveButtonStyle.primary,
                          primaryColor: colors.black,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _Search extends ConsumerStatefulWidget {
  const _Search({Key? key}) : super(key: key);

  @override
  ConsumerState<_Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<_Search> {
  TextEditingController? textController;

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final locale = AppLocalizations.of(context)!;
    return PositiveTextField(
      onControllerCreated: (controller) => textController = controller,
      onTextChanged: (value) => ref.read(genderSelectViewModelProvider.notifier).updateSearchQuery(value),
      tintColor: colors.purple,
      labelText: locale.shared_search_hint,
      suffixIcon: _getTextFieldSuffixIcon(ref.watch(genderSelectViewModelProvider), colors, ref),
    );
  }

  Widget? _getTextFieldSuffixIcon(GenderSelectState state, DesignColorsModel colors, WidgetRef ref) {
    if (state.searchQuery != null && state.searchQuery!.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          ref.read(genderSelectViewModelProvider.notifier).clearSearchQuery();
          textController?.clear();
        },
        child: PositiveTextFieldIcon(
          icon: UniconsLine.times,
          iconColor: colors.white,
          color: colors.purple,
        ),
      );
    }
    return PositiveTextFieldIcon(
      color: colors.black,
      icon: UniconsLine.search,
    );
  }
}

class _SelectionList extends ConsumerWidget {
  const _SelectionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(genderSelectViewModelProvider);

    final profileFormController = ref.watch(profileFormControllerProvider);
    final ProfileFormController profileFormControllerNotifier = ref.read(profileFormControllerProvider.notifier);

    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final locale = AppLocalizations.of(context)!;
    if (viewModel.options.isEmpty && !(viewModel.searchQuery?.isEmpty ?? false)) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall, vertical: kPaddingExtraSmall),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
            child: Row(
              children: [
                const Icon(UniconsLine.times),
                Text(
                  locale.page_registration_gender_no_results,
                  style: typography.styleSubtextBold.copyWith(color: colors.black),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Wrap(
      spacing: kPaddingExtraSmall,
      runSpacing: kPaddingExtraSmall,
      children: viewModel.options
          .map(
            (option) => SelectButton(
              colors: colors,
              isActive: profileFormController.genders.contains(option.value),
              onChanged: (value) {
                profileFormControllerNotifier.onGenderSelected(option.value);
              },
              label: option.label,
            ),
          )
          .toList(),
    );
  }
}
