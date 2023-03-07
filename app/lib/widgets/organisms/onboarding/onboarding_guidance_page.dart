// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/organisms/onboarding/enumerations/onboarding_style.dart';
import 'package:app/widgets/organisms/onboarding/vms/onboarding_guidance_view_model.dart';
import '../../../constants/design_constants.dart';
import '../../../helpers/brand_helpers.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';

class OnboardingGuidancePage extends ConsumerWidget {
  const OnboardingGuidancePage({
    this.style = OnboardingStyle.includeFeatures,
    super.key,
  });

  final OnboardingStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OnboardingGuidanceViewModel viewModel = ref.read(onboardingGuidanceViewModelProvider.notifier);

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final int stepCount = style.stepCount;
    const int currentStep = 2;

    return PositiveScaffold(
      decorations: buildType3ScaffoldDecorations(colors),
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          isDisabled: false,
          onTapped: viewModel.onContinueSelected,
          label: localizations.shared_actions_continue,
          layout: PositiveButtonLayout.textOnly,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.black,
        ),
      ],
      headingWidgets: <Widget>[
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
                const SizedBox(height: kPaddingMassive),
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
                      onTapped: viewModel.onSkipSelected,
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
                      localizations.page_onboarding_guidance_title,
                      style: typography.styleHero.copyWith(
                        color: colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
                Text(
                  localizations.page_onboarding_guidance_body,
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
