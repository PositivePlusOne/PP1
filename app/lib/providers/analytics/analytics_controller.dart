// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/providers/analytics/analytic_events.dart';
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

@Riverpod(keepAlive: true)
class AnalyticsController extends _$AnalyticsController {
  static const String kAnalyticsEnabledKey = 'positive_analytics_enabled';

  Map<String, dynamic> get defaultProperties {
    final Map<String, dynamic> properties = {};
    final UserController userController = ref.read(userControllerProvider.notifier);

    if (userController.currentUser != null) {
      properties['userId'] = userController.currentUser!.uid;
      properties['emailAddress'] = userController.currentUser!.email;
    }

    return properties;
  }

  @override
  AnalyticsControllerState build() {
    return AnalyticsControllerState.initialState();
  }

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

  Future<void> toggleAnalyticsCollection(bool isEnabled) async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseCrashlytics crashlytics = ref.read(firebaseCrashlyticsProvider);
    final Mixpanel mixpanel = await ref.read(mixpanelProvider.future);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);

    if (state.isCollectingData == isEnabled || !state.isCollectingData && !isEnabled) {
      logger.d('toggleAnalyticsCollection: Analytics already enabled or disabled, not toggling');
      return;
    }

    if (isEnabled) {
      logger.d('toggleAnalyticsCollection: Enabling crashlytics');
      await crashlytics.setCrashlyticsCollectionEnabled(true);
      mixpanel.optInTracking();
    }

    if (!isEnabled) {
      logger.d('toggleAnalyticsCollection: Disabling crashlytics');
      await crashlytics.setCrashlyticsCollectionEnabled(false);
      mixpanel.optOutTracking();
    }

    logger.d('toggleAnalyticsCollection: Saving analytics preferences');
    await sharedPreferences.setBool(kAnalyticsEnabledKey, isEnabled);

    logger.d('toggleAnalyticsCollection: Crashlytics enabled: $isEnabled');
    state = state.copyWith(isCollectingData: isEnabled, canPromptForAnalytics: false);
  }

  Future<void> trackEvent(
    AnalyticEvents event, {
    bool includeDefaultProperties = true,
    Map<String, dynamic> properties = const {},
  }) async {
    final Mixpanel mixpanel = await ref.read(mixpanelProvider.future);
    final Logger logger = ref.read(loggerProvider);

    if (!state.isCollectingData) {
      logger.d('Analytics is disabled, not tracking event: $event');
      return;
    }

    final Map<String, dynamic> publishedProperties = {
      ...properties,
    };

    if (includeDefaultProperties) {
      publishedProperties.addAll(defaultProperties);
    }

    logger.d('Tracking event: $event with properties: $publishedProperties');
    mixpanel.track(event.friendlyName, properties: publishedProperties);
  }

  Future<void> flushEvents() async {
    final Mixpanel mixpanel = await ref.read(mixpanelProvider.future);
    await mixpanel.flush();
  }
}
