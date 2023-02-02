// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import '../routing/app_router.gr.dart';

extension RouterStringExtensions on String {
  String get toRoutePathFromName {
    if (!GetIt.instance.isRegistered<AppRouter>()) {
      throw Exception('No router found when parsing route');
    }

    final AppRouter appRouter = GetIt.instance.get();
    for (final RouteConfig route in appRouter.routes) {
      if (route.name == this) {
        return route.path;
      }
    }

    throw Exception('No route matching name: $this');
  }
}
