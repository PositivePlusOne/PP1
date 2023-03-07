// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
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

class BiometricsPreferencesPage extends ConsumerWidget {
  const BiometricsPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BiometricsPreferencesViewModel viewModel = ref.watch(biometricsPreferencesViewModelProvider.notifier);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    // TODO(any): Localize
    return PositiveScaffold(
      decorations: buildType3ScaffoldDecorations(colors),
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: viewModel.onPermitSelected,
          label: 'Turn On Biometrics',
        ),
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            PositivePageIndicator(
              colors: colors,
              pagesNum: 6,
              currentPage: 5,
            ),
            const SizedBox(height: kPaddingMedium),
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Biometrics',
                  style: typography.styleHero.copyWith(
                    color: colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              'Enable Face ID to get quick access to your account. If this is not enabled you will need to input your password whenever you return to your account.',
              style: typography.styleBody.copyWith(
                color: colors.black,
              ),
            ),
            const SizedBox(height: kPaddingSmall),
            Row(
              children: <Widget>[
                PositiveButton(
                  colors: colors,
                  onTapped: viewModel.onDenySelected,
                  label: 'Do not enable biometrics',
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
