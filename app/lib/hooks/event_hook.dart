// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Project imports:
import 'package:app/main.dart';
import '../services/third_party.dart';

void useEventHook<T>({
  required void Function(dynamic event) onEvent,
}) {
  return use(EventHook<T>(
    onEvent: onEvent,
  ));
}

class EventHook<T> extends Hook<void> {
  const EventHook({
    required this.onEvent,
  });

  final void Function(dynamic event) onEvent;

  @override
  HookState<void, Hook<void>> createState() {
    return EventHookState<T>();
  }
}

class EventHookState<T> extends HookState<void, EventHook> {
  late final StreamSubscription<T> _eventSubscriptionSubscription;

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
    _eventSubscriptionSubscription = eventBus.on<T>().listen(onEventUpdated);
  }

  void removeListeners() {
    _eventSubscriptionSubscription.cancel();
  }

  @override
  void build(BuildContext context) {}

  void onEventUpdated(T event) {
    hook.onEvent(event);
  }
}
