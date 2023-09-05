// Package imports:
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

    final TalsecConfig config = TalsecConfig(
      isProd: systemController.environment == SystemEnvironment.production,
      androidConfig: AndroidConfig(
        packageName: expectedPackageName,
        signingCertHashes: [
          '1t8j684yVSkwqRbc+3nJpaPHV5Bv5i5mtZGpuiCshKQ=',
        ],
        supportedStores: [
          'com.sec.android.app.samsungapps',
        ],
      ),
      iosConfig: IOSConfig(
        bundleIds: ['com.positiveplusone.v3'],
        teamId: 'FM6NS55XZ3',
      ),
      watcherMail: 'admin@positiveplusone.com',
    );

    try {
      await talsec.start(config);
    } catch (e) {
      ref.read(loggerProvider).e(e);
    }
  }

  Future<void> onDebuggerDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityDebuggerDetected);
  }

  Future<void> onDeviceChangeDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityDeviceChangeDetected);
  }

  Future<void> onDeviceIdDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityDeviceIdDetected);
  }

  Future<void> onJailbreakDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityJailbreakDetected);
  }

  Future<void> onMissingSecureEnclaveDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityMissingSecureEnclaveDetected);
  }

  Future<void> onPasscodeDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityPasscodeDetected);
  }

  Future<void> onRuntimeManipulationDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityRuntimeManipulationDetected);
  }

  Future<void> onSignatureDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securitySignatureDetected);
  }

  Future<void> onSimulatorDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securitySimulatorDetected);
  }

  Future<void> onUnofficialStoreDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityUnofficialStoreDetected);
  }

  Future<void> onDeviceBindingDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityDeviceBindingDetected);
  }

  Future<void> onEmulatorDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityEmulatorDetected);
  }

  Future<void> onHookDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityHookDetected);
  }

  Future<void> onRootDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityRootDetected);
  }

  Future<void> onTamperDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityTamperDetected);
  }

  Future<void> onUntrustedInstallationDetected() async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    await analyticsController.trackEvent(AnalyticEvents.securityEmulatorDetected);
  }
}
