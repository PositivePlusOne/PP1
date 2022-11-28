// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_colors.dart';
import 'package:ppoa/client/onboarding/components/onboarding_feature_component.dart';
import 'package:ppoa/client/onboarding/components/onboarding_our_pledge_component.dart';
import '../../business/models/features/onboarding_step.dart';
import '../routing/app_router.gr.dart';
import 'components/onboarding_welcome_component.dart';
import 'components/onboarding_your_pledge_component.dart';

class OnboardingPage extends StatefulHookConsumerWidget {
  const OnboardingPage({
    required this.stepIndex,
    this.shouldSkipWelcome = false,
    super.key,
  });

  final int stepIndex;
  final bool shouldSkipWelcome;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => OnboardingPageState();
}

class OnboardingPageState extends ConsumerState<OnboardingPage> with ServiceMixin {
  bool _hasAccepted = false;
  bool get hasAccepted => _hasAccepted;
  set hasAccepted(bool val) {
    _hasAccepted = val;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onSkipSelected() async {
    log.fine('Attempting to skip onboarding');
    await router.push(OnboardingRoute(stepIndex: 0, shouldSkipWelcome: true));
  }

  Future<void> onContinueSelected() async {
    final int stepCount = stateNotifier.state.environment.onboardingSteps.length;
    final int attemptedNewIndex = widget.stepIndex + 1;

    if (attemptedNewIndex < stepCount) {
      await router.push(OnboardingRoute(stepIndex: attemptedNewIndex));
    } else {
      //* Create extension to wrap silent timeout
      await router.push(const CreateAccountRoute());
    }
  }

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
          onContinueSelected: onContinueSelected,
          onSkipSelected: onSkipSelected,
        );
        break;

      case OnboardingStepType.feature:
        child = OnboardingFeatureComponent(
          step: step,
          backgroundColor: colors.purple,
          index: widget.stepIndex,
          pageCount: pageCount,
          markdown: step.markdown,
          onContinueSelected: onContinueSelected,
          onSkipSelected: onSkipSelected,
        );
        break;

      case OnboardingStepType.ourPledge:
        child = OnboardingOurPledgeComponent(
          step: step,
          index: widget.stepIndex,
          pageCount: pageCount,
          onCheckboxSelected: () async => hasAccepted = !hasAccepted,
          onContinueSelected: onContinueSelected,
          hasAccepted: hasAccepted,
        );
        break;
      case OnboardingStepType.yourPledge:
        child = OnboardingYourPledgeComponent(
          step: step,
          index: widget.stepIndex,
          pageCount: pageCount,
          onCheckboxSelected: () async => hasAccepted = !hasAccepted,
          onContinueSelected: onContinueSelected,
          hasAccepted: hasAccepted,
        );
        break;
    }

    return child;
  }
}
