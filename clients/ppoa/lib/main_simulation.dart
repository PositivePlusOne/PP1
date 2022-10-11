// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:async_redux/async_redux.dart';

// Project imports:
import 'package:ppoa/business/environment/enumerations/environment_type.dart';
import 'package:ppoa/business/environment/models/environment.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/client/app/app_widget.dart';

//* Entrypoint for the development environment
Future<void> main() async {
  final AppState initialState = AppState.initialState(
    environment: const Environment(type: EnvironmentType.simulation),
  );

  final Store<AppState> store = Store<AppState>(initialState: initialState);
  runApp(AppWidget(initialApplicationState: store));
}
