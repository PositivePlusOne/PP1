enum OnboardingStyle {
  includeFeatures,
  pledgeOnly;

  int get stepCount => const <OnboardingStyle, int>{
        OnboardingStyle.includeFeatures: 5,
        OnboardingStyle.pledgeOnly: 2,
      }[this]!;
}
