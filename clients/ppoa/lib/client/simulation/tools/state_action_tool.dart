// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_preview/device_preview.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';
import '../../../business/services/actions.dart';

class StateActionTool extends StatelessWidget with ServiceMixin {
  const StateActionTool({
    super.key,
  });

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
            child: ListTile(
              title: Text(
                mutator.simulationTitle,
                style: themeData.textTheme.labelLarge,
              ),
              subtitle: Text(
                mutator.simulationDescription,
                style: themeData.textTheme.bodySmall,
              ),
              onTap: () => mutator.simulateAction(stateNotifier, <dynamic>['#ff2299']),
            ),
          ),
        ],
      ],
    );
  }
}
