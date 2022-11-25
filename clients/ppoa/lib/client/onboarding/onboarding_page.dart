// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_colors.dart';
import 'package:ppoa/client/onboarding/components/onboarding_feature_component.dart';
import '../../business/models/features/onboarding_step.dart';
import 'components/onboarding_welcome_component.dart';

class OnboardingPage extends StatefulHookConsumerWidget {
  const OnboardingPage({
    required this.stepIndex,
    super.key,
  });

  final int stepIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => OnboardingPageState();
}

class OnboardingPageState extends ConsumerState<OnboardingPage> with ServiceMixin {
  @override
  Widget build(BuildContext context) {
    final List<OnboardingStep> steps = ref.watch(stateProvider.select((value) => value.environment.onboardingSteps));
    final DesignSystemColors colors = ref.watch(stateProvider.select((value) => value.designSystem.brand.colors));

    late Widget child;
    final int pageCount = steps.length;
    final OnboardingStep step = steps[widget.stepIndex];

    switch (step.type) {
      case OnboardingStepType.welcome:
        child = OnboardingWelcomeComponent(
          step: step,
          backgroundColor: colors.teal,
          index: widget.stepIndex,
          pageCount: pageCount,
        );
        break;

      case OnboardingStepType.feature:
        child = OnboardingFeatureComponent(
          step: step,
          backgroundColor: colors.purple,
          index: widget.stepIndex,
          pageCount: pageCount,
          markdown: step.markdown,
        );
        break;

      case OnboardingStepType.ourPledge:
        child = Container(color: Colors.blue);
        break;
      case OnboardingStepType.yourPledge:
        child = Container(color: Colors.blue);
        break;
    }

    return child;
  }
}
