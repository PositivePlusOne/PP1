// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/client/app.dart';
import 'business/services/service_initialization.dart';

//* Entrypoint for the development environment
Future<void> main() async {
  await prepareState(EnvironmentType.develop);
  runApp(const App());
}
