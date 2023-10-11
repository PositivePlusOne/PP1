// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/biometrics/vms/biometrics_preferences_view_model.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/indicators/positive_page_indicator.dart';

@RoutePage()
class BiometricsPreferencesPage extends ConsumerWidget {
  const BiometricsPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BiometricsPreferencesViewModel viewModel = ref.watch(biometricsPreferencesViewModelProvider.notifier);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveScaffold(
      decorations: buildType3ScaffoldDecorations(colors),
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: viewModel.onPermitSelected,
          label: localizations.page_profile_biometrics_action,
        ),
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            PositivePageIndicator(
              color: colors.black,
              pagesNum: 4,
              currentPage: 3,
            ),
            const SizedBox(height: kPaddingLarge),
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  localizations.page_profile_biometrics_title,
                  style: typography.styleHero.copyWith(color: colors.black),
                ),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_biometrics_instruction,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Row(
              children: <Widget>[
                PositiveButton(
                  colors: colors,
                  onTapped: viewModel.onDenySelected,
                  label: localizations.page_profile_biometrics_do_not_enable,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
