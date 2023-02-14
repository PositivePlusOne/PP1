// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/organisms/onboarding/onboarding_welcome_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold_decoration.dart';
import 'package:app/widgets/organisms/onboarding/enumerations/onboarding_style.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/organisms/onboarding/onboarding_connect_controller.dart';
import '../../../resources/resources.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';
import '../../molecules/scaffolds/positive_scaffold_decoration_model.dart';

class OnboardingConnectPage extends ConsumerWidget {
  const OnboardingConnectPage({
    this.style = OnboardingStyle.includeFeatures,
    super.key,
  });

  final OnboardingStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OnboardingConnectController controller = ref.read(onboardingConnectControllerProvider.notifier);

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final int stepCount = style.stepCount;
    const int currentStep = 0;

    final List<PositiveScaffoldDecorationModel> scaffoldDecorations = <PositiveScaffoldDecorationModel>[
      PositiveScaffoldDecorationModel(
        asset: SvgImages.decorationStar,
        alignment: Alignment.bottomRight,
        color: colors.purple,
        scale: 1.5,
        offsetX: 50.0,
        offsetY: 50.0,
        rotationDegrees: 0.0,
      ),
      PositiveScaffoldDecorationModel(
        asset: SvgImages.decorationArrowRight,
        alignment: Alignment.topRight,
        color: colors.yellow,
        scale: 1.2,
        offsetX: 50.0,
        offsetY: 50.0,
        rotationDegrees: -15.0,
      ),
      PositiveScaffoldDecorationModel(
        asset: SvgImages.decorationRings,
        alignment: Alignment.bottomLeft,
        color: colors.teal,
        scale: 1.5,
        offsetX: -50.0,
        offsetY: 25.0,
        rotationDegrees: -15.0,
      ),
      PositiveScaffoldDecorationModel(
        asset: SvgImages.decorationEye,
        alignment: Alignment.topLeft,
        color: colors.green,
        scale: 1.1,
        offsetX: -15.0,
        offsetY: -0.0,
        rotationDegrees: 15.0,
      ),
    ];

    return PositiveScaffold(
      backgroundColor: colors.white,
      decorations: scaffoldDecorations.map((e) => PositiveScaffoldDecoration.fromPageDecoration(e)).toList(),
      trailingWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          isDisabled: false,
          onTapped: controller.onContinueSelected,
          label: localizations.shared_actions_continue,
          layout: PositiveButtonLayout.textOnly,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.black,
        ),
      ],
      children: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: kPaddingMedium + mediaQueryData.padding.top,
            left: kPaddingMedium,
            right: kPaddingMedium,
            bottom: kPaddingMedium,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                PositiveAppBar(
                  foregroundColor: colors.black,
                ),
                const SizedBox(height: kPaddingSection),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    PositivePageIndicator(
                      colors: colors,
                      pagesNum: stepCount,
                      currentPage: currentStep.toDouble(),
                    ),
                    PositiveButton(
                      colors: colors,
                      isDisabled: false,
                      onTapped: controller.onSkipSelected,
                      label: localizations.shared_actions_skip,
                      style: PositiveButtonStyle.text,
                      layout: PositiveButtonLayout.textOnly,
                      size: PositiveButtonSize.small,
                    ),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      localizations.page_onboarding_connect_title,
                      style: typography.styleHero.copyWith(
                        color: colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
                Text(
                  localizations.page_onboarding_connect_body,
                  style: typography.styleBody.copyWith(
                    color: colors.black,
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
              ],
            ),
          ),
        )
      ],
    );
  }
}
