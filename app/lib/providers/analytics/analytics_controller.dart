// Dart imports:
import 'dart:async';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:cron/cron.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/handlers/profile_user_property_configuration_handler.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/providers/system/exception_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../services/third_party.dart';

part 'analytics_controller.freezed.dart';
part 'analytics_controller.g.dart';

@freezed
class AnalyticsControllerState with _$AnalyticsControllerState {
  const factory AnalyticsControllerState({
    @Default(false) bool isCollectingData,
    @Default(false) bool canPromptForAnalytics,
  }) = _AnalyticsControllerState;

  factory AnalyticsControllerState.initialState() => const AnalyticsControllerState();
}

mixin AnalyticsControllerInterface {
  Future<void> setupListeners();
  Future<void> loadAnalyticsPreferences();
  Future<void> toggleAnalyticsCollection(bool attemptToEnable);
  Future<void> trackEvent(
    AnalyticEvents event, {
    bool includeDefaultProperties = true,
    Map<String, dynamic> properties = const {},
  });
  Future<void> flushEvents();
}

@Riverpod(keepAlive: true)
class AnalyticsController extends _$AnalyticsController with AnalyticsControllerInterface {
  static const String kAnalyticsEnabledKey = 'positive_analytics_enabled';

  StreamSubscription<User?>? _onUserChangedSubscription;
  ScheduledTask? updateProfilePropertiesTask;
  StreamSubscription<ProfileSwitchedEvent>? profileSwitchedSubscription;

  Map<String, dynamic> get defaultProperties {
    final Map<String, dynamic> properties = {};
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);

    if (userController.currentUser != null) {
      properties['userId'] = userController.currentUser!.uid;
      properties['emailAddress'] = userController.currentUser!.email;
      properties['currentRoute'] = appRouter.current.name;
    }

    return properties;
  }

  @override
  AnalyticsControllerState build() {
    return AnalyticsControllerState.initialState();
  }

  @override
  Future<void> setupListeners() async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);
    final Cron cron = ref.read(cronProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('setupListeners: Setting up analytics listeners');
    await _onUserChangedSubscription?.cancel();
    _onUserChangedSubscription = userController.userChangedController.stream.listen(onUserUpdated);

    profileSwitchedSubscription ??= eventBus.on<ProfileSwitchedEvent>().listen((ProfileSwitchedEvent event) async {
      logger.d('registerScheduledJobs: Profile switched, updating analytics properties');
      await updateUserMixpanelProperties(isCollectingData: state.isCollectingData);
    });

    // Register a job to occur every minute to update analytics properties
    updateProfilePropertiesTask ??= cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      logger.d('registerScheduledJobs: Updating analytics properties');
      await updateUserMixpanelProperties(isCollectingData: state.isCollectingData);
    });
  }

  Future<void> onUserUpdated(User? user) async {
    final Logger log = ref.read(loggerProvider);
    final Mixpanel mixpanel = await ref.read(mixpanelProvider.future);
    final AppsflyerSdk appsflyer = await ref.read(appsflyerSdkProvider.future);

    log.d('Resetting analytic providers for new user');
    mixpanel.reset();
    appsflyer.setCustomerUserId('');

    if (user == null) {
      log.d('[UserController] onUserUpdated() user is null');
      return;
    }

    log.d('Identifying new user to analytic providers');
    mixpanel.identify(user.uid);
    appsflyer.setCustomerUserId(user.uid);
  }

  @override
  Future<void> loadAnalyticsPreferences() async {
    final Logger logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final ExceptionController exceptionController = ref.read(exceptionControllerProvider.notifier);
    logger.d('loadAnalyticsPreferences: Loading analytics preferences');

    final bool? isAnalyticsEnabled = sharedPreferences.getBool(kAnalyticsEnabledKey);
    if (isAnalyticsEnabled != null) {
      await toggleAnalyticsCollection(isAnalyticsEnabled);
    }

    logger.d('loadAnalyticsPreferences: Analytics preferences loaded: $isAnalyticsEnabled');
    state = state.copyWith(
      isCollectingData: isAnalyticsEnabled ?? false,
      canPromptForAnalytics: isAnalyticsEnabled == null,
    );

    logger.d('loadAnalyticsPreferences: Analytics preferences loaded, binding error handlers');
    FlutterError.onError = exceptionController.onFlutterErrorOccured;
    PlatformDispatcher.instance.onError = exceptionController.onPlatformDispatcherErrorOccured;
  }

  @override
  Future<void> toggleAnalyticsCollection(bool attemptToEnable) async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseCrashlytics crashlytics = ref.read(firebaseCrashlyticsProvider);
    final Mixpanel mixpanel = await ref.read(mixpanelProvider.future);
    final AppsflyerSdk appsflyer = await ref.read(appsflyerSdkProvider.future);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);

    if (state.isCollectingData == attemptToEnable || !state.isCollectingData && !attemptToEnable) {
      logger.d('toggleAnalyticsCollection: Analytics already enabled or disabled, not toggling');
      return;
    }

    bool isEnabled = attemptToEnable;

    // On iOS we need to show the app tracking dialog
    if (attemptToEnable && UniversalPlatform.isIOS) {
      final PermissionStatus permissionStatus = await ref.read(appTrackingTransparencyPermissionsProvider.future);
      if (permissionStatus == PermissionStatus.denied) {
        logger.d('toggleAnalyticsCollection: App tracking permission denied, not toggling');
        isEnabled = false;
      }
    }

    if (isEnabled) {
      logger.d('toggleAnalyticsCollection: Enabling crashlytics');
      await crashlytics.setCrashlyticsCollectionEnabled(true);
      appsflyer.setDisableAdvertisingIdentifiers(false); // These are backwards which confuses the hell out of me
      mixpanel.optInTracking();
    }

    if (!isEnabled) {
      logger.d('toggleAnalyticsCollection: Disabling crashlytics');
      await crashlytics.setCrashlyticsCollectionEnabled(false);
      appsflyer.setDisableAdvertisingIdentifiers(true); // These are backwards which confuses the hell out of me
      mixpanel.optOutTracking();
    }

    logger.d('toggleAnalyticsCollection: Saving analytics preferences');
    await sharedPreferences.setBool(kAnalyticsEnabledKey, isEnabled);

    logger.d('toggleAnalyticsCollection: Crashlytics enabled: $isEnabled');
    state = state.copyWith(isCollectingData: isEnabled, canPromptForAnalytics: false);
  }

  @override
  Future<void> trackEvent(
    AnalyticEvents event, {
    bool includeDefaultProperties = true,
    Map<String, dynamic> properties = const {},
  }) async {
    final Logger logger = ref.read(loggerProvider);
    if (!state.isCollectingData) {
      logger.d('Analytics is disabled, not tracking event: $event');
      return;
    }

    final Mixpanel mixpanel = await ref.read(mixpanelProvider.future);
    final AppsflyerSdk appsflyer = await ref.read(appsflyerSdkProvider.future);
    final Map<String, dynamic> publishedProperties = {
      ...properties,
    };

    if (includeDefaultProperties) {
      publishedProperties.addAll(defaultProperties);
    }

    logger.d('Tracking event: $event with properties: $publishedProperties');
    await appsflyer.logEvent(event.friendlyName, publishedProperties);
    mixpanel.track(event.friendlyName, properties: publishedProperties);
  }

  @override
  Future<void> flushEvents() async {
    final Mixpanel mixpanel = await ref.read(mixpanelProvider.future);
    await mixpanel.flush();
  }
}
