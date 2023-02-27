// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/providers/organisms/onboarding/onboarding_welcome_controller.dart';
import 'package:app/widgets/atoms/iconography/positive_stamp.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';

class OnboardingWelcomePage extends ConsumerWidget {
  const OnboardingWelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OnboardingWelcomeController controller = ref.read(onboardingWelcomeControllerProvider.notifier);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return PositiveScaffold(
      backgroundColor: colors.teal,
      trailingWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          isDisabled: false,
          onTapped: controller.onSignUpSelected,
          label: appLocalizations.shared_actions_sign_up,
          layout: PositiveButtonLayout.textOnly,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.white,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          isDisabled: true,
          onTapped: controller.onContinueSelected,
          label: appLocalizations.shared_actions_continue,
          layout: PositiveButtonLayout.textOnly,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.black,
        ),
      ],
      children: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: kPaddingMedium + mediaQuery.padding.top,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          appLocalizations.page_onboarding_welcome_heading_first_line,
                          style: typography.styleHero.copyWith(color: colors.black),
                        ),
                        Text(
                          appLocalizations.page_onboarding_welcome_heading_second_line,
                          style: typography.styleHero.copyWith(color: colors.black),
                        ),
                        Text(
                          appLocalizations.page_onboarding_welcome_heading_third_line,
                          style: typography.styleHero.copyWith(color: colors.black),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: kPaddingMedium, right: kPaddingMedium),
                        child: Transform.rotate(
                          angle: 15.0.degreeToRadian,
                          child: PositiveStamp.smile(
                            alignment: Alignment.topRight,
                            colors: colors,
                            fillColour: colors.pink,
                            size: 96.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  appLocalizations.page_onboarding_welcome_heading_fourth_line,
                  style: typography.styleHero.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingMedium),
                Text(
                  appLocalizations.page_onboarding_welcome_body,
                  style: typography.styleBody.copyWith(color: colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
