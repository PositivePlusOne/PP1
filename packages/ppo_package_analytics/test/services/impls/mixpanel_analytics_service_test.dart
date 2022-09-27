import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ppo_package_analytics/mocks/mock_flutter_secure_storage.dart';
import 'package:ppo_package_analytics/mocks/mock_mixpanel_wrapper.dart';
import 'package:ppo_package_analytics/ppo_package_analytics.dart';

void main() => group('Mixpanel implementation unit tests', () {
      test('Throws exception on configuring when already configured', testMultipleConfiguration);
      test('Can configure Mixpanel service', testServiceConfiguration);
      test('Cannot track event when Mixpanel is unavailable', testTrackBlockEvent);
      test('Can flush events to Mixpanel', testFlushEvents);
      test('Common properties are added to pushed Mixpanel events', testCommonPropertiesAddedToEvent);
    });

Future<void> testCommonPropertiesAddedToEvent() async {
  // Arrange
  final MixpanelAnalyticsService mixpanelAnalyticsService = MixpanelAnalyticsService(apiKey: '');
  final MockMixpanel mixpanel = MockMixpanel();
  final MockFlutterSecureStorage flutterSecureStorage = MockFlutterSecureStorage();

  // Act
  await inqvine.resetLocator();
  inqvine.registerInLocator<Mixpanel>(mixpanel);
  inqvine.registerInLocator<FlutterSecureStorage>(flutterSecureStorage);

  mixpanel.mockCaptureTrack();
  flutterSecureStorage.withMockProperties(<String, String>{
    'ppos_common_property_mock': 'mock',
  });

  await mixpanelAnalyticsService.track('test');

  // Assert
  final Map<String, dynamic> captured = verify(() => mixpanel.track(any(), properties: captureAny(named: 'properties'))).captured.first as Map<String, dynamic>;
  expect(captured.containsKey('ppos_common_property_mock'), isTrue);
  expect(captured['ppos_common_property_mock'], 'mock');
}

Future<void> testFlushEvents() async {
  // Arrange
  final MixpanelAnalyticsService mixpanelAnalyticsService = MixpanelAnalyticsService(apiKey: '');
  final MockMixpanel mixpanel = MockMixpanel();

  // Act
  await inqvine.resetLocator();
  inqvine.registerInLocator<Mixpanel>(mixpanel);

  await mixpanelAnalyticsService.flush();

  // Assert
  verify(() => mixpanel.flush()).called(1);
}

Future<void> testTrackBlockEvent() async {
  // Arrange
  final MixpanelAnalyticsService mixpanelAnalyticsService = MixpanelAnalyticsService(apiKey: '');
  final MockMixpanel mixpanel = MockMixpanel();

  // Act
  await inqvine.resetLocator();
  await mixpanelAnalyticsService.track('mock');

  // Assert
  verifyNever(() => mixpanel.track(any(), properties: any(named: 'properties')));
}

Future<void> testServiceConfiguration() async {
  // Arrange
  final MixpanelAnalyticsService mixpanelAnalyticsService = MixpanelAnalyticsService(apiKey: '');
  final MockMixpanelWrapper mixpanelWrapper = MockMixpanelWrapper();

  // Act
  await inqvine.resetLocator();
  inqvine.registerInLocator<MixpanelWrapper>(mixpanelWrapper);

  await mixpanelAnalyticsService.initializeService();

  // Assert
  expect(inqvine.getFromLocator<Mixpanel>(), isNotNull);
}

Future<void> testMultipleConfiguration() async {
  // Arrange
  final MixpanelAnalyticsService mixpanelAnalyticsService = MixpanelAnalyticsService(apiKey: '');
  final MockMixpanel mockMixpanel = MockMixpanel();

  // Act
  await inqvine.resetLocator();
  inqvine.registerInLocator<Mixpanel>(mockMixpanel);

  Object? exception;
  try {
    await mixpanelAnalyticsService.configureMixpanel();
  } catch (ex) {
    exception = ex;
  }

  // Assert
  expect(exception, AnalyticsException.analyticsProviderAlreadyConfigured);
}
