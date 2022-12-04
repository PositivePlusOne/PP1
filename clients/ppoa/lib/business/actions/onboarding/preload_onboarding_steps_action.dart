// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:ppoa/business/models/features/onboarding_step.dart';
import 'package:ppoa/business/models/ppo/page_decoration.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';

import '../../../resources/resources.dart';

class PreloadOnboardingStepsAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationTitle => 'Preload onboarding steps';

  @override
  String get simulationDescription => 'Loads a set of steps to display to the user when first loading the application.';

  @override
  Future<void> action(AppStateNotifier notifier, List<dynamic> params) async {
    log.finer('Attempting to preload onboarding steps');
    final List<OnboardingStep> steps = <OnboardingStep>[];

    if (router.navigatorKey.currentState == null) {
      log.severe('Failed to preload steps, cannot get context');
    }

    final BuildContext context = router.navigatorKey.currentState!.context;
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignSystemBrand brand = stateNotifier.state.designSystem.brand;

    //* Add welcome state
    steps.add(const OnboardingStep(type: OnboardingStepType.welcome));

    //* Add features state
    steps.addAll(<OnboardingStep>[
      OnboardingStep(
        type: OnboardingStepType.feature,
        title: localizations.onboarding_connections_title,
        body: localizations.onboarding_connections_body,
        decorations: <PageDecoration>[
          PageDecoration(
            asset: SvgImages.decorationStar,
            alignment: Alignment.bottomRight,
            color: brand.colors.purple,
            scale: 1.5,
            offsetX: 50.0,
            offsetY: 50.0,
            rotationDegrees: 0.0,
          ),
          PageDecoration(
            asset: SvgImages.decorationArrowRight,
            alignment: Alignment.topRight,
            color: brand.colors.yellow,
            scale: 1.2,
            offsetX: 50.0,
            offsetY: 50.0,
            rotationDegrees: -15.0,
          ),
          PageDecoration(
            asset: SvgImages.decorationRings,
            alignment: Alignment.bottomLeft,
            color: brand.colors.teal,
            scale: 1.5,
            offsetX: -50.0,
            offsetY: 25.0,
            rotationDegrees: -15.0,
          ),
          PageDecoration(
            asset: SvgImages.decorationEye,
            alignment: Alignment.topLeft,
            color: brand.colors.green,
            scale: 1.1,
            offsetX: -15.0,
            offsetY: -0.0,
            rotationDegrees: 15.0,
          ),
        ],
      ),
      OnboardingStep(
        type: OnboardingStepType.feature,
        title: localizations.onboarding_education_title,
        body: localizations.onboarding_education_body,
        decorations: <PageDecoration>[
          PageDecoration(
            asset: SvgImages.decorationGlobe,
            alignment: Alignment.bottomRight,
            color: brand.colors.green,
            scale: 1.6,
            offsetX: 25.0,
            offsetY: 25.0,
            rotationDegrees: -0.0,
          ),
          PageDecoration(
            asset: SvgImages.decorationStampStar,
            alignment: Alignment.bottomLeft,
            color: brand.colors.purple,
            scale: 1.2,
            offsetX: -35.0,
            offsetY: 50.0,
            rotationDegrees: -15.0,
          ),
          PageDecoration(
            asset: SvgImages.decorationEye,
            alignment: Alignment.topCenter,
            color: brand.colors.pink,
            scale: 0.95,
            offsetX: -15.0,
            offsetY: 35.0,
            rotationDegrees: -15.0,
          ),
        ],
      ),
      OnboardingStep(
        type: OnboardingStepType.feature,
        title: localizations.onboarding_guidance_title,
        body: localizations.onboarding_guidance_body,
        decorations: <PageDecoration>[
          PageDecoration(
            asset: SvgImages.decorationGlobe,
            alignment: Alignment.bottomRight,
            color: brand.colors.green,
            scale: 1.6,
            offsetX: 25.0,
            offsetY: 25.0,
            rotationDegrees: -0.0,
          ),
          PageDecoration(
            asset: SvgImages.decorationStampStar,
            alignment: Alignment.bottomLeft,
            color: brand.colors.purple,
            scale: 1.2,
            offsetX: -35.0,
            offsetY: 50.0,
            rotationDegrees: -15.0,
          ),
          PageDecoration(
            asset: SvgImages.decorationFace,
            alignment: Alignment.topCenter,
            color: brand.colors.pink,
            scale: 0.95,
            offsetX: -15.0,
            offsetY: 35.0,
            rotationDegrees: 15.0,
          ),
        ],
      ),
    ]);

    //* Add pledge state
    steps.add(const OnboardingStep(type: OnboardingStepType.ourPledge));
    steps.add(const OnboardingStep(type: OnboardingStepType.yourPledge));

    notifier.state = notifier.state.copyWith(
      environment: notifier.state.environment.copyWith(
        onboardingSteps: steps,
      ),
    );

    await super.action(notifier, params);
  }

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) async {
    await action(notifier, params);
  }

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.none;
}
