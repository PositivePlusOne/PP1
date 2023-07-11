// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/providers/events/connections/relationship_updated_event.dart';
import '../services/third_party.dart';

void useRelationshipHook() {
  return use(RelationshipHook());
}

class RelationshipHook extends Hook<void> {
  @override
  HookState<void, Hook<void>> createState() {
    return RelationshipHookState();
  }
}

class RelationshipHookState extends HookState<void, RelationshipHook> {
  late final StreamSubscription<RelationshipUpdatedEvent> _relationshipUpdatedSubscription;

  @override
  void initHook() {
    super.initHook();
    setupListeners();
  }

  @override
  void dispose() {
    removeListeners();
    super.dispose();
  }

  void setupListeners() {
    final EventBus eventBus = providerContainer.read(eventBusProvider);
    _relationshipUpdatedSubscription = eventBus.on<RelationshipUpdatedEvent>().listen(onRelationshipUpdated);
  }

  void removeListeners() {
    _relationshipUpdatedSubscription.cancel();
  }

  @override
  void build(BuildContext context) {}

  void onRelationshipUpdated(RelationshipUpdatedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    logger.d('[RelationshipHook] onRelationshipUpdated]');

    setState(() {});
  }
}
