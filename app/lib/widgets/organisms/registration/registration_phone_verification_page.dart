// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/auth_constants.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../../providers/user/new_account_form_controller.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../atoms/input/positive_pin_entry.dart';
import '../../molecules/navigation/positive_app_bar.dart';

class RegistrationPhoneVerificationPage extends ConsumerWidget {
  const RegistrationPhoneVerificationPage({super.key});

  Color getTextFieldTintColor(NewAccountFormController controller, DesignColorsModel colors) {
    if (controller.state.pin.isEmpty) {
      return colors.purple;
    }

    return controller.pinValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final NewAccountFormController controller = ref.watch(newAccountFormControllerProvider.notifier);
    ref.watch(newAccountFormControllerProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final Color tintColor = getTextFieldTintColor(controller, colors);

    return PositiveScaffold(
      backgroundColor: colors.colorGray1,
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onPinConfirmed,
          isDisabled: !controller.isPinValid,
          label: localizations.shared_actions_continue,
        ),
      ],
      headingWidgets: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: mediaQueryData.padding.top + kPaddingMedium,
            left: kPaddingMedium,
            right: kPaddingMedium,
            bottom: kPaddingMedium,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                const PositiveAppBar(),
                const SizedBox(height: kPaddingMassive),
                PositivePageIndicator(
                  colors: colors,
                  pagesNum: 6,
                  currentPage: 3,
                ),
                const SizedBox(height: kPaddingMedium),
                Text(
                  'Verify Account',
                  style: typography.styleHero.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingSmall),
                Text(
                  'Enter the code we sent to you',
                  style: typography.styleBody.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingLarge),
                PositivePinEntry(
                  pinLength: kVerificationCodeLength,
                  tintColor: tintColor,
                  isEnabled: !controller.state.isBusy,
                  onPinChanged: controller.onPinChanged,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
