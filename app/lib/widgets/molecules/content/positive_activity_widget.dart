// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/helpers/relationship_helpers.dart';
import 'package:app/providers/events/relationships_updated_event.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
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
  late final StreamSubscription<RelationshipsUpdatedEvent> relationshipsUpdatedSubscription;

  final Set<RelationshipState> relationshipStates = <RelationshipState>{};
  Relationship? publisherRelationship;
  Profile? publisher;

  @override
  void initState() {
    super.initState();
    setupListeners();
    resetActivityInformation();
  }

  @override
  void didUpdateWidget(PositiveActivityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // TODO(ryan): Improve this logic.
    if (oldWidget.activity != widget.activity) {
      disposeListeners();
      setupListeners();
      resetActivityInformation();
    }
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  void setupListeners() {
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    relationshipsUpdatedSubscription = relationshipController.positiveRelationshipsUpdatedController.stream.listen(onRelationshipsChanged);
  }

  void disposeListeners() {
    relationshipsUpdatedSubscription.cancel();
  }

  void onRelationshipsChanged(RelationshipsUpdatedEvent event) {
    // TODO(ryan): Add logic to check if the relationship is the same as the current one.
    resetActivityInformation();
  }

  void resetActivityInformation() {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
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

    // Load the relationship.
    // TODO(ryan): Assume default relationship when signed out.
    final List<String> members = <String>[userController.state.user!.uid, publisherKey];
    final String relationshipId = buildRelationshipIdentifier(members);
    final Relationship? relationship = cacheController.getFromCache(relationshipId);

    if (relationship == null) {
      logger.e('Relationship not found in cache for $relationshipId');
      return;
    }

    publisherRelationship = relationship;
    relationshipStates.addAll(relationship.relationshipStatesForEntity(userController.state.user!.uid));
    logger.i('Loaded relationship for $relationshipId');

    if (mounted) {
      setState(() {});
    }
  }

  bool get canDisplayActivity {
    if (publisher == null || publisherRelationship == null) {
      return false;
    }

    final bool isBlocked = relationshipStates.contains(RelationshipState.sourceBlocked) || relationshipStates.contains(RelationshipState.targetBlocked);
    final bool isSourceHidden = relationshipStates.contains(RelationshipState.sourceHidden);

    return !isBlocked && !isSourceHidden;
  }

  @override
  Widget build(BuildContext context) {
    if (!canDisplayActivity) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        ActivityPostHeadingWidget(
          activity: widget.activity,
          publisher: publisher,
        ),
        ListTile(
          title: Text(widget.activity.foreignKey),
          subtitle: Text(widget.activity.toString()),
        ),
      ],
    );
  }
}
