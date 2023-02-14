// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/typography/positive_bulleted_text.dart';
import 'package:app/widgets/organisms/onboarding/enumerations/onboarding_style.dart';
import '../../../constants/design_constants.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/organisms/onboarding/onboarding_your_pledge_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_layout.dart';
import '../../atoms/buttons/enumerations/positive_button_size.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/buttons/positive_checkbox.dart';
import '../../atoms/indicators/positive_page_indicator.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';

class OnboardingYourPledgePage extends ConsumerWidget {
  const OnboardingYourPledgePage({
    this.style = OnboardingStyle.includeFeatures,
    super.key,
  });

  final OnboardingStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OnboardingYourPledgeController controller = ref.read(onboardingYourPledgeControllerProvider.notifier);
    final OnboardingYourPledgeControllerState state = ref.watch(onboardingYourPledgeControllerProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final int stepCount = style.stepCount;
    final int currentStep = style == OnboardingStyle.pledgeOnly ? 1 : 4;
    final bool canDisplayBackButton = style == OnboardingStyle.pledgeOnly;

    final MarkdownStyleSheet markdownStyleSheet = getMarkdownStyleSheet(colors.white, colors, typography);

    return PositiveScaffold(
      backgroundColor: colors.white,
      trailingWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          isDisabled: !state.hasAcceptedPledge,
          onTapped: () => controller.onContinueSelected(style),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if (canDisplayBackButton) ...<Widget>[
                      PositiveButton(
                        colors: colors,
                        isDisabled: false,
                        onTapped: controller.onBackSelected,
                        label: localizations.shared_actions_back,
                        style: PositiveButtonStyle.text,
                        layout: PositiveButtonLayout.textOnly,
                        size: PositiveButtonSize.small,
                      ),
                      const SizedBox(width: kPaddingMedium),
                    ],
                    PositivePageIndicator(
                      colors: colors,
                      pagesNum: stepCount,
                      currentPage: currentStep.toDouble(),
                    ),
                    //! Hack to make sure the height is the same across Onboarding views
                    Opacity(
                      opacity: 0.0,
                      child: PositiveButton(
                        colors: colors,
                        isDisabled: true,
                        onTapped: () async {},
                        label: '0',
                        style: PositiveButtonStyle.text,
                        layout: PositiveButtonLayout.textOnly,
                        size: PositiveButtonSize.small,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kPaddingMedium),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      localizations.page_onboarding_your_pledge_title,
                      style: typography.styleHero.copyWith(
                        color: colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
                Text(
                  localizations.page_onboarding_your_pledge_body,
                  style: typography.styleBody.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingMedium),
                PositiveBulletedText(
                  text: Text(
                    localizations.page_onboarding_your_pledge_bullet_one,
                    style: typography.styleBody.copyWith(color: colors.black),
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
                PositiveBulletedText(
                  text: Text(
                    localizations.page_onboarding_your_pledge_bullet_two,
                    style: typography.styleBody.copyWith(color: colors.black),
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
                PositiveBulletedText(
                  text: Text(
                    localizations.page_onboarding_your_pledge_bullet_three,
                    style: typography.styleBody.copyWith(color: colors.black),
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
                PositiveBulletedText(
                  text: Text(
                    localizations.page_onboarding_your_pledge_bullet_four,
                    style: typography.styleBody.copyWith(color: colors.black),
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
                Markdown(
                  data: localizations.page_onboarding_your_pledge_action_terms,
                  padding: EdgeInsets.zero,
                  styleSheet: markdownStyleSheet,
                  shrinkWrap: true,
                  onTapLink: controller.onLinkTapped,
                ),
                const SizedBox(height: kPaddingMedium),
                PositiveCheckbox(
                  colors: colors,
                  onTapped: controller.onToggleCheckbox,
                  label: localizations.page_onboarding_your_pledge_action_accept,
                  isChecked: state.hasAcceptedPledge,
                  isDisabled: false,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
