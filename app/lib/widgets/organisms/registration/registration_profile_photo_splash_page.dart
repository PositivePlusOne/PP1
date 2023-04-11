// Dart imports:

// Flutter imports:
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/enumerations/positive_togglable_state.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/molecules/prompts/positive_visibility_hint.dart';
import 'package:app/widgets/organisms/registration/vms/registration_profile_image_view_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/widgets/organisms/registration/vms/registration_account_view_model.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../resources/resources.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../molecules/containers/positive_glass_sheet.dart';
import '../../molecules/layouts/positive_basic_sliver_list.dart';
import '../../molecules/prompts/positive_hint.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';
import '../shared/positive_generic_page.dart';

class RegistrationProfilePhotoSplashPage extends ConsumerWidget {
  const RegistrationProfilePhotoSplashPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RegistrationAccountViewModel viewModel = ref.watch(registrationAccountViewModelProvider.notifier);
    final RegistrationAccountViewModelState state = ref.watch(registrationAccountViewModelProvider);

    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveScaffold(
      backgroundWidget: Image.asset(
        MockImages.bike,
        fit: BoxFit.cover,
      ),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            PositivePageIndicator(
              colors: colors,
              pagesNum: 9,
              currentPage: 7,
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_registration_photo_splash_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_registration_photo_splash_body,
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
                  onTapped: () {},
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
          onTapped: () {},
          label: localizations.page_registration_photo_splash_continue,
        ),
      ],
    );
  }
}
