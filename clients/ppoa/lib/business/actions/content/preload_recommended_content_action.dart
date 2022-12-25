import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/content/recommended_content.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';

class PreloadRecommendedContentAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationDescription => 'Preload recommended content';

  @override
  String get simulationTitle => 'Loads recommended content for the home page and the hub.';

  //* Uses mock data for now
  @override
  Future<void> action(AppStateNotifier notifier, List params) async {
    await super.action(notifier, params);

    final List<RecommendedContent> recommendedContent = <RecommendedContent>[];

    stateNotifier.state = stateNotifier.state.copyWith(
      contentState: stateNotifier.state.contentState.copyWith(recommendedContent: recommendedContent),
    );
  }

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) async {
    await action(notifier, params);
  }

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.button;
}
