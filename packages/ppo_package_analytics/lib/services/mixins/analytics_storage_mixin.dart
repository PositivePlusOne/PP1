import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

mixin AnalyticsStorageMixin {
  final String kCommonPropertiesPrefix = 'ppos_common_property_';

  FlutterSecureStorage getSecureStorage() {
    if (inqvine.isRegisteredInLocator<FlutterSecureStorage>()) {
      return inqvine.getFromLocator();
    }

    return const FlutterSecureStorage();
  }

  //* Directly shims FlutterSecureStorage therefore tests are not required
  Future<void> setCommonProperty(String name, String value) async {
    final FlutterSecureStorage flutterSecureStorage = getSecureStorage();
    await flutterSecureStorage.write(key: '$kCommonPropertiesPrefix$name', value: value);
  }

  //* Directly shims FlutterSecureStorage therefore tests are not required
  Future<void> removeCommonProperty(String name) async {
    final FlutterSecureStorage flutterSecureStorage = getSecureStorage();
    await flutterSecureStorage.delete(key: '$kCommonPropertiesPrefix$name');
  }

  Future<void> clearCommonProperties() async {
    final FlutterSecureStorage flutterSecureStorage = getSecureStorage();
    final Map<String, String> properties = await flutterSecureStorage.readAll();
    for (final String property in properties.keys) {
      if (!property.startsWith(kCommonPropertiesPrefix)) {
        continue;
      }

      await flutterSecureStorage.delete(key: property);
    }
  }

  Future<Map<String, String>> getCommonProperties() async {
    final FlutterSecureStorage flutterSecureStorage = getSecureStorage();
    final Map<String, String> properties = await flutterSecureStorage.readAll();
    properties.removeWhere((key, value) => !key.startsWith(kCommonPropertiesPrefix));
    return properties;
  }
}
