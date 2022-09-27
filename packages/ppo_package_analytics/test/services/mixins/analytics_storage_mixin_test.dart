import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ppo_package_analytics/mocks/mock_flutter_secure_storage.dart';
import 'package:ppo_package_analytics/ppo_package_analytics.dart';

void main() => group('Analytics Mixin implementation unit tests', () {
      test('Clears only prefixed secure storage properties', testClearProperties);
      test('Can delete common analytics property', testDeleteProperty);
      test('Can write common analytics property', testSetProperty);
    });

Future<void> testSetProperty() async {
  // Arrange
  final MixpanelAnalyticsService mixpanelAnalyticsService = MixpanelAnalyticsService(apiKey: '');
  final MockFlutterSecureStorage flutterSecureStorage = MockFlutterSecureStorage();

  // Act
  await inqvine.resetLocator();
  inqvine.registerInLocator<FlutterSecureStorage>(flutterSecureStorage);

  await mixpanelAnalyticsService.setCommonProperty('username', 'name');

  // Assert
  verify(() => flutterSecureStorage.write(key: 'ppos_common_property_username', value: 'name')).called(1);
}

Future<void> testDeleteProperty() async {
  // Arrange
  final MixpanelAnalyticsService mixpanelAnalyticsService = MixpanelAnalyticsService(apiKey: '');
  final MockFlutterSecureStorage flutterSecureStorage = MockFlutterSecureStorage();

  // Act
  await inqvine.resetLocator();
  inqvine.registerInLocator<FlutterSecureStorage>(flutterSecureStorage);

  await mixpanelAnalyticsService.removeCommonProperty('username');

  // Assert
  verify(() => flutterSecureStorage.delete(key: 'ppos_common_property_username')).called(1);
}

Future<void> testClearProperties() async {
  // Arrange
  final MixpanelAnalyticsService mixpanelAnalyticsService = MixpanelAnalyticsService(apiKey: '');
  final MockFlutterSecureStorage flutterSecureStorage = MockFlutterSecureStorage();

  // Act
  await inqvine.resetLocator();
  inqvine.registerInLocator<FlutterSecureStorage>(flutterSecureStorage);

  flutterSecureStorage.withMockProperties(<String, String>{
    'ppos_common_property_username': 'username',
    'email': 'email',
  });

  await mixpanelAnalyticsService.clearCommonProperties();

  // Assert
  verify(() => flutterSecureStorage.delete(key: 'ppos_common_property_username')).called(1);
  verifyNever(() => flutterSecureStorage.delete(key: 'email'));
}
