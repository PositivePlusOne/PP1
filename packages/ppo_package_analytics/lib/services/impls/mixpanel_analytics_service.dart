import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:ppo_package_analytics/ppo_package_analytics.dart';

import '../mixins/analytics_storage_mixin.dart';

class MixpanelAnalyticsService extends InqvineServiceBase with AnalyticsStorageMixin implements PPOAnalyticsService {
  MixpanelAnalyticsService({
    required this.apiKey,
  });

  /// The API key for Mixpanel.
  /// This will be passed in from the environment in which the client is using, e.g develop, production.
  @override
  final String apiKey;

  /// Returns the current Mixpanel instance if available.
  /// Else an exception is thrown
  Mixpanel get mixpanel => inqvine.getFromLocator();

  /// Whether or not to enabled tracking in Mixpanel.
  /// This is ideal for development environments where we might want to opt out of data collection.
  @override
  bool get isTrackingEnabled => true;

  /// Checks the service locator to determine if Mixpanel is available
  bool get isMixpanelAvailable => inqvine.isRegisteredInLocator<Mixpanel>();

  @override
  Future<void> initializeService() async {
    await configureMixpanel();
    return super.initializeService();
  }

  /// Using the provided API key, sets up Mixpanel and stores in the service cocator.
  /// If a Mixpanel instance is already in the service locator, then an error is thrown.
  /// Uses the [MixpanelWrapper] to avoid concrete implementation of Mixpanel initiation.
  ///
  /// Called on [initializeService].
  Future<void> configureMixpanel() async {
    if (inqvine.isRegisteredInLocator<Mixpanel>()) {
      throw AnalyticsException.analyticsProviderAlreadyConfigured;
    }

    //! This is annoying but is required as the concrete implementation of mixpanel limits the ability to mock initialization.
    // TODO(mark): Document manual test required
    if (!inqvine.isRegisteredInLocator<MixpanelWrapper>()) {
      'Creating a new Mixpanel shim.'.logDebug();
      inqvine.registerInLocator<MixpanelWrapper>(MixpanelWrapper());
    }

    try {
      final MixpanelWrapper mixpanelWrapper = inqvine.getFromLocator();
      final Mixpanel mixpanelInstance = await mixpanelWrapper.initializeMixpanel(apiKey, isTrackingEnabled);
      'Registered Mixpanel successfully.'.logInfo();

      inqvine.registerInLocator<Mixpanel>(mixpanelInstance);
    } catch (ex) {
      'Failed to initialize Mixpanel with exception: $ex'.logError();
      'Analytics services may be limited as a result.'.logDebug();
    }
  }

  /// Tracks an event with an event name, and a list of properties.
  /// Note, with Mixpanel; you may need to flush the data for it to show up within 60 seconds.
  @override
  Future<void> track(String eventName, {Map<String, dynamic> properties = const <String, dynamic>{}}) async {
    if (!isMixpanelAvailable) {
      'Cannot track event without Mixpanel provider.'.logError();
      return;
    }

    /// Concatinate common properties with extras
    final Map<String, String> commonProperties = await getCommonProperties();
    final Map<String, dynamic> allProperties = <String, dynamic>{
      ...properties,
      ...commonProperties,
    };

    mixpanel.track(eventName, properties: allProperties);
  }

  /// Flushes all pending events to Mixpanel.
  /// Call this if you require events to be immediately available for a user.
  @override
  Future<void> flush() async {
    await mixpanel.flush();
    'Mixpanel data flushed and stored successfully.'.logDebug();
  }
}
