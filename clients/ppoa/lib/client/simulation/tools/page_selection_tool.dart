import 'package:auto_route/auto_route.dart';
import 'package:device_preview/device_preview.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:ppoa/business/services/service_mixin.dart';

import '../../routing/app_router.dart';

class PageSelectionTool extends StatefulWidget {
  const PageSelectionTool({super.key});

  @override
  State<PageSelectionTool> createState() => _PageSelectionToolState();
}

class _PageSelectionToolState extends State<PageSelectionTool> with ServiceMixin {
  final Map<String, Map<String, Function()>> routeMap = <String, Map<String, Function()>>{
    'Other': <String, Function()>{},
  };

  @override
  void initState() {
    super.initState();
    rebuildRoutes();
  }

  void rebuildRoutes() {
    final List<RouteConfig> routes = router.routes;
    for (final RouteConfig route in routes) {
      String group = 'Other';
      if (route.meta.containsKey($AppRouter.kGroupKey)) {
        group = route.meta[$AppRouter.kGroupKey];
        if (!routeMap.containsKey(group)) {
          routeMap[group] = <String, Function()>{};
        }
      }

      final String path = route.path;
      final String name = route.name;

      routeMap[group]![name] = () => router.navigatorKey.currentContext!.router.replaceNamed(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPanelSection(
      title: 'Page Selection',
      children: <Widget>[
        for (final String group in routeMap.keys) ...<Widget>[
          for (final String route in routeMap[group]!.keys) ...<Widget>[
            ListTile(
              title: Text(group),
              subtitle: Text(route),
              onTap: routeMap[group]![route],
            ),
          ],
        ],
      ],
    );
  }
}
