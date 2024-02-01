//* The duration in which objects are cached in the app, a job then cleans these up
const Duration kCacheTTLShort = Duration(minutes: 5);
const Duration kCacheTTL = Duration(hours: 1);
const Duration kCacheCleanupFrequency = Duration(minutes: 4);
const Duration kCacheCleanupPersist = Duration(minutes: 1);

// CRON durations for refreshing data
const Duration kRefreshLocationDataFrequency = Duration(minutes: 5);
const String kRefreshLocationCRON = '*/5 * * * *';
