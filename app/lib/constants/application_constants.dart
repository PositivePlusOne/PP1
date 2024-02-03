// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

// Project imports:
import 'package:app/gen/app_router.dart';

// Routing
const PageRouteInfo kDefaultRoute = HomeRoute();

// Authentication
const int kVerificationCodeLength = 6;

// Pagination
const int kStandardFeedWindowSize = 50;

// Cache durations
const Duration kCacheTTLShort = Duration(minutes: 5);
const Duration kCacheTTL = Duration(hours: 1);
const Duration kCacheCleanupFrequency = Duration(minutes: 4);
const Duration kCacheCleanupPersist = Duration(minutes: 1);
const Duration kLocationUpdateFrequency = Duration(minutes: 5);

// CRON durations for refreshing data
const Duration kRefreshLocationDataFrequency = Duration(minutes: 5);
const String kRefreshLocationCRON = '*/5 * * * *';

// Image compression
const int kImageCompressMaxWidth = 1920;
const int kImageCompressMaxHeight = 1920;
const int kImageCompressMaxQuality = 80;
const int kImageCompressRotation = 0;
const bool kImageCompressKeepExif = true;
const CompressFormat kImageCompressFormat = CompressFormat.jpeg;

// Chat
const int kMaximumChatParticipants = 10;

// SharedPreferences keys
const String kKeyPrefix = 'positive';

const String kSplashOnboardedKey = '$kKeyPrefix-splash-onboarded';
const String kNotificationsAcceptedKey = '$kKeyPrefix-notifications-accepted';
const String kBiometricsAcceptedKey = '$kKeyPrefix-biometrics-accepted';
const String kPledgeAcceptedKey = '$kKeyPrefix-pledge-accepted';

const String kIsFirstInstallKey = '$kKeyPrefix-is-first-install';
