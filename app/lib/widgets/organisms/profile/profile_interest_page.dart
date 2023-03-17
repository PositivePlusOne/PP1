// Flutter imports:
import 'dart:math';

import 'package:app/gen/app_router.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/organisms/profile/vms/profile_interests_view_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/molecules/input/display_in_app.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/vms/hiv_status_view_model.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/buttons/select_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';

class ProfileInterestsPage extends ConsumerWidget {
  const ProfileInterestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveScaffold(
      // errorMessage: errorMessage,

      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: [
            Row(
              children: [
                PositiveButton(
                  colors: colors,
                  onTapped: () => ref.read(appRouterProvider).navigate(const HIVStatusRoute()),
                  label: localizations.shared_actions_back,
                  primaryColor: colors.black,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
                PositivePageIndicator(
                  colors: colors,
                  pagesNum: 9,
                  currentPage: 6,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_interest_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_interest_subtitle,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            // TODO(Dan): "Why need this" link. Out of scope for PP1-371. Implement this.
            const SizedBox(height: kPaddingMedium),
            const _SelectionList(),
          ],
        ),
      ],
      trailingWidgets: [
        Consumer(
          builder: (context, ref, child) => DisplayInApp(
            isChecked: ref.watch(hivStatusViewModelProvider).displayInApp,
            onTapped: () async {
              ref.read(hivStatusViewModelProvider.notifier).toggleDisplayInApp();
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
      footerWidgets: [
        Consumer(
          builder: (context, ref, child) {
            final viewModel = ref.watch(profileInterestsViewModelProvider);
            return PositiveButton(
              colors: colors,
              isDisabled: viewModel.isLoading || (viewModel.value?.selectedInterests.isEmpty ?? true),
              // TODO(Dan): update user profile
              onTapped: () async {},
              label: localizations.shared_actions_continue,
              layout: PositiveButtonLayout.textOnly,
              style: PositiveButtonStyle.primary,
              primaryColor: colors.black,
            );
          },
        ),
      ],
    );
  }
}

class _SelectionList extends ConsumerWidget {
  const _SelectionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(profileInterestsViewModelProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
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
    return Wrap(
      spacing: kPaddingExtraSmall,
      runSpacing: kPaddingExtraSmall,
      children: viewModel.value?.options
              .map(
                (option) => SelectButton(
                  colors: colors,
                  isActive: viewModel.value?.selectedInterests.contains(option) ?? false,
                  onChanged: (value) {
                    ref.read(profileInterestsViewModelProvider.notifier).updateSelectedInterests(option);
                  },
                  label: option.label,
                ),
              )
              .toList() ??
          [],
    );
  }
}
