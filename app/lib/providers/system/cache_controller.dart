// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../constants/cache_constants.dart';
import '../../dtos/database/user/user_profile.dart';
import '../../services/repositories.dart';
import '../../services/third_party.dart';

part 'cache_controller.freezed.dart';
part 'cache_controller.g.dart';

@freezed
class CacheControllerState with _$CacheControllerState {
  const factory CacheControllerState() = _CacheControllerState;

  factory CacheControllerState.initialState() => const CacheControllerState();
}

@Riverpod(keepAlive: true)
class CacheController extends _$CacheController {
  Timer? scheduledJobCacheClear;

  @override
  CacheControllerState build() {
    return CacheControllerState.initialState();
  }

  void setupTimers() {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Setting up cache timers');

    scheduledJobCacheClear = Timer.periodic(
      kCacheDuration,
      (Timer t) => clearCache(),
    );
  }

  Future<void> clearCache() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Clearing cache');

    final Box<UserProfile> userProfileRepository = await ref.read(userProfileRepositoryProvider.future);
    // TODO(ryan): Handle expiry
  }
}
