// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/content/event_location.dart';
import 'package:ppoa/business/state/content/recommended_content.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';
import '../../state/content/enumerations/content_type.dart';
import '../../state/content/event_time.dart';

class PreloadRecommendedContentAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationDescription => 'Preload recommended content';

  @override
  String get simulationTitle => 'Loads recommended content for the home page and the hub.';

  //* Uses mock data for now
  @override
  Future<void> action(AppStateNotifier notifier, List params) async {
    await super.action(notifier, params);

    final List<RecommendedContent> recommendedContent = <RecommendedContent>[
      const RecommendedContent(
        contentTitle: 'U=U equals you and me ;)',
        contentCreatorDisplayName: 'PositiveLad',
        contentCreatorDisplayImage: 'https://loremflickr.com/320/320/person',
        contentType: ContentType.event,
      ),
      const RecommendedContent(
        contentTitle: 'I\'m not dirty, you\'re just dumb',
        contentCreatorDisplayName: 'ZappaVlogger',
        contentCreatorDisplayImage: 'https://loremflickr.com/320/320/person',
        contentType: ContentType.event,
      ),
      RecommendedContent(
        contentTitle: 'Party in the park event',
        contentCreatorDisplayName: 'AkaThementor',
        contentCreatorDisplayImage: 'https://loremflickr.com/320/320/person',
        contentType: ContentType.event,
        eventTime: EventTime(
          startTime: DateTime(2022, 12, 10, 16, 30),
        ),
        eventLocation: const EventLocation(
          locationCity: 'Bristol',
        ),
      ),
    ];

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
