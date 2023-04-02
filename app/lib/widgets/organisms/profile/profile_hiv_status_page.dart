// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/content/hiv_status_controller.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/user/profile_form_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/buttons/select_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';

class ProfileHivStatusPage extends ConsumerWidget {
  const ProfileHivStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveScaffold(
      // errorMessage: errorMessage,

      headingWidgets: <Widget>[
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
                Row(
                  children: [
                    PositiveButton(
                      colors: colors,
                      onTapped: () => ref.read(profileFormControllerProvider.notifier).onBackSelected(ProfileHivStatusRoute),
                      label: localizations.shared_actions_back,
                      primaryColor: colors.black,
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
                      onTapped: () => ref.read(profileFormControllerProvider.notifier).onHivStatusHelpRequested(context),
                    ),
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
                const _SelectionList(),
              ],
            ),
          ),
        ),
      ],

      trailingWidgets: <Widget>[
        Consumer(
          builder: (context, ref, child) {
            return PositiveVisibilityHint(
              toggleState: PositiveTogglableState.fromBool(ref.watch(profileFormControllerProvider).visibilityFlags[kVisibilityFlagInterests] ?? false),
              onTap: ref.read(profileFormControllerProvider.notifier).onInterestsVisibilityToggleRequested,
            );
          },
        ),
        const SizedBox(height: kPaddingMedium),
      ],
      footerWidgets: [
        PositiveButton(
          colors: colors,
          isDisabled: false,
          onTapped: () async {
            ref.read(profileFormControllerProvider.notifier).onHivStatusConfirm();
          },
          label: localizations.shared_actions_continue,
          layout: PositiveButtonLayout.textOnly,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.black,
        ),
      ],
    );
  }
}

class _SelectionList extends ConsumerWidget {
  const _SelectionList({Key? key}) : super(key: key);

  bool _isHivCategorySelected(ProfileFormState formState, HivStatus option) {
    if (formState.hivStatusCategory == null) {
      return (option.children?.any((element) => element.value == formState.hivStatus) ?? false);
    }
    return option.value == formState.hivStatusCategory;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hivController = ref.watch(hivStatusControllerProvider);
    final profileFormController = ref.watch(profileFormControllerProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final option in hivController.hivStatuses) ...[
              PositiveButton(
                colors: colors,
                onTapped: () => ref.read(profileFormControllerProvider.notifier).onHivStatusCategoryToggled(option.value),
                label: option.label,
                primaryColor: _isHivCategorySelected(profileFormController, option) ? colors.teal : colors.black,
                style: PositiveButtonStyle.primary,
                layout: PositiveButtonLayout.textOnly,
                size: PositiveButtonSize.medium,
              ),
              const SizedBox(width: kPaddingExtraSmall),
            ],
          ],
        ),
        const SizedBox(height: kPaddingMedium),
        if (profileFormController.hivStatus != null) ...[
          Text(
            localizations.page_registration_hiv_status_option_title,
            style: typography.styleBody.copyWith(color: colors.black),
          ),
          const SizedBox(height: kPaddingMedium),
          Wrap(
            spacing: kPaddingExtraSmall,
            runSpacing: kPaddingExtraSmall,
            children: hivController.hivStatuses
                    .firstWhereOrNull((element) => element.value == profileFormController.hivStatusCategory)
                    ?.children
                    ?.map(
                      (option) => SelectButton(
                        colors: colors,
                        isActive: profileFormController.hivStatus == option.value,
                        onChanged: (value) {
                          ref.read(profileFormControllerProvider.notifier).onHivStatusToggled(option.value);
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
