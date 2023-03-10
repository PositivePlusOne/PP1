// Flutter imports:
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/input/display_in_app.dart';
import 'package:app/widgets/organisms/profile/vms/hiv_status_view_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/buttons/select_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';

class HIVStatusPage extends ConsumerWidget {
  const HIVStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors =
        ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography =
        ref.watch(designControllerProvider.select((value) => value.typography));

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveScaffold(
      // errorMessage: errorMessage,
      hideTrailingDecoration: true,
      trailingWidgets: [
        Consumer(
          builder: (context, ref, child) => DisplayInApp(
            isChecked: ref.watch(hivStatusViewModelProvider).displayInApp,
            onTapped: () async {
              ref
                  .read(hivStatusViewModelProvider.notifier)
                  .toggleDisplayInApp();
            },
          ),
        ),
        const SizedBox(height: 12),
        PositiveGlassSheet(
          children: [
            PositiveButton(
              colors: colors,
              isDisabled: false,
              // TODO(Dan): update user profile
              onTapped: () async {},
              label: localizations.shared_actions_continue,
              layout: PositiveButtonLayout.textOnly,
              style: PositiveButtonStyle.primary,
              primaryColor: colors.black,
            ),
          ],
        ),
      ],
      children: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: kPaddingMedium + MediaQuery.of(context).padding.top,
            left: kPaddingMedium,
            right: kPaddingMedium,
            bottom: kPaddingMedium,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                const PositiveAppBar(),
                PositivePageIndicator(
                  colors: colors,
                  pagesNum: 9,
                  currentPage: 3,
                ),
                const SizedBox(height: kPaddingMassive),
                Text(
                  localizations.page_registration_hiv_status_title,
                  style: typography.styleHero.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingMedium),
                Text(
                  localizations.page_registration_hiv_status_subtitle,
                  style: typography.styleBody.copyWith(color: colors.black),
                ),
                // TODO(Dan): "Why need this" link. Out of scope for PP1-259. Implement this.
                const SizedBox(height: kPaddingMedium),
                const _SelectionList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectionList extends ConsumerWidget {
  const _SelectionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(hivStatusViewModelProvider);
    final DesignColorsModel colors =
        ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography =
        ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final option in viewModel.options) ...[
              SelectButton(
                colors: colors,
                isActive: viewModel.selectedStatus == option,
                onChanged: (value) {
                  ref
                      .read(hivStatusViewModelProvider.notifier)
                      .updateSelectedStatus(option);
                },
                label: option.label,
              ),
              const SizedBox(width: kPaddingExtraSmall),
            ],
          ],
        ),
        const SizedBox(height: kPaddingMedium),
        if (viewModel.selectedStatus != null) ...[
          Text(
            localizations.page_registration_hiv_status_option_title,
            style: typography.styleBody.copyWith(color: colors.black),
          ),
          const SizedBox(height: kPaddingMedium),
          Wrap(
            spacing: kPaddingExtraSmall,
            runSpacing: kPaddingExtraSmall,
            children: viewModel.selectedStatus!.children
                    ?.map(
                      (option) => SelectButton(
                        colors: colors,
                        isActive: viewModel.selectedSecondaryStatus == option,
                        onChanged: (value) {
                          ref
                              .read(hivStatusViewModelProvider.notifier)
                              .updateSelectedSecondaryStatus(option);
                        },
                        label: option.label,
                      ),
                    )
                    .toList() ??
                [],
          ),
        ]
      ],
    );
  }
}
