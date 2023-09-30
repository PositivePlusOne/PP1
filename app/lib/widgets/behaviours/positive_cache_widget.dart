// Dart imports:
import 'dart:collection';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/hooks/cache_hook.dart';
import 'package:app/providers/system/cache_controller.dart';

class PositiveCacheWidget extends HookConsumerWidget {
  const PositiveCacheWidget({
    required this.cacheKeys,
    required this.onBuild,
    super.key,
  });

  final List<String> cacheKeys;
  final Widget Function(BuildContext context, HashMap<String, dynamic> cacheResults) onBuild;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useCacheHook(keys: cacheKeys);

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final HashMap<String, dynamic> results = HashMap();

    for (final String key in cacheKeys) {
      results.putIfAbsent(key, () => cacheController.get(key));
    }

    return onBuild(context, results);
  }
}
