import 'package:inqvine_core_main/inqvine_core_main.dart';

abstract class PPOAnalyticsService extends InqvineServiceBase {
  /// The API key for the analytics provider.
  /// This will be passed in from the environment in which the client is using, e.g develop, production.
  String get apiKey;

  /// Whether or not to enabled tracking in the analytics provider.
  /// This is ideal for development environments where we might want to opt out of data collection.
  bool get isTrackingEnabled => true;

  @override
  Future<void> initializeService();

  /// Tracks an event with an event name, and a list of properties.
  /// Note, depending on the analytic provider; you may need to flush the data for it to show up immediately.
  Future<void> track(String eventName, {Map<String, dynamic> properties = const <String, dynamic>{}});

  /// Flushes all pending events to the analytics provider.
  /// Call this if you require events to be immediately available for a user.
  Future<void> flush();

  /// Sets a common property for the service
  Future<void> setCommonProperty(String name, String value);

  /// Removes a common property for the service
  Future<void> removeCommonProperty(String name);

  /// Clears all commons properties for the service
  Future<void> clearCommonProperties();

  /// Returns all commons properties for the service
  Future<Map<String, String>> getCommonProperties();
}
