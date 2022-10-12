// Flutter imports:
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/services/service_mixin.dart';

import 'simulation/tools/page_selection_tool.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    this.isSimulation = false,
  }) : super(key: key);

  final bool isSimulation;

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      builder: (_) => const _LauncherApp(),
      enabled: isSimulation,
      tools: <Widget>[
        ...DevicePreview.defaultTools,
        PageSelectionTool(),
      ],
    );
  }
}

//* The actual entry point into the application
class _LauncherApp extends StatelessWidget with ServiceMixin {
  const _LauncherApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        routeInformationParser: router.defaultRouteParser(),
        routerDelegate: router.delegate(),
      ),
    );
  }
}
