// Flutter imports:
import 'package:app/gen/app_router.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/error/vms/error_view_model.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';

@RoutePage()
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

    final ErrorViewModel viewModel = ref.read(errorViewModelProvider.notifier);
    final ErrorViewModelState state = ref.watch(errorViewModelProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveScaffold(
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: viewModel.onContinueSelected,
          label: localizations.shared_actions_continue,
          style: PositiveButtonStyle.primary,
          isDisabled: state.isBusy,
          layout: PositiveButtonLayout.textOnly,
        )
      ],
      headingWidgets: <Widget>[
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
