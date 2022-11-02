// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import '../../business/helpers/app_state_helpers.dart';

Future<void> pumpWidgetWithProviderScopeAndServices(Widget widget, AppState? state, WidgetTester tester) async {
  final Widget actualWidget = ProviderScope(
    child: MaterialApp(
      home: widget,
    ),
  );

  final AppState actualAppState = state ??= AppState.initialState(environmentType: EnvironmentType.test);

  await setTestServiceState(actualAppState);
  await tester.pumpWidget(actualWidget);
}
