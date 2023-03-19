enum OnboardingStyle {
  registration,
  home;

  int get stepCount => const <OnboardingStyle, int>{
        OnboardingStyle.home: 5,
        OnboardingStyle.registration: 2,
      }[this]!;
}
