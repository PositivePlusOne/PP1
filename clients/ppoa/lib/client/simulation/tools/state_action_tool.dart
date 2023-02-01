// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';

// Package imports:
import 'package:device_preview/device_preview.dart';
import 'package:ppoa/business/events/routing/route_changed_event.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';
import '../../../business/services/actions.dart';

class StateActionTool extends StatefulWidget {
  const StateActionTool({super.key});

  @override
  State<StateActionTool> createState() => _StateActionToolState();
}

class _StateActionToolState extends State<StateActionTool> with ServiceMixin {
  late StreamSubscription<RouteChangedEvent> routeChangeSubscription;

  @override
  void initState() {
    routeChangeSubscription = eventBus.on<RouteChangedEvent>().listen(onRouteChange);
    super.initState();
  }

  @override
  void dispose() {
    routeChangeSubscription.cancel();
    super.dispose();
  }

  void onRouteChange(RouteChangedEvent event) {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final String routeName = router.currentPath;
    final Iterable<BaseMutator> filteredMutators = mutators.where((element) => element.simulatorTileType != SimulatorTileType.none && (element.restrictedRoutes.isEmpty || element.restrictedRoutes.contains(routeName)));

    final ThemeData themeData = Theme.of(context);

    return ToolPanelSection(
      title: 'Actions',
      children: <Widget>[
        for (final BaseMutator mutator in filteredMutators) ...<Widget>[
          Tooltip(
            message: mutator.simulationDescription,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: IgnorePointer(
              ignoring: mutator.disabledReason.isNotEmpty,
              child: ListTile(
                title: Opacity(
                  opacity: mutator.disabledReason.isEmpty ? 1.0 : 0.4,
                  child: Text(
                    mutator.simulationTitle,
                    style: themeData.textTheme.labelLarge,
                  ),
                ),
                subtitle: Text(
                  mutator.disabledReason.isEmpty ? mutator.simulationDescription : mutator.disabledReason,
                  style: themeData.textTheme.bodySmall!.copyWith(
                    color: mutator.disabledReason.isNotEmpty ? Colors.deepOrange : null,
                  ),
                ),
                onTap: () => mutator.simulateAction(stateNotifier, <dynamic>[]),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
