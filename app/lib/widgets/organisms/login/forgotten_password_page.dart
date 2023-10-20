// Flutter imports:
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';

@RoutePage()
class ForgottenPasswordPage extends ConsumerWidget {
  const ForgottenPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final LoginViewModel viewModel = ref.watch(loginViewModelProvider.notifier);
    final LoginViewModelState state = ref.watch(loginViewModelProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveScaffold(
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: true,
          children: <Widget>[
            PositiveBackButton(isDisabled: state.isBusy),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_registration_forgotten_password,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_registration_forgotten_password_body,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
          ],
        ),
      ],
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: () => viewModel.onPasswordResetSelected(context),
          label: localizations.page_registration_forgotten_password_button,
          style: PositiveButtonStyle.primary,
          isDisabled: state.isBusy,
          layout: PositiveButtonLayout.textOnly,
        ),
      ],
    );
  }
}
