// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

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
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/molecules/content/positive_post_layout_widget.dart';
import '../../../constants/design_constants.dart';
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
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final UserController userController = ref.read(userControllerProvider.notifier);

    publisherRelationship = null;
    publisher = null;
    relationshipStates.clear();

    if (mounted) {
      setState(() {});
    }

    logger.i('Loading activity information for ${widget.activity.foreignKey}');

    // Load the publisher.
    final String publisherKey = widget.activity.publisherInformation?.foreignKey ?? '';
    if (publisherKey.isEmpty) {
      logger.w('Publisher key is empty for ${widget.activity.foreignKey}');
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

    final String relationshipId = relationshipController.buildRelationshipIdentifier(members.toList());
    final Relationship? relationship = cacheController.getFromCache(relationshipId);
    if (relationship == null) {
      logger.e('Relationship not found in cache for $relationshipId');
      return;
    }

    publisherRelationship = relationship;
    relationshipStates.addAll(relationship.relationshipStatesForEntity(userController.currentUser!.uid));
    logger.i('Loaded relationship for $relationshipId');

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ActivityPostHeadingWidget(
          activity: widget.activity,
          publisher: publisher,
          onOptions: () {},
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
