import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ppoa/business/services/feature_service.dart';
import 'package:ppoa/client/splash/splash_lifecycle.dart';

import '../../business/mocks/services/mock_feature_service.dart';

void main() {
  test('Can bootstrap application from splash page successfully', testBootstrap);
}

Future<void> testBootstrap() async {
  final SplashLifecycle splashLifecycle = SplashLifecycle();
  final MockFeatureService featureService = MockFeatureService();

  await GetIt.instance.reset();
  GetIt.instance.registerSingleton<FeatureService>(featureService);

  when(() => featureService.preloadOnboardingFeatures()).thenAnswer((_) async {});
  await splashLifecycle.bootstrapApplication();

  verify(() => featureService.preloadOnboardingFeatures()).called(1);
}
