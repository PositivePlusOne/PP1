import 'package:flutter_test/flutter_test.dart';
import 'package:ppoa/business/services/feature_service.dart';

void main() {
  test('Can preload onboarding features successfully', testPreloadOnboardingFeatures);
}

Future<void> testPreloadOnboardingFeatures() async {
  final FeatureService featureService = FeatureService();
  await featureService.preloadOnboardingFeatures();
  expect(featureService.onboardingFeatures, isNotEmpty);
}
