import 'package:app/providers/organisms/error/error_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';

class ErrorPage extends ConsumerWidget {
  const ErrorPage({
    required this.errorMessage,
    super.key,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final ErrorController controller = ref.read(errorControllerProvider.notifier);
    final ErrorControllerState state = ref.watch(errorControllerProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveScaffold(
      trailingWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: controller.onContinueSelected,
          label: localizations.shared_actions_continue,
          style: PositiveButtonStyle.primary,
          isDisabled: state.isBusy,
          layout: PositiveButtonLayout.textOnly,
        )
      ],
      children: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Text(
              localizations.shared_errors_defaults_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              errorMessage,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
