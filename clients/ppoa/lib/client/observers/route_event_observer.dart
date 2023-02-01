// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:ppoa/business/events/routing/route_changed_event.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';

class RouteEventObserver extends AutoRouterObserver with ServiceMixin {
  @override
  void didPush(Route route, Route? previousRoute) {
    final RouteChangedEvent routeChangedEvent = RouteChangedEvent(RouteChangeType.push, route);
    eventBus.fire(routeChangedEvent);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    final RouteChangedEvent routeChangedEvent = RouteChangedEvent(RouteChangeType.pop, route);
    eventBus.fire(routeChangedEvent);
  }
}
