// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
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
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/buttons/select_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';

@RoutePage()
class ProfileHivStatusPage extends ConsumerWidget {
  const ProfileHivStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final ProfileFormState state = ref.watch(profileFormControllerProvider);
    final ProfileFormController controller = ref.read(profileFormControllerProvider.notifier);

    return PositiveScaffold(
      onWillPopScope: () => controller.onBackSelected(ProfileHivStatusRoute),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Row(
              children: [
                PositiveButton(
                  colors: colors,
                  onTapped: () => controller.onBackSelected(ProfileHivStatusRoute),
                  label: localizations.shared_actions_back,
                  isDisabled: state.isBusy,
                  primaryColor: colors.black,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
                if (state.formMode != FormMode.edit)
                  PositivePageIndicator(
                    color: colors.black,
                    pagesNum: 9,
                    currentPage: 4,
                  ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
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
                  onTapped: () => controller.onHivStatusHelpRequested(context),
                ),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            const _SelectionList(),
          ],
        ),
      ],
      trailingWidgets: <Widget>[
        Consumer(
          builder: (context, ref, child) {
            return PositiveVisibilityHint(
              toggleState: PositiveTogglableState.fromBool(state.visibilityFlags[kVisibilityFlagHivStatus] ?? false),
              onTap: controller.onHivStatusVisibilityToggleRequested,
            );
          },
        ),
        const SizedBox(height: kPaddingMedium),
      ],
      footerWidgets: [
        Consumer(
          builder: (context, ref, child) {
            final formState = ref.watch(profileFormControllerProvider);
            final userProfile = ref.watch(profileControllerProvider).userProfile;
            final isSameHivStatus = formState.hivStatus == userProfile?.hivStatus && formState.formMode == FormMode.edit;
            final isSameVisibility = formState.visibilityFlags[kVisibilityFlagHivStatus] == userProfile?.visibilityFlags.contains(kVisibilityFlagHivStatus);

            return PositiveButton(
              colors: colors,
              isDisabled: (state.hivStatus?.isEmpty ?? true) || state.isBusy || (isSameHivStatus && isSameVisibility),
              onTapped: () async {
                controller.onHivStatusConfirm(thanksDescription: localizations.page_profile_hiv_status_thanks_desc);
              },
              label: formState.formMode == FormMode.edit ? localizations.shared_actions_update : localizations.shared_actions_continue,
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

  bool _isHivCategorySelected(ProfileFormState formState, HivStatus option) {
    if (formState.hivStatusCategory == null) {
      return (option.children?.any((element) => element.value == formState.hivStatus) ?? false);
    }
    return option.value == formState.hivStatusCategory;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HivStatusControllerState hivController = ref.watch(hivStatusControllerProvider);
    final ProfileFormState profileFormController = ref.watch(profileFormControllerProvider);
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
        if (profileFormController.hivStatusCategory != null || profileFormController.hivStatus != null) ...[
          Text(
            localizations.page_registration_hiv_status_option_title,
            style: typography.styleBody.copyWith(color: colors.black),
          ),
          const SizedBox(height: kPaddingMedium),
          Wrap(
            spacing: kPaddingExtraSmall,
            runSpacing: kPaddingExtraSmall,
            children: _getOptions(profileFormController, hivController)
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

  List<HivStatus>? _getOptions(ProfileFormState profileState, HivStatusControllerState hivControllerState) {
    if (profileState.hivStatusCategory != null) {
      return hivControllerState.hivStatuses.firstWhereOrNull((element) => element.value == profileState.hivStatusCategory)?.children;
    }
    if (profileState.hivStatus != null) {
      return hivControllerState.hivStatuses.firstWhereOrNull((element) => element.children?.any((element) => element.value == profileState.hivStatus) ?? false)?.children;
    }
    return null;
  }
}
