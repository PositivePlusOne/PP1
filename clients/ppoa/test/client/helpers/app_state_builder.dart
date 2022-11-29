import 'package:ppoa/business/models/features/onboarding_feature.dart';
import 'package:ppoa/business/models/features/onboarding_step.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';

class AppStateBuilder {
  AppStateBuilder._privateConstructor(this.appState);

  AppState appState;

  static AppStateBuilder create({EnvironmentType environmentType = EnvironmentType.test}) {
    final AppState appState = AppState.initialState(environmentType: environmentType);
    return AppStateBuilder._privateConstructor(appState);
  }

  AppStateBuilder withMockOnboardingStepsAndFeatures() {
    appState = appState.copyWith(
      environment: appState.environment.copyWith(
        onboardingSteps: <OnboardingStep>[
          const OnboardingStep(type: OnboardingStepType.welcome, markdown: ''),
          const OnboardingStep(type: OnboardingStepType.feature, markdown: ''),
          const OnboardingStep(type: OnboardingStepType.yourPledge, markdown: ''),
          const OnboardingStep(type: OnboardingStepType.ourPledge, markdown: ''),
        ],
        onboardingFeatures: <OnboardingFeature>[
          const OnboardingFeature(key: 'mock', locale: 'en', localizedMarkdown: ''),
        ],
      ),
    );

    return this;
  }
}
