// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';

class PositiveCacheWidget extends HookConsumerWidget {
  const PositiveCacheWidget({
    required this.currentProfile,
    required this.cacheObjects,
    required this.onBuild,
    super.key,
  });

  final Profile? currentProfile;
  final List<dynamic> cacheObjects;
  final Widget Function(BuildContext context) onBuild;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> cacheKeys = buildExpectedCacheKeysFromObjects(currentProfile, cacheObjects).toList();
    useCacheHook(keys: cacheKeys);

    return onBuild(context);
  }
}
