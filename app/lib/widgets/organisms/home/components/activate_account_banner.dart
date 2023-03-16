// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/organisms/home/vms/home_view_model.dart';
import '../../../../constants/design_constants.dart';
import '../../../../dtos/system/design_colors_model.dart';
import '../../../../dtos/system/design_typography_model.dart';
import '../../../../resources/resources.dart';
import '../../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../../atoms/buttons/positive_button.dart';
import '../../../molecules/scaffolds/positive_scaffold_decoration.dart';

class ActivateAccountBanner extends ConsumerWidget {
  const ActivateAccountBanner({
    super.key,
  });

  static const double kHeight = 100.0;
  static const double kBorderRadius = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeViewModel viewModel = ref.read(homeViewModelProvider.notifier);

    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Container(
        height: kHeight,
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Stack(
          children: <Widget>[
            PositiveScaffoldDecoration(
              asset: SvgImages.decorationStar,
              color: colors.purple,
              alignment: Alignment.centerRight,
              rotationDegrees: -15.0,
              offset: const Offset(30.0, 50.0),
              scale: 1.1,
            ),
            PositiveScaffoldDecoration(
              asset: SvgImages.decorationRings,
              color: colors.teal,
              alignment: Alignment.centerRight,
              rotationDegrees: -15.0,
              offset: const Offset(0.0, 30.0),
              scale: 0.8,
            ),
            PositiveScaffoldDecoration(
              asset: SvgImages.decorationArrowRight,
              color: colors.yellow,
              alignment: Alignment.centerRight,
              rotationDegrees: -15.0,
              offset: const Offset(70.0, -20.0),
              scale: 0.6,
            ),
            PositiveScaffoldDecoration(
              asset: SvgImages.decorationEye,
              color: colors.green,
              alignment: Alignment.centerRight,
              rotationDegrees: 20.0,
              offset: const Offset(40.0, -55.0),
              scale: 0.5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: kPaddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Activate your account',
                        style: typography.styleTitle.copyWith(
                          color: colors.black,
                        ),
                      ),
                      Text(
                        'Engage and connect with the community',
                        style: typography.styleSubtitle.copyWith(
                          color: colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: kPaddingMedium),
                IntrinsicHeight(
                  child: PositiveButton(
                    colors: colors,
                    primaryColor: colors.black,
                    onTapped: viewModel.onSignInSelected,
                    size: PositiveButtonSize.medium,
                    label: 'Sign In',
                  ),
                ),
                const SizedBox(width: kPaddingMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
