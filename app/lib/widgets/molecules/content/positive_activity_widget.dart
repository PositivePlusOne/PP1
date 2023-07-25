// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/activities/activities_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/molecules/content/post_options_dialog.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:app/widgets/organisms/post/vms/create_stateful_post_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/molecules/content/positive_post_layout_widget.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../dialogs/positive_dialog.dart';
import 'activity_post_heading_widget.dart';

class PositiveActivityWidget extends StatefulHookConsumerWidget {
  const PositiveActivityWidget({
    required this.activity,
    this.index = -1,
    super.key,
  });

  final Activity activity;
  final int index;

  @override
  ConsumerState<PositiveActivityWidget> createState() => _PositiveActivityWidgetState();
}

class _PositiveActivityWidgetState extends ConsumerState<PositiveActivityWidget> {
  late final StreamSubscription<CacheKeyUpdatedEvent> _cacheKeyUpdatedSubscription;

  final Set<RelationshipState> relationshipStates = <RelationshipState>{};
  Relationship? publisherRelationship;
  Profile? publisher;

  @override
  void initState() {
    super.initState();
    setupListeners();
    loadActivityData();
  }

  @override
  void didUpdateWidget(PositiveActivityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activity.flMeta?.id != widget.activity.flMeta?.id) {
      disposeListeners();
      setupListeners();
      loadActivityData();
    }
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  void setupListeners() {
    final EventBus eventBus = ref.read(eventBusProvider);
    _cacheKeyUpdatedSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyUpdated);
  }

  void disposeListeners() {
    _cacheKeyUpdatedSubscription.cancel();
  }

  void onCacheKeyUpdated(CacheKeyUpdatedEvent event) {
    final String activityId = widget.activity.flMeta?.id ?? '';
    final String publisherId = widget.activity.publisherInformation?.foreignKey ?? '';

    if (event.key.contains(activityId) || event.key.contains(publisherId)) {
      loadActivityData();
    }
  }

  void loadActivityData() {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final UserController userController = ref.read(userControllerProvider.notifier);

    publisherRelationship = null;
    publisher = null;
    relationshipStates.clear();

    if (mounted) {
      setState(() {});
    }

    logger.i('Loading activity information for ${widget.activity.flMeta?.id}');

    // Load the publisher.
    final String publisherKey = widget.activity.publisherInformation?.foreignKey ?? '';
    if (publisherKey.isEmpty) {
      logger.w('Publisher key is empty for ${widget.activity.flMeta?.id}');
      return;
    }

    final Profile? publisherProfile = cacheController.getFromCache(publisherKey);
    if (publisherProfile == null) {
      logger.e('Publisher profile not found in cache for $publisherKey');
      return;
    }

    publisher = publisherProfile;
    logger.i('Loaded publisher profile for $publisherKey');

    if (userController.currentUser!.uid == publisherKey) {
      logger.i('Publisher is current user, skipping relationship load');
      return;
    }

    // Load the relationship.
    final Set<String> members = {userController.currentUser!.uid, publisherKey};
    if (members.length != 2) {
      logger.w('Invalid members for $publisherKey');
      return;
    }

    final Relationship? relationship = cacheController.getFromCache(members.asGUID);
    if (relationship == null) {
      logger.e('Relationship not found in cache for $relationship');
      return;
    }

    publisherRelationship = relationship;
    relationshipStates.addAll(relationship.relationshipStatesForEntity(userController.currentUser!.uid));
    logger.i('Loaded relationship for $relationship');

    if (mounted) {
      setState(() {});
    }
  }

  bool get canDisplayActivity {
    final UserController userController = ref.read(userControllerProvider.notifier);
    if (publisher == null || publisherRelationship == null) {
      return false;
    }

    // If the publisher is the current user, we can always display the activity.
    if (userController.currentUser!.uid == publisher!.flMeta!.id) {
      return true;
    }

    final bool isBlocked = relationshipStates.contains(RelationshipState.sourceBlocked) || relationshipStates.contains(RelationshipState.targetBlocked);
    final bool isSourceHidden = relationshipStates.contains(RelationshipState.sourceHidden);

    return !isBlocked && !isSourceHidden;
  }

  Future<void> onPostOptionsSelected(BuildContext context) async {
    await PositiveDialog.show(
      title: '',
      context: context,
      backgroundOpacity: kOpacityQuarter,
      barrierOpacity: kOpacityBarrier,
      barrierDismissible: true,
      child: PostOptionsDialog(
        onEditPostSelected: () => onPostEdited(context),
        onDeletePostSelected: () => onPostDeleted(context),
      ),
    );
  }

  Future<void> onPostDeleted(BuildContext context) async {
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = ref.read(appRouterProvider);

    await router.pop();
    await PositiveDialog.show(
      title: localisations.post_dialogue_delete_post,
      context: context,
      backgroundOpacity: kOpacityQuarter,
      barrierOpacity: kOpacityBarrier,
      barrierDismissible: true,
      child: PostDeleteConfirmDialog(
        onDeletePostConfirmed: () => onPostDeleteConfirmed(context),
      ),
    );
  }

  Future<void> onPostDeleteConfirmed(BuildContext context) async {
    final ActivitiesController activityController = ref.read(activitiesControllerProvider.notifier);
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    if (widget.activity.flMeta == null || widget.activity.flMeta!.id == null) return;

    try {
      await activityController.deleteActivity(widget.activity.flMeta!.id!);
    } catch (e) {
      logger.e("Error deleting activity: $e");

      final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
        title: localisations.post_dialogue_delete_post_fail,
        icon: UniconsLine.plus_circle,
        backgroundColour: colours.black,
      );

      if (router.navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
      }

      await router.pop();
      return;
    }

    final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
      title: localisations.post_dialogue_delete_post_success,
      icon: UniconsLine.file_times_alt,
      backgroundColour: colours.black,
    );

    if (router.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
    }

    await router.pop();
  }

  Future<void> onPostEdited(BuildContext context) async {
    final AppRouter router = ref.read(appRouterProvider);
    final ActivitiesController activityController = ref.read(activitiesControllerProvider.notifier);

    if (widget.activity.generalConfiguration == null) {
      return;
    }

    await router.pop();
    await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      useSafeArea: false,
      // traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
      builder: (_) => Material(
        child: CreateStatefulPostDialogue(
          activity: widget.activity,
          allowSharing: true,
          onFinish: (activityData) async => await activityController.updateActivity(
            activityData: ActivityData(
              activityID: widget.activity.flMeta!.id,
              content: activityData.content,
              // altText: activityData.altText,
              tags: activityData.tags,
              postType: activityData.postType,
              media: activityData.media,
              allowComments: activityData.allowComments,
              allowSharing: activityData.allowSharing,
              visibleTo: activityData.visibleTo,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ActivityPostHeadingWidget(
          activity: widget.activity,
          publisher: publisher,
          onOptions: onPostOptionsSelected,
        ),
        const SizedBox(height: kPaddingSmall),
        PositivePostLayoutWidget(
          postContent: widget.activity,
          publisher: publisher,
        ),
      ],
    );
  }
}
