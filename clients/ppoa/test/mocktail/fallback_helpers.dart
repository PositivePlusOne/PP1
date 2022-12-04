// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:mocktail/mocktail.dart';

void registerMockFallbackValues() {
  registerFallbackValue(FakePageRouteInfo());
}

class FakePageRouteInfo<T> extends Fake implements PageRouteInfo<dynamic> {}
