import 'package:ppo_package_analytics/ppo_package_analytics.dart';

/// A wrapper for the [Mixpanel] class.
/// This is stored in the locator so that [Mixpanel] can be mocked for the [PPOAnalyticsService].
class MixpanelWrapper {
  Future<Mixpanel> initializeMixpanel(String apiKey, bool isTrackingEnabled) async {
    return await Mixpanel.init(apiKey, optOutTrackingDefault: !isTrackingEnabled);
  }
}
