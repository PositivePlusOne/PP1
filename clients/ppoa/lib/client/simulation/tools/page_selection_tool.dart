// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:device_preview/device_preview.dart';

// Project imports:
import '../../../business/services/service_mixin.dart';
import '../../components/animations/ppo_expandable_widget.dart';
import '../../routing/app_router.dart';

class PageSelectionTool extends StatefulWidget {
  const PageSelectionTool({
    super.key,
  });

  @override
  State<PageSelectionTool> createState() => _PageSelectionToolState();
}

class _PageSelectionToolState extends State<PageSelectionTool> with ServiceMixin {
  final Map<String, Map<String, Function()>> routeMap = <String, Map<String, Function()>>{
    'Other': <String, Function()>{},
  };

  final Map<String, bool> routeExpansionMap = <String, bool>{
    'Other': false,
  };

  @override
  void initState() {
    setupRoutes();
    super.initState();
  }

  void setupRoutes() {
    //* Reset
    routeExpansionMap.clear();
    routeMap.clear();

    //* Add base route properties
    routeMap['Other'] = <String, Function()>{};
    routeExpansionMap['Other'] = false;

    //* Generate other routes
    final List<RouteConfig> routes = router.routes;
    for (final RouteConfig route in routes) {
      String group = 'Other';
      if (route.meta.containsKey($AppRouter.kGroupKey)) {
        group = route.meta[$AppRouter.kGroupKey];
        if (!routeMap.containsKey(group)) {
          routeMap[group] = <String, Function()>{};
          routeExpansionMap[group] = false;
        }
      }

      final String path = route.path;
      final String name = route.name;

      routeMap[group]![name] = () => router.navigatorKey.currentContext!.router.replaceNamed(path);
    }
  }

  void toggleGroupExpansion(String group) {
    if (!mounted || !routeExpansionMap.containsKey(group)) {
      return;
    }

    routeExpansionMap[group] ??= false;
    routeExpansionMap[group] = !routeExpansionMap[group]!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ToolPanelSection(
      title: 'Page Selection',
      children: <Widget>[
        for (final String group in routeMap.keys) ...<Widget>[
          PPOExpandableWidget(
            isExpanded: routeExpansionMap[group] ?? false,
            collapsedChild: ListTile(
              onTap: () => toggleGroupExpansion(group),
              title: Text(group),
            ),
            expandedChild: Column(
              children: <Widget>[
                ListTile(
                  onTap: () => toggleGroupExpansion(group),
                  title: Text(group),
                ),
                const Divider(),
                for (final String route in routeMap[group]!.keys) ...<Widget>[
                  ListTile(
                    title: Text(route),
                    onTap: routeMap[group]![route],
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
