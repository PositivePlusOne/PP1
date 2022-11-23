import 'dart:io';

import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';

import '../../../resources/resources.dart';
import '../../models/features/onboarding_feature.dart';
import '../../regex/common.dart';

class PreloadOnboardingFeaturesAction extends BaseMutator with ServiceMixin {
  final List<String> onboardingFeaturePaths = <String>[
    MarkdownFeatures.oneEn,
    MarkdownFeatures.twoEn,
    MarkdownFeatures.threeEn,
  ];

  @override
  String get simulationTitle => 'Preload onboarding features';

  @override
  String get simulationDescription => 'Loads a set of features to display to the user when first loading the application.';

  @override
  Future<void> action(AppStateNotifier notifier, List params) async {
    log.finer('Attempting to preload onboarding features');
    final List<OnboardingFeature> features = <OnboardingFeature>[];

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

        features.add(onboardingFeature);
        log.fine('Added $absolutePath to onboarding features');
      } catch (ex) {
        log.severe('Failed to load $absolutePath as onboarding features');
      }
    }

    notifier.state = notifier.state.copyWith(
      environment: notifier.state.environment.copyWith(
        onboardingFeatures: features,
      ),
    );

    await super.action(notifier, params);
  }

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) async {
    throw UnimplementedError();
  }

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.none;
}
