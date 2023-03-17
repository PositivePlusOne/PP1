import 'dart:math';

import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/buttons/select_button.dart';
import 'package:app/widgets/atoms/indicators/positive_page_indicator.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/remove_focus_wrapper.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/input/display_in_app.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/organisms/profile/vms/gender_select_view_model.dart';
import 'package:app/widgets/organisms/profile/vms/hiv_status_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';

class ProfileGenderSelectPage extends ConsumerWidget {
  const ProfileGenderSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return RemoveFocusWrapper(
      child: Stack(
        children: [
          PositiveScaffold(
            headingWidgets: <Widget>[
              PositiveBasicSliverList(
                children: [
                  Row(
                    children: [
                      PositiveButton(
                        colors: colors,
                        primaryColor: colors.black,
                        // TODO(Dan): Add correct route when it's built.
                        onTapped: () => ref.read(appRouterProvider).navigate(const ProfileNameEntryRoute()),
                        label: localizations.shared_actions_back,
                        style: PositiveButtonStyle.text,
                        layout: PositiveButtonLayout.textOnly,
                        size: PositiveButtonSize.small,
                      ),
                      PositivePageIndicator(
                        colors: colors,
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
                  const SizedBox(height: kPaddingMedium),
                  Text(
                    localizations.page_registration_gender_subtitle,
                    style: typography.styleBody.copyWith(color: colors.black),
                  ),
                  // TODO(Dan): "Why need this" link. Out of scope for PP1-260. Implement this.
                  const SizedBox(height: kPaddingMedium),
                  PositiveTextField(
                    onTextChanged: ref.read(genderSelectViewModelProvider.notifier).updateSearchQuery,
                    tintColor: colors.purple,
                    labelText: localizations.shared_search_hint,
                    suffixIcon: Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.all(kPaddingExtraSmall),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.black,
                      ),
                      child: Icon(
                        UniconsLine.search,
                        color: colors.white,
                        size: 20,
                      ),
                    ),
                  ),
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
                    builder: (context, ref, child) => DisplayInApp(
                      isChecked: ref.watch(hivStatusViewModelProvider).displayInApp,
                      onTapped: () async {
                        ref.read(hivStatusViewModelProvider.notifier).toggleDisplayInApp();
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer(
                    builder: (context, ref, child) {
                      final viewModel = ref.watch(genderSelectViewModelProvider);
                      return PositiveGlassSheet(
                        children: [
                          PositiveButton(
                            colors: colors,
                            isDisabled: viewModel.value?.selectedOptions == null || !viewModel.hasValue,
                            // TODO(Dan): update user profile
                            onTapped: () async {},
                            label: localizations.shared_actions_continue,
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
      ),
    );
  }
}

class _SelectionList extends ConsumerWidget {
  const _SelectionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(genderSelectViewModelProvider);
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final locale = AppLocalizations.of(context)!;
    if (viewModel.isLoading) {
      return Wrap(spacing: kPaddingExtraSmall, runSpacing: kPaddingExtraSmall, children: [
        for (int i = 0; i < 3; i++)
          Shimmer.fromColors(
            baseColor: colors.black,
            period: const Duration(milliseconds: 2000),
            highlightColor: colors.colorGray7,
            child: SelectButton(
              padding: EdgeInsets.symmetric(vertical: 11.5, horizontal: 40 + Random().nextDouble() * 30),
              colors: colors,
              label: '',
              isActive: false,
              onChanged: (value) {},
            ),
          )
      ]);
    }
    if ((viewModel.value?.options.isEmpty ?? false) && !(viewModel.value?.searchQuery?.isEmpty ?? false)) {
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
      children: viewModel.value?.options
              .map(
                (option) => SelectButton(
                  colors: colors,
                  isActive: viewModel.value?.selectedOptions?.contains(option) ?? false,
                  onChanged: (value) {
                    ref.read(genderSelectViewModelProvider.notifier).updateSelectedOption(option);
                  },
                  label: option.label,
                ),
              )
              .toList() ??
          [],
    );
  }
}
