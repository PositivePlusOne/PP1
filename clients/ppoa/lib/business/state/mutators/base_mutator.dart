// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import '../../../client/simulation/enumerations/simulator_tile_type.dart';

/// A base state mutator, designed to allow support for simulation.
/// To include action in simulator, add to [StateActionTool].
abstract class BaseMutator {
  //* Whether to set the state on action
  bool get persistStateOnAction => true;

  //* Supported on all routes if empty
  List<Type> get supportedSimulatorRoutes => <Type>[];

  //* Not rendered if type is none
  SimulatorTileType get simulatorTileType;

  //* The title displayed on the simulator if applicable
  String get simulationTitle;

  //* The description displayed on the simulator if applicable
  String get simulationDescription;

  //* Performs the action, with the expected simulation parameters
  Future<void> simulateAction(AppStateNotifier notifier, List<dynamic> params);

  //* Performs the action, with the expected parameters
  @mustCallSuper
  Future<void> action(AppStateNotifier notifier, List<dynamic> params) async {}

  //* The weight in which the mutator restores its state, for example set this lower if you want it to be restored first
  int get restorationWeighting => 255;

  //* A list of routes the action is valid in.
  //* This is used for filtering in the simulator
  List<String> get restrictedRoutes => <String>[];
}
