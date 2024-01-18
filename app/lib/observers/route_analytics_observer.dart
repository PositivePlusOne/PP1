// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/gen/app_router.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';

class RouteAnalyticsObserver extends AutoRouteObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    unawaited(notifyPush(route, previousRoute));
    super.didPush(route, previousRoute);
  }

  Future<void> notifyPush(Route route, Route? previousRoute) async {
    final AnalyticsController analyticsController = await providerContainer.read(analyticsControllerProvider.notifier);

    if (route.settings.name?.isEmpty ?? true) {
      return;
    }

    await analyticsController.trackEvent(
      AnalyticEvents.screenDisplayed,
      includeDefaultProperties: false,
      properties: {
        'currentRoute': previousRoute?.settings.name ?? '',
        'targetRoute': route.settings.name,
      },
    );
  }
}
