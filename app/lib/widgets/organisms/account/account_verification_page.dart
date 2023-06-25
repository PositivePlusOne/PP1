// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/auth_constants.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../../providers/user/account_form_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_back_button.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../atoms/input/positive_pin_entry.dart';

//* Used when needing to reauthenticate the user prior to an operation.
//* Example: Change email and phone number
@RoutePage()
class AccountVerificationPage extends ConsumerWidget {
  const AccountVerificationPage({
    required this.onVerificationSuccess,
    this.buttonText,
    super.key,
  });

  final Future<void> Function() onVerificationSuccess;

  final String? buttonText;

  Color getTextFieldTintColor(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.pin.isEmpty) {
      return colors.purple;
    }

    return controller.state.isPinCorrect ? colors.green : colors.red;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    final AccountFormController controller = ref.watch(accountFormControllerProvider.notifier);
    ref.watch(accountFormControllerProvider);

    final Color tintColor = getTextFieldTintColor(controller, colors);

    return PositiveScaffold(
      backgroundColor: colors.colorGray1,
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onPinConfirmed,
          isDisabled: !controller.isPinValid || controller.state.isBusy,
          label: buttonText ?? localisations.shared_actions_continue,
        ),
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const PositiveBackButton(),
                const SizedBox(width: kPaddingSmall),
                PositivePageIndicator(
                  color: colors.black,
                  pagesNum: 2,
                  currentPage: 1,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localisations.page_account_verify_account_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Text(
              localisations.page_account_verify_account_body,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmallMedium),
            Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  label: localisations.page_account_verify_account_resend_code,
                  style: PositiveButtonStyle.text,
                  size: PositiveButtonSize.small,
                  isDisabled: controller.state.isBusy,
                  onTapped: controller.onPhoneNumberConfirmed,
                ),
              ),
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
      ],
    );
  }
}
