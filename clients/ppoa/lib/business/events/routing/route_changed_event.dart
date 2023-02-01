import 'package:flutter/material.dart';

enum RouteChangeType {
  push,
  pop,
}

class RouteChangedEvent {
  RouteChangedEvent(this.type, this.route);

  final RouteChangeType type;
  final Route route;
}
