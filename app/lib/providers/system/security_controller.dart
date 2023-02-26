// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import '../../services/third_party.dart';

part 'security_controller.freezed.dart';
part 'security_controller.g.dart';

@freezed
class SecurityControllerState with _$SecurityControllerState {
  const factory SecurityControllerState({
    @Default(false) bool canAuthenticateWithBiometricsLocally,
    @Default(false) bool canAuthenticateLocally,
    @Default([]) List<BiometricType> biometricTypes,
  }) = _SecurityControllerState;

  factory SecurityControllerState.initialState({
    required bool canAuthenticateWithBiometricsLocally,
    required bool canAuthenticateLocally,
    required List<BiometricType> biometricTypes,
  }) =>
      SecurityControllerState(
        canAuthenticateWithBiometricsLocally: canAuthenticateWithBiometricsLocally,
        canAuthenticateLocally: canAuthenticateLocally,
        biometricTypes: biometricTypes,
      );
}

@Riverpod(keepAlive: true)
class AsyncSecurityController extends _$AsyncSecurityController {
  @override
  FutureOr<SecurityControllerState> build() async {
    final LocalAuthentication localAuthentication = ref.read(localAuthenticationProvider);
    final bool canAuthenticateWithBiometrics = await localAuthentication.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await localAuthentication.isDeviceSupported();

    final List<BiometricType> biometricTypes = <BiometricType>[];
    if (canAuthenticateWithBiometrics) {
      biometricTypes.addAll(await localAuthentication.getAvailableBiometrics());
    }

    return SecurityControllerState.initialState(
      canAuthenticateWithBiometricsLocally: canAuthenticateWithBiometrics,
      canAuthenticateLocally: canAuthenticate,
      biometricTypes: biometricTypes,
    );
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
