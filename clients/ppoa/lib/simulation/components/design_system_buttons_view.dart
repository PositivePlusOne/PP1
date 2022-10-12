import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/interfaces/brand_design_system.dart';
import 'package:ppoa/business/state/design_system/models/design_system_button_simulation_state.dart';

class DesignSystemButtonsView extends HookConsumerWidget with ServiceMixin {
  const DesignSystemButtonsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BrandDesignSystem designSystem = ref.watch(stateProvider.select((value) => value.designSystemSimulation.brand));
    final DesignSystemButtonsSimulationState buttonsState = ref.watch(stateProvider.select((value) => value.designSystemSimulation.buttons));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons'),
      ),
    );
  }
}
