// Flutter imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Package imports:
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
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/input/positive_pin_entry.dart';

//* Used when needing to reauthenticate the user prior to an operation.
//* Example: Change email and phone number
@RoutePage()
class AccountVerificationPage extends ConsumerWidget {
  const AccountVerificationPage({
    required this.title,
    required this.body,
    required this.onVerificationSuccess,
    this.buttonText,
    super.key,
  });

  final String title;
  final String body;

  final Future<void> Function() onVerificationSuccess;

  final String? buttonText;

  Color getTextFieldTintColor(AccountFormController controller, DesignColorsModel colors) {
    if (controller.state.pin.isEmpty) {
      return colors.purple;
    }

    return controller.pinValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AccountFormController controller = ref.watch(accountFormControllerProvider.notifier);
    ref.watch(accountFormControllerProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final Color tintColor = getTextFieldTintColor(controller, colors);

    return PositiveScaffold(
      backgroundColor: colors.colorGray1,
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onPinConfirmed,
          isDisabled: !controller.isPinValid || controller.state.isBusy,
          label: buttonText ?? localizations.shared_actions_continue,
        ),
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Text(
              title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Text(
              body,
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
      ],
    );
  }
}
