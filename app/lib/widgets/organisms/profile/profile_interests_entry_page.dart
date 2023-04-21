// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/content/interests_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/providers/user/profile_form_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../constants/profile_constants.dart';
import '../../../providers/enumerations/positive_togglable_state.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../molecules/prompts/positive_visibility_hint.dart';

@RoutePage()
class ProfileInterestsEntryPage extends ConsumerWidget {
  const ProfileInterestsEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final ProfileFormController controller = ref.read(profileFormControllerProvider.notifier);
    final ProfileFormState state = ref.watch(profileFormControllerProvider);

    final InterestsControllerState interestsState = ref.watch(interestsControllerProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final List<Widget> interestWidgets = [];
    for (final String interestKey in interestsState.interests.keys) {
      final String interestLocale = interestsState.interests[interestKey]!;
      interestWidgets.add(
        IntrinsicWidth(
          child: PositiveButton(
            colors: colors,
            onTapped: () => controller.onInterestToggled(interestKey),
            label: interestLocale,
            primaryColor: state.interests.contains(interestKey) ? colors.teal : colors.black,
            style: PositiveButtonStyle.primary,
            layout: PositiveButtonLayout.textOnly,
            size: PositiveButtonSize.medium,
          ),
        ),
      );
    }

    return PositiveScaffold(
      trailingWidgets: <Widget>[
        PositiveVisibilityHint(
          toggleState: PositiveTogglableState.fromBool(state.visibilityFlags[kVisibilityFlagInterests] ?? false),
          onTap: controller.onInterestsVisibilityToggleRequested,
        ),
        const SizedBox(height: kPaddingMedium),
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Row(
              children: [
                PositiveButton(
                  colors: colors,
                  onTapped: () => state.formMode == FormMode.edit ? context.router.pop() : controller.onBackSelected(ProfileInterestsEntryRoute),
                  isDisabled: state.isBusy,
                  label: localizations.shared_actions_back,
                  primaryColor: colors.black,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
                if (state.formMode != FormMode.edit)
                  PositivePageIndicator(
                    color: colors.black,
                    pagesNum: 9,
                    currentPage: 5,
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
                  onTapped: () => controller.onInterestsHelpRequested(context),
                ),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            Wrap(
              spacing: kPaddingExtraSmall,
              runSpacing: kPaddingExtraSmall,
              children: interestWidgets,
            ),
          ],
        ),
      ],
      footerWidgets: [
        Consumer(
          builder: (context, ref, child) {
            final userProfile = ref.watch(profileControllerProvider).userProfile;
            final isSameInterests = userProfile?.interests.length == state.interests.length && (userProfile?.interests.every((element) => state.interests.contains(element)) ?? false);
            return PositiveButton(
              colors: colors,
              isDisabled: state.isBusy || !controller.isInterestsValid || isSameInterests,
              onTapped: () => controller.onInterestsConfirmed(thanksDescription: localizations.page_profile_thanks_interests),
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
