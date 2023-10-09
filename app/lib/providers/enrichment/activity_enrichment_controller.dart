// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/extensions/future_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/enrichment_api_service.dart';
import 'package:app/services/third_party.dart';

part 'activity_enrichment_controller.freezed.dart';
part 'activity_enrichment_controller.g.dart';

@freezed
class ActivityEnrichmentControllerState with _$ActivityEnrichmentControllerState {
  const factory ActivityEnrichmentControllerState({
    required String? currentProfileId,
    @Default({}) Map<String, List<String>> activityEnrichmentTags,
  }) = _ActivityEnrichmentControllerState;

  factory ActivityEnrichmentControllerState.initialState(String profileId) => ActivityEnrichmentControllerState(currentProfileId: profileId);
}

@freezed
class ActivityEnrichmentTagAction with _$ActivityEnrichmentTagAction {
  const factory ActivityEnrichmentTagAction.openPost() = _ActivityEnrichmentTagActionOpenPost;
  const factory ActivityEnrichmentTagAction.viewPostExtended() = _ActivityEnrichmentTagActionViewPostExtended;
  const factory ActivityEnrichmentTagAction.commentPost() = _ActivityEnrichmentTagActionCommentPost;
  const factory ActivityEnrichmentTagAction.likePost() = _ActivityEnrichmentTagActionLikePost;
  const factory ActivityEnrichmentTagAction.bookmarkPost() = _ActivityEnrichmentTagActionBookmarkPost;
  const factory ActivityEnrichmentTagAction.sharePost() = _ActivityEnrichmentTagActionSharePost;
  const factory ActivityEnrichmentTagAction.followPublisher() = _ActivityEnrichmentTagActionFollowPublisher;
  const factory ActivityEnrichmentTagAction.connectPublisher() = _ActivityEnrichmentTagActionConnectPublisher;

  static String toJson(ActivityEnrichmentTagAction type) {
    return type.when(
      openPost: () => 'openPost',
      viewPostExtended: () => 'viewPostExtended',
      commentPost: () => 'commentPost',
      likePost: () => 'likePost',
      bookmarkPost: () => 'bookmarkPost',
      sharePost: () => 'sharePost',
      followPublisher: () => 'followPublisher',
      connectPublisher: () => 'connectPublisher',
    );
  }

  factory ActivityEnrichmentTagAction.fromJson(String value) {
    switch (value) {
      case 'openPost':
        return const ActivityEnrichmentTagAction.openPost();
      case 'viewPostExtended':
        return const ActivityEnrichmentTagAction.viewPostExtended();
      case 'commentPost':
        return const ActivityEnrichmentTagAction.commentPost();
      case 'likePost':
        return const ActivityEnrichmentTagAction.likePost();
      case 'bookmarkPost':
        return const ActivityEnrichmentTagAction.bookmarkPost();
      case 'sharePost':
        return const ActivityEnrichmentTagAction.sharePost();
      case 'followPublisher':
        return const ActivityEnrichmentTagAction.followPublisher();
      case 'connectPublisher':
        return const ActivityEnrichmentTagAction.connectPublisher();
      default:
        throw Exception('Unknown ActivityEnrichmentTagAction: $value');
    }
  }
}

@Riverpod(keepAlive: true)
class ActivityEnrichmentController extends _$ActivityEnrichmentController {
  @override
  ActivityEnrichmentControllerState build(String profileId) {
    return ActivityEnrichmentControllerState.initialState(profileId);
  }

  void registerActivityAction(ActivityEnrichmentTagAction action, Activity activity) {
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final List<String> profileTags = profileController.currentProfile?.tags.toList() ?? [];

    for (final String tag in activity.enrichmentConfiguration?.tags ?? []) {
      if (!profileTags.contains(tag)) {
        continue;
      }

      final currentTags = state.activityEnrichmentTags[tag] ?? [];
      currentTags.add(ActivityEnrichmentTagAction.toJson(action));
      state = state.copyWith(activityEnrichmentTags: {
        ...state.activityEnrichmentTags,
        tag: currentTags,
      });
    }

    _processEvents();
  }

  // Checks the current user and gets any tags which match our extent and attempts to register them as feeds
  Future<void> _processEvents() => runWithMutex(() async {
        final Logger logger = providerContainer.read(loggerProvider);
        final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
        final List<String> newTags = [];

        for (final String tag in state.activityEnrichmentTags.keys) {
          final List<ActivityEnrichmentTagAction> actions = state.activityEnrichmentTags[tag]?.map((e) => ActivityEnrichmentTagAction.fromJson(e)).toList() ?? [];
          if (actions.length <= 5) {
            continue;
          } else {
            newTags.add(tag);
          }
        }

        if (newTags.isEmpty) {
          logger.d('No new tags to process');
          return;
        }

        final List<String> profileTags = profileController.currentProfile?.tags.toList() ?? [];
        newTags.removeWhere((element) => profileTags.contains(element));

        if (newTags.isEmpty) {
          logger.d('No new tags to process');
          return;
        }

        // Add the tags to the database
        logger.t('Attempting to register interest in tags: $newTags');

        final EnrichmentApiService enrichmentApiService = await providerContainer.read(enrichmentApiServiceProvider.future);
        await enrichmentApiService.followTag(tags: newTags);

        // Reset the tags we have processed
        state = state.copyWith(activityEnrichmentTags: {
          for (final String tag in state.activityEnrichmentTags.keys)
            if (!newTags.contains(tag)) tag: state.activityEnrichmentTags[tag] ?? [],
        });
      });
}
