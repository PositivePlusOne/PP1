// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_preview/device_preview.dart';
import 'package:flutter_test/flutter_test.dart';

final List<DeviceInfo> commonTestDevices = <DeviceInfo>[
  Devices.ios.iPhone12,
  Devices.ios.iPhone12Mini,
  Devices.ios.iPhone12ProMax,
  Devices.ios.iPhone13,
  Devices.ios.iPhone13Mini,
  Devices.ios.iPhone13ProMax,
  Devices.ios.iPhoneSE,
  Devices.android.onePlus8Pro,
  Devices.android.samsungGalaxyA50,
  Devices.android.samsungGalaxyNote20,
  Devices.android.samsungGalaxyNote20Ultra,
  Devices.android.samsungGalaxyS20,
  Devices.android.sonyXperia1II,
];

Future<void> setTestDevice(DeviceInfo device, {Orientation orientation = Orientation.portrait}) async {
  final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();

  Size screenSize = device.screenSize;
  if (orientation == Orientation.landscape) {
    screenSize = Size(device.screenSize.height, device.screenSize.width);
  }

  binding.window.physicalSizeTestValue = screenSize;
  binding.window.devicePixelRatioTestValue = device.pixelRatio;
}
