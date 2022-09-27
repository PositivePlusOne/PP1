// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:golden_toolkit/golden_toolkit.dart';

DeviceBuilder getGoldenDeviceBuilder(Widget widget) {
  return DeviceBuilder()
    ..addScenario(name: 'Static render', widget: widget)
    ..overrideDevicesForAllScenarios(
      devices: <Device>[
        Device.iphone11,
        Device.phone,
      ],
    );
}
