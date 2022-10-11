// Flutter imports:
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:async_redux/async_redux.dart';
import 'package:ppoa/business/environment/enumerations/environment_type.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import '../routing/app_router.gr.dart';

class AppWidget extends StatelessWidget {
  AppWidget({
    required this.initialApplicationState,
    Key? key,
  }) : super(key: key);

  final Store<AppState> initialApplicationState;
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: initialApplicationState,
      child: _SimulatableApp(
        appRouter: _appRouter,
        isSimulation: initialApplicationState.state.environment.type == EnvironmentType.simulation,
      ),
    );
  }
}

//* A shim to attach the simulator if in simulation mode
class _SimulatableApp extends StatelessWidget {
  const _SimulatableApp({
    Key? key,
    required this.appRouter,
    required this.isSimulation,
  }) : super(key: key);

  final AppRouter appRouter;
  final bool isSimulation;

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: isSimulation,
      builder: (_) => _LauncherApp(appRouter: appRouter),
    );
  }
}

//* The actual entry point into the application
class _LauncherApp extends StatelessWidget {
  const _LauncherApp({
    Key? key,
    required this.appRouter,
  }) : super(key: key);

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      routeInformationParser: appRouter.defaultRouteParser(),
      routerDelegate: appRouter.delegate(),
    );
  }
}
