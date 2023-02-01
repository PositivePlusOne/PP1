// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:device_preview/device_preview.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/constants/ppo_design_constants.dart';
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

  final Map<PageRouteInfo<dynamic>, List<BaseMutator>> routeBeforeActions = <PageRouteInfo<dynamic>, List<BaseMutator>>{};

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

      for (final String routeName in groupData.keys) {
        PageRouteInfo<dynamic>? pageRouteInfo;
        if (groupData[routeName].containsKey('route')) {
          pageRouteInfo = groupData[routeName]['route'];
        }

        if (pageRouteInfo != null && groupData[routeName].containsKey('before')) {
          final List<BaseMutator> actions = groupData[routeName]['before'];
          routeBeforeActions[pageRouteInfo] = actions;
        }

        if (pageRouteInfo == null) {
          continue;
        }

        routeMap[group]![routeName] = () => onRouteSelected(pageRouteInfo!);
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
    final ThemeData themeData = Theme.of(context);

    return ToolPanelSection(
      title: 'Page Selection',
      children: <Widget>[
        for (final String group in routeMap.keys) ...<Widget>[
          PPOExpandableWidget(
            isExpanded: routeExpansionMap[group] ?? false,
            collapsedChild: ListTile(
              onTap: () => toggleGroupExpansion(group),
              title: Text(group, style: themeData.textTheme.labelLarge),
            ),
            expandedChild: Column(
              children: <Widget>[
                ListTile(
                  onTap: () => toggleGroupExpansion(group),
                  title: Text(group, style: themeData.textTheme.labelLarge),
                ),
                const Divider(),
                for (final String route in routeMap[group]!.keys) ...<Widget>[
                  ListTile(
                    title: Text(route, style: themeData.textTheme.bodyMedium),
                    onTap: routeMap[group]![route],
                  ),
                ],
                const Divider(),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> onRouteSelected(PageRouteInfo pageRouteInfo) async {
    //* Reset state
    stateNotifier.state = AppState.initialState(environmentType: EnvironmentType.simulation);
    if (routeBeforeActions.containsKey(pageRouteInfo)) {
      for (final BaseMutator mutator in routeBeforeActions[pageRouteInfo]!) {
        log.v('Running action prior to navigation: ${mutator.runtimeType}');
        await mutator.simulateAction(stateNotifier, []);
      }
    }

    await router.push(pageRouteInfo);

    //! Hack to allow page animations on same routes
    await Future<void>.delayed(kAnimationDurationRegular).then((_) async {
      router.removeUntil((route) => false);
    });
  }
}
