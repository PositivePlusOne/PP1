// Dart imports:

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
import 'package:app/dtos/database/profile/profile.dart';
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
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/organisms/profile/vms/gender_select_view_model.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';

@RoutePage()
class ProfileGenderSelectPage extends ConsumerWidget {
  const ProfileGenderSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final bool hasGenderVisibilityFlag = ref.watch(profileFormControllerProvider).visibilityFlags[kVisibilityFlagGenders] ?? false;

    final ProfileControllerState profileController = ref.watch(profileControllerProvider);
    final ProfileFormController formController = ref.read(profileFormControllerProvider.notifier);
    final ProfileFormState formControllerState = ref.watch(profileFormControllerProvider);

    final bool isBusy = ref.watch(profileFormControllerProvider.select((value) => value.isBusy));

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Profile? currentProfile = profileController.currentProfile;
    final bool isSameGender = currentProfile?.genders.length == formControllerState.genders.length && (currentProfile?.genders.containsAll(formControllerState.genders) ?? false);
    final bool isSameVisibility = currentProfile?.visibilityFlags.contains(kVisibilityFlagGenders) == formControllerState.visibilityFlags[kVisibilityFlagGenders];
    final bool isUpdateDisabled = isSameGender && isSameVisibility && formControllerState.formMode == FormMode.edit;

    final ScrollController scrollController = ScrollController();
    final GlobalKey selectionListKey = GlobalKey();

    return PositiveScaffold(
      onWillPopScope: () async => formController.onBackSelected(ProfileGenderSelectRoute),
      controller: scrollController,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: [
            Row(
              children: <Widget>[
                PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  onTapped: () => formController.onBackSelected(ProfileGenderSelectRoute),
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
            _Search(scrollController: scrollController, selectionListKey: selectionListKey),
            const SizedBox(height: kPaddingMedium),
            _SelectionList(key: selectionListKey),
          ],
        ),
      ],
      trailingWidgets: <Widget>[
        PositiveVisibilityHint(
          toggleState: PositiveTogglableState.fromBool(hasGenderVisibilityFlag),
          onTap: formController.onGenderVisibilityToggleRequested,
          isEnabled: !isBusy,
        ),
        const SizedBox(height: kPaddingMedium),
      ],
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          isDisabled: formControllerState.genders.isEmpty || formControllerState.isBusy || isUpdateDisabled,
          onTapped: () {
            formController.onGenderConfirmed(context);
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

class _Search extends ConsumerStatefulWidget {
  const _Search({Key? key, required this.scrollController, required this.selectionListKey}) : super(key: key);

  final ScrollController scrollController;
  final GlobalKey selectionListKey;

  @override
  ConsumerState<_Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<_Search> {
  TextEditingController? textController;

  Future<void> onFocusStateChanged(BuildContext context, bool isFocused) async {
    if (!isFocused) {
      return;
    }

    // Wait a bit of time for the keyboard to show up
    await Future.delayed(kAnimationDurationDebounce);

    // Use the widget.selectionListKey to get the position of the selection list in the scroll view
    widget.selectionListKey.currentContext!.findRenderObject()!.showOnScreen(
          duration: kAnimationDurationDebounce,
          rect: Rect.fromCenter(center: Offset.zero, width: 0, height: 200), //! 200px from the top of the widget
          curve: kAnimationCurveDefault,
        );
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final locale = AppLocalizations.of(context)!;
    return PositiveTextField(
      onControllerCreated: (controller) => textController = controller,
      onFocusedChanged: (focus) => onFocusStateChanged(context, focus),
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
