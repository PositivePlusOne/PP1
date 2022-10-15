// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:device_preview/device_preview.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/client/simulation/components/expandable_widget.dart';
import 'package:ppoa/client/simulation/components/simulation_ui_divider.dart';
import '../../routing/app_router.dart';

class PageSelectionTool extends StatelessWidget with ServiceMixin {
  const PageSelectionTool({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, Function()>> routeMap = <String, Map<String, Function()>>{
      'Other': <String, Function()>{},
    };

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

    return ToolPanelSection(
      title: 'Page Selection',
      children: <Widget>[
        for (final String group in routeMap.keys) ...<Widget>[
          ExpandableWidget(
              headerChild: ListTile(
                title: Text(group, textAlign: TextAlign.center),
              ),
              collapsedChild: const SimulationUIDivider(isActive: false),
              expandedChild: Column(
                children: [
                  const SimulationUIDivider(isActive: true),
                  for (final String route in routeMap[group]!.keys) ...<Widget>[
                    ListTile(
                      title: Text(route),
                      onTap: routeMap[group]![route],
                    ),
                  ],
                ],
              ))
        ],
      ],
    );
  }
}
