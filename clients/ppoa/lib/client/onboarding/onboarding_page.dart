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
    this.displayPledgeOnly = false,
    super.key,
  });

  final int stepIndex;

  //* If the user taps sign in, then we skip onboarding and display the pledge.
  //* We then redirect the user to the sign in flow, instead of home.
  final bool displayPledgeOnly;

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

  List<OnboardingStep> get currentSteps {
    if (widget.displayPledgeOnly) {
      return stateNotifier.state.environment.onboardingSteps.where((element) => element.type == OnboardingStepType.ourPledge || element.type == OnboardingStepType.yourPledge).toList();
    }

    return stateNotifier.state.environment.onboardingSteps;
  }

  Future<void> onSkipSelected() async {
    if (!currentSteps.any((element) => element.type == OnboardingStepType.ourPledge || element.type == OnboardingStepType.yourPledge)) {
      log.severe('Cannot skip onboarding steps, missing pledge');
      return;
    }

    log.fine('Attempting to skip onboarding');
    final int newIndex = currentSteps.indexWhere((element) => element.type == OnboardingStepType.ourPledge || element.type == OnboardingStepType.yourPledge);
    await router.push(OnboardingRoute(stepIndex: newIndex));
  }

  Future<void> onContinueSelected() async {
    final int stepCount = stateNotifier.state.environment.onboardingSteps.length;
    final int attemptedNewIndex = widget.stepIndex + 1;

    if (attemptedNewIndex < stepCount) {
      await router.push(OnboardingRoute(stepIndex: attemptedNewIndex, displayPledgeOnly: widget.displayPledgeOnly));
    } else {
      //* Create extension to wrap silent timeout
      await router.push(const CreateAccountRoute());
    }
  }

  Future<void> onSignInSelected() async {
    await router.push(OnboardingRoute(stepIndex: 0, displayPledgeOnly: true));
  }

  Future<void> onBackSelected() async {
    await router.push(OnboardingRoute(stepIndex: 0, displayPledgeOnly: false));
  }

  @override
  Widget build(BuildContext context) {
    final DesignSystemColors colors = ref.watch(stateProvider.select((value) => value.designSystem.brand.colors));

    late Widget child;
    final int pageCount = currentSteps.length;
    final OnboardingStep step = currentSteps[widget.stepIndex];

    switch (step.type) {
      case OnboardingStepType.welcome:
        child = OnboardingWelcomeComponent(
          step: step,
          backgroundColor: colors.teal,
          index: widget.stepIndex,
          pageCount: pageCount,
          onSignInSelected: onSignInSelected,
          onContinueSelected: onContinueSelected,
          onSkipSelected: onSkipSelected,
        );
        break;

      case OnboardingStepType.feature:
        child = OnboardingFeatureComponent(
          step: step,
          backgroundColor: colors.white,
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
          onBackSelected: onBackSelected,
          onContinueSelected: onContinueSelected,
          hasAccepted: hasAccepted,
          displayBackButton: widget.displayPledgeOnly,
        );
        break;
      case OnboardingStepType.yourPledge:
        child = OnboardingYourPledgeComponent(
          step: step,
          index: widget.stepIndex,
          pageCount: pageCount,
          onCheckboxSelected: () async => hasAccepted = !hasAccepted,
          onContinueSelected: onContinueSelected,
          onBackSelected: onBackSelected,
          hasAccepted: hasAccepted,
          displayBackButton: widget.displayPledgeOnly,
        );
        break;
    }

    return child;
  }
}
