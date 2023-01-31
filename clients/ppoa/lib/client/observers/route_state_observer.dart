// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import '../../business/actions/system/system_busy_toggle_action.dart';

class RouteStateObserver extends AutoRouterObserver with ServiceMixin {
  @override
  void didPush(Route route, Route? previousRoute) {
    resetErrorAndBusyState();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    resetErrorAndBusyState();
  }

  Future<void> resetErrorAndBusyState() async {
    await mutator.performAction<SystemBusyToggleAction>(params: [false]);
  }
}
