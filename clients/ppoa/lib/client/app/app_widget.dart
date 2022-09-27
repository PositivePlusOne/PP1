// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:async_redux/async_redux.dart';

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
      child: MaterialApp.router(
        routeInformationParser: _appRouter.defaultRouteParser(),
        routerDelegate: _appRouter.delegate(),
      ),
    );
  }
}
