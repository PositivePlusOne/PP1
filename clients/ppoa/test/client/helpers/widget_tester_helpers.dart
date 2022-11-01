// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import '../../business/helpers/app_state_helpers.dart';

Future<void> pumpWidgetWithProviderScopeAndServices(Widget widget, AppState state, WidgetTester tester) async {
  final Widget actualWidget = ProviderScope(
    child: MaterialApp(
      home: widget,
    ),
  );

  await setTestServiceState(state);
  await tester.pumpWidget(actualWidget);
}
