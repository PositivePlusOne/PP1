// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:device_preview/device_preview.dart';

// Project imports:
import 'package:ppoa/client/simulation/tools/page_selection_setup.dart';
import '../../../business/services/service_mixin.dart';
import '../../components/animations/ppo_expandable_widget.dart';

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

    //* Generate other routes
    for (final String group in kSimulationRoutes.keys) {
      final Map<dynamic, dynamic> groupData = kSimulationRoutes[group];
      if (!routeMap.containsKey(group)) {
        routeMap[group] = <String, Function()>{};
        routeExpansionMap[group] = false;
      }

      for (final dynamic route in groupData.keys) {
        if (route is! PageRouteInfo) {
          continue;
        }

        String name = route.toString();
        if (groupData[route].keys.contains('name')) {
          name = groupData[route]['name'];
        }

        routeMap[group]![name] = () => router.navigatorKey.currentContext!.router.replace(route);
      }
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
