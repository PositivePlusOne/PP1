// Dart imports:
import 'dart:async';

// Package imports:
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:freerasp/freerasp.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import '../../services/third_party.dart';

part 'security_controller.freezed.dart';
part 'security_controller.g.dart';

@freezed
class SecurityControllerState with _$SecurityControllerState {
  const factory SecurityControllerState({
    @Default(false) bool canCheckBiometrics,
    @Default(false) bool hasBiometrics,
    @Default([]) List<BiometricType> biometricDevices,
    @Default(false) bool isBiometricAuthenticationEnabled,
  }) = _SecurityControllerState;

  factory SecurityControllerState.initialState({
    required bool canCheckBiometrics,
    required bool hasBiometrics,
    required List<BiometricType> biometricDevices,
  }) =>
      SecurityControllerState(
        canCheckBiometrics: canCheckBiometrics,
        hasBiometrics: hasBiometrics,
        biometricDevices: biometricDevices,
        isBiometricAuthenticationEnabled: false,
      );
}

@Riverpod(keepAlive: true)
class AsyncSecurityController extends _$AsyncSecurityController {
  StreamSubscription<Threat>? _threatSubscription;

  @override
  FutureOr<SecurityControllerState> build() async {
    final Logger log = ref.read(loggerProvider);

    final LocalAuthentication localAuthentication = ref.read(localAuthenticationProvider);
    final bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
    final bool hasBiometrics = await localAuthentication.isDeviceSupported();

    final List<BiometricType> biometricDevices = <BiometricType>[];

    //* https://github.com/flutter/packages/pull/3780
    //* awaiting package fix
    //TODO check biometrics auth fix

    if (canCheckBiometrics) {
      try {
        biometricDevices.addAll(await localAuthentication.getAvailableBiometrics());
      } catch (e) {
        log.e(e);
      }
    }

    return SecurityControllerState.initialState(
      canCheckBiometrics: canCheckBiometrics,
      hasBiometrics: hasBiometrics,
      biometricDevices: biometricDevices,
    );
  }

  Future<void> setupTalsec() async {
    final Talsec talsec = ref.read(talsecProvider);
    final SystemController systemController = ref.read(systemControllerProvider.notifier);

    late final String expectedPackageName;
    switch (systemController.environment) {
      case SystemEnvironment.production:
        expectedPackageName = 'com.positiveplusone.v3';
        break;
      case SystemEnvironment.staging:
        expectedPackageName = 'com.positiveplusone.v3.staging';
        break;
      case SystemEnvironment.develop:
        expectedPackageName = 'com.positiveplusone.v3.develop';
        break;
    }

    late final List<String> expectedHashes;
    switch (systemController.environment) {
      case SystemEnvironment.production:
        expectedHashes = [
          hashConverter.fromSha256toBase64('d6:df:23:eb:ce:32:55:29:30:a9:16:dc:fb:79:c9:a5:a3:c7:57:90:6f:e6:2e:66:b5:91:a9:ba:20:ac:84:a4'),
          hashConverter.fromSha256toBase64('0E:1C:96:C1:4F:DC:25:CA:28:76:0A:7D:DC:69:B9:1C:7F:47:69:20:01:90:AC:2C:B5:3D:8A:23:93:D8:4B:26'),
        ];
        break;
      case SystemEnvironment.staging:
        expectedHashes = [
          hashConverter.fromSha256toBase64('d6:df:23:eb:ce:32:55:29:30:a9:16:dc:fb:79:c9:a5:a3:c7:57:90:6f:e6:2e:66:b5:91:a9:ba:20:ac:84:a4'),
          hashConverter.fromSha256toBase64('35:1A:F8:20:B9:C5:89:26:8A:06:B3:31:32:E8:8C:BA:62:78:D4:BD:07:20:2F:4B:2E:93:97:6A:EC:9F:D1:80'),
        ];
        break;
      case SystemEnvironment.develop:
        expectedHashes = [
          hashConverter.fromSha256toBase64('d6:df:23:eb:ce:32:55:29:30:a9:16:dc:fb:79:c9:a5:a3:c7:57:90:6f:e6:2e:66:b5:91:a9:ba:20:ac:84:a4'),
        ];
        break;
    }

    final TalsecConfig config = TalsecConfig(
      isProd: systemController.environment == SystemEnvironment.production || systemController.environment == SystemEnvironment.staging,
      androidConfig: AndroidConfig(
        packageName: expectedPackageName,
        signingCertHashes: expectedHashes,
      ),
      iosConfig: IOSConfig(
        bundleIds: ['com.positiveplusone.v3'],
        teamId: 'FM6NS55XZ3',
      ),
      watcherMail: 'admin@positiveplusone.com',
    );

    try {
      await talsec.start(config);

      await _threatSubscription?.cancel();
      _threatSubscription = talsec.onThreatDetected.listen(onThreatDetected);
    } catch (e) {
      ref.read(loggerProvider).e(e);
    }
  }

  Future<void> onThreatDetected(Threat event) async {
    final SystemEnvironment environment = ref.read(systemControllerProvider.notifier).environment;
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final Logger log = ref.read(loggerProvider);
    log.e('Threat detected: $event');

    // Skip spamming analytics in development
    if (environment == SystemEnvironment.develop) {
      return;
    }

    await analyticsController.trackEvent(AnalyticEvents.securityAlert, properties: <String, dynamic>{
      'threat': event.toString(),
    });
  }
}
