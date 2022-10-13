// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_preview/device_preview.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';

class StateActionTool extends StatelessWidget with ServiceMixin {
  const StateActionTool({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    router.current;
    return const ToolPanelSection(
      title: 'Actions',
      children: <Widget>[],
    );
  }
}
