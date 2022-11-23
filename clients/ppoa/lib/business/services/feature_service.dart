import 'dart:io';

import 'package:ppoa/business/models/features/onboarding_feature.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/resources/resources.dart';

import '../regex/common.dart';

class FeatureService with ServiceMixin {
  final List<String> onboardingFeaturePaths = <String>[
    MarkdownFeatures.oneEn,
    MarkdownFeatures.twoEn,
    MarkdownFeatures.threeEn,
  ];

  final Map<String, List<OnboardingFeature>> onboardingFeatures = <String, List<OnboardingFeature>>{};

  /// Checks the assets path and loads features based on the files available
  Future<void> preloadOnboardingFeatures() async {
    log.finer('Attempting to preload onboarding features');

    for (final String absolutePath in onboardingFeaturePaths) {
      final String? filename = filePathRegex.firstMatch(absolutePath)?.group(0);
      if (filename == null) {
        continue;
      }

      try {
        final String key = filename.split('_')[0];
        final String locale = filename.split('_')[1];
        final File file = File(absolutePath);
        final String fileContents = await file.readAsString();

        final OnboardingFeature onboardingFeature = OnboardingFeature(
          key: key,
          locale: locale,
          localizedMarkdown: fileContents,
        );

        onboardingFeatures[key] ??= <OnboardingFeature>[];
        onboardingFeatures[key]!.add(onboardingFeature);
        log.fine('Added $absolutePath to onboarding features');
      } catch (ex) {
        log.severe('Failed to load $absolutePath as onboarding features');
      }
    }
  }
}
