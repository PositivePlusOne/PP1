import 'dart:async';

import 'package:app/main.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class RouteAnalyticsObserver extends AutoRouteObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    unawaited(notifyPush(route));
    super.didPush(route, previousRoute);
  }

  Future<void> notifyPush(Route route) async {
    final AnalyticsController analyticsController = await providerContainer.read(analyticsControllerProvider.notifier);

    await analyticsController.trackEvent(
      AnalyticEvents.screenDisplayed,
      includeDefaultProperties: false,
      properties: {
        'routeName': route.settings.name,
      },
    );
  }
}
