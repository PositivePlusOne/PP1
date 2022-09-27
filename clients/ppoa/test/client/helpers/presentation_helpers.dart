// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:async_redux/async_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'golden_helpers.dart';

Future<void> wrapReduxStoreAndPump(WidgetTester widgetTester, Widget widget, AppState state) async {
  final Store<AppState> fakeStore = Store<AppState>(initialState: state);
  final MaterialApp materialApp = MaterialApp(
    home: widget,
  );

  final StoreProvider<AppState> storeProvider = StoreProvider(store: fakeStore, child: materialApp);
  await widgetTester.pumpWidget(storeProvider);
}

Future<void> wrapReduxStoreAndPerformGoldenCheck(String name, WidgetTester widgetTester, Widget widget, AppState state) async {
  final Store<AppState> fakeStore = Store<AppState>(initialState: state);
  final MaterialApp materialApp = MaterialApp(
    debugShowCheckedModeBanner: false,
    home: widget,
  );

  final StoreProvider<AppState> storeProvider = StoreProvider(store: fakeStore, child: materialApp);
  final DeviceBuilder deviceBuilder = getGoldenDeviceBuilder(storeProvider);

  await widgetTester.pumpDeviceBuilder(deviceBuilder);
  await screenMatchesGolden(widgetTester, name);
}
