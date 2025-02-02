// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/profiles/profile_form_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_page_indicator.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/vms/profile_reference_image_view_model.dart';

@RoutePage()
class ProfileReferenceImageWelcomePage extends ConsumerWidget {
  const ProfileReferenceImageWelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileFormController controller = ref.read(profileFormControllerProvider.notifier);
    final ProfileFormState state = ref.watch(profileFormControllerProvider);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final ProfileReferenceImageViewModel viewModel = ref.watch(profileReferenceImageViewModelProvider.notifier);

    return PositiveScaffold(
      isBusy: state.isBusy,
      decorations: buildType4ScaffoldDecorations(colors),
      onWillPopScope: () => viewModel.onBackSelected(),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Row(
              children: <Widget>[
                PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  onTapped: () => controller.onBackSelected(ProfileReferenceImageWelcomeRoute),
                  isDisabled: state.isBusy,
                  label: localizations.shared_actions_back,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
                PositivePageIndicator(
                  color: colors.black,
                  pagesNum: 6,
                  currentPage: 3,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_image_welcome_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_image_welcome_body,
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
        PositiveHint.visibility(localizations.shared_form_defaults_hidden, colors),
        const SizedBox(height: kPaddingMedium),
      ],
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          isDisabled: state.isBusy,
          onTapped: () => viewModel.onRequestCamera(context),
          label: state.isBusy ? localizations.shared_actions_uploading : localizations.shared_actions_continue,
        ),
      ],
    );
  }
}
