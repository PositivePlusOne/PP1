// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import '../services/third_party.dart';

void useCacheHook({
  required List<String> keys,
  bool matchOnContains = false, // If true, will match on contains instead of equals; for example on a relationship update
}) {
  return use(CacheHook(
    cacheKeys: keys,
    matchOnContains: matchOnContains,
  ));
}

class CacheHook extends Hook<void> {
  const CacheHook({
    required this.cacheKeys,
    this.matchOnContains = false,
  });

  final List<String> cacheKeys;

  final bool matchOnContains;

  @override
  HookState<void, Hook<void>> createState() {
    return CacheHookState();
  }
}

class CacheHookState extends HookState<void, CacheHook> {
  late final StreamSubscription<CacheKeyUpdatedEvent> _cacheUpdatedSubscription;

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
    _cacheUpdatedSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheUpdated);
  }

  void removeListeners() {
    _cacheUpdatedSubscription.cancel();
  }

  @override
  void build(BuildContext context) {}

  void onCacheUpdated(CacheKeyUpdatedEvent event) {
    final bool match = hook.matchOnContains ? hook.cacheKeys.any((key) => event.key.contains(key)) : hook.cacheKeys.any((key) => event.key == key);
    if (match) {
      setState(() {});
    }
  }
}
