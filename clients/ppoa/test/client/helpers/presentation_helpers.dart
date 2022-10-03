// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:async_redux/async_redux.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';

Future<void> wrapReduxStoreAndPump(WidgetTester widgetTester, Widget widget, AppState state) async {
  final Store<AppState> fakeStore = Store<AppState>(initialState: state);
  final MaterialApp materialApp = MaterialApp(
    home: widget,
  );

  final StoreProvider<AppState> storeProvider = StoreProvider(store: fakeStore, child: materialApp);
  await widgetTester.pumpWidget(storeProvider);
}
