// Dart imports:
import 'dart:async';

// Package imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:cron/cron.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/services/api.dart';
import 'package:app/services/third_party.dart';

class ProfileFetchProcessor {
  final Set<String> _profileIds = {};
  final Lock _lock = Lock();

  Schedule? _schedule;
  ScheduledTask? _scheduledTask;

  static const int _fetchWindow = 50;
  static const Duration _firstWindowDelay = Duration(seconds: 1);

  void appendProfileIds(List<String> profileIds) {
    _profileIds.addAll(profileIds);
  }

  void removeProfileIds(List<String> profileIds) {
    _profileIds.removeWhere((String profileId) => profileIds.contains(profileId));
  }

  Future<void> startScheduler() async {
    final Cron cron = providerContainer.read(cronProvider);
    final Logger logger = providerContainer.read(loggerProvider);

    logger.d('[ProfileFetchProcessor] Starting scheduler...');
    _schedule = Schedule.parse('*/5 * * * *');
    _scheduledTask = cron.schedule(_schedule!, () async {
      if (_lock.locked) {
        logger.d('[ProfileFetchProcessor] Scheduler is locked.');
        return;
      }

      await _lock.synchronized(() async {
        await _fetchNextWindow();
      });
    });

    logger.d('[ProfileFetchProcessor] Scheduler started.');

    // Wait a bit before fetching the first window
    Future<void>.delayed(_firstWindowDelay).then((value) async {
      await _lock.synchronized(() async {
        await _fetchNextWindow();
      });
    });
  }

  Future<void> stopListener() async {
    final Logger logger = providerContainer.read(loggerProvider);

    logger.d('[ProfileFetchProcessor] Stopping scheduler...');
    await _scheduledTask?.cancel();
  }

  Future<void> forceFetch() async {
    final Logger logger = providerContainer.read(loggerProvider);

    logger.d('[ProfileFetchProcessor] Force fetching...');
    await _lock.synchronized(() async {
      await _fetchNextWindow();
    });
  }

  Future<void> _fetchNextWindow() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileApiService profileApiService = await providerContainer.read(profileApiServiceProvider.future);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    logger.d('[ProfileFetchProcessor] Fetching next window...');

    if (_profileIds.isEmpty) {
      logger.d('[ProfileFetchProcessor] No profile ids to fetch.');
      return;
    }

    // Take 15 profile ids from the list
    final List<String> fetchingProfileIds = _profileIds.take(_fetchWindow).toList();

    try {
      // Fetch profiles
      logger.d('[ProfileFetchProcessor] Fetching profiles: $fetchingProfileIds');
      await profileApiService.getProfiles(members: fetchingProfileIds);
      _profileIds.removeWhere((String profileId) => fetchingProfileIds.contains(profileId));
    } catch (e) {
      logger.e('[ProfileFetchProcessor] Error fetching profiles: $e');
    }
  }
}
