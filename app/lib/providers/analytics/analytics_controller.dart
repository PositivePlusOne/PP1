// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../services/third_party.dart';

part 'analytics_controller.freezed.dart';
part 'analytics_controller.g.dart';

@freezed
class AnalyticsControllerState with _$AnalyticsControllerState {
  const factory AnalyticsControllerState() = _AnalyticsControllerState;

  factory AnalyticsControllerState.initialState() => const AnalyticsControllerState();
}

@Riverpod(keepAlive: true)
class AnalyticsController extends _$AnalyticsController {
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

  Future<void> trackEvent(
    AnalyticEvents event, {
    bool includeDefaultProperties = true,
    Map<String, dynamic> properties = const {},
  }) async {
    final Mixpanel mixpanel = await ref.read(mixpanelProvider.future);
    final Logger logger = ref.read(loggerProvider);

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
