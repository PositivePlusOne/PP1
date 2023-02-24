// Package imports:
import 'package:app/constants/key_constants.dart';
import 'package:app/providers/system/security_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freerasp/talsec_app.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:logger/logger.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stream_chat/stream_chat.dart' hide Logger, Level;

part 'third_party.g.dart';

@Riverpod(keepAlive: true)
FutureOr<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return SharedPreferences.getInstance();
}

@Riverpod(keepAlive: true)
FutureOr<Mixpanel> mixpanel(MixpanelRef ref) async {
  final SystemController systemController = ref.read(systemControllerProvider.notifier);

  late final Mixpanel mixpanel;
  switch (systemController.environment) {
    case SystemEnvironment.production:
      mixpanel = await Mixpanel.init('bed92b8481a9761ab9b54d10cc7478d9', trackAutomaticEvents: true);
      break;
    default:
      mixpanel = await Mixpanel.init('f022a5ab8247d3bb6a1b332445837914', trackAutomaticEvents: true);
      mixpanel.setLoggingEnabled(true);
      break;
  }

  return mixpanel;
}

@Riverpod(keepAlive: true)
FutureOr<TalsecApp> talsecApp(TalsecAppRef ref) async {
  final SystemController systemController = ref.read(systemControllerProvider.notifier);
  final AsyncSecurityController securityController = await ref.read(asyncSecurityControllerProvider.notifier);

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

  final TalsecCallback callback = TalsecCallback(
    androidCallback: AndroidCallback(
      onDeviceBindingDetected: securityController.onDeviceBindingDetected,
      onEmulatorDetected: securityController.onEmulatorDetected,
      onHookDetected: securityController.onHookDetected,
      onRootDetected: securityController.onRootDetected,
      onTamperDetected: securityController.onTamperDetected,
      onUntrustedInstallationDetected: securityController.onUntrustedInstallationDetected,
    ),
    iosCallback: IOSCallback(
      onDeviceChangeDetected: securityController.onDeviceChangeDetected,
      onDeviceIdDetected: securityController.onDeviceIdDetected,
      onJailbreakDetected: securityController.onJailbreakDetected,
      onMissingSecureEnclaveDetected: securityController.onMissingSecureEnclaveDetected,
      onPasscodeDetected: securityController.onPasscodeDetected,
      onRuntimeManipulationDetected: securityController.onRuntimeManipulationDetected,
      onSignatureDetected: securityController.onSignatureDetected,
      onSimulatorDetected: securityController.onSimulatorDetected,
      onUnofficialStoreDetected: securityController.onUnofficialStoreDetected,
    ),
    onDebuggerDetected: securityController.onDebuggerDetected,
  );

  final TalsecConfig config = TalsecConfig(
    androidConfig: AndroidConfig(
      expectedPackageName: expectedPackageName,
      expectedSigningCertificateHashes: [
        '1t8j684yVSkwqRbc+3nJpaPHV5Bv5i5mtZGpuiCshKQ=',
      ],
      supportedAlternativeStores: [
        'com.sec.android.app.samsungapps',
      ],
    ),
    iosConfig: const IOSconfig(
      appBundleId: 'com.positiveplusone.v3',
      appTeamId: 'FM6NS55XZ3',
    ),
    watcherMail: 'admin@positiveplusone.com',
  );

  return TalsecApp(config: config, callback: callback);
}

@Riverpod(keepAlive: true)
Logger logger(LoggerRef ref) {
  final SystemController systemController = ref.read(systemControllerProvider.notifier);
  switch (systemController.environment) {
    case SystemEnvironment.production:
      return Logger(level: Level.warning, printer: PrettyPrinter());
    default:
      return Logger(level: Level.verbose, printer: PrettyPrinter());
  }
}

@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(GoogleSignInRef ref) {
  return GoogleSignIn(
    scopes: [
      'email',
    ],
  );
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
FirebaseFunctions firebaseFunctions(FirebaseFunctionsRef ref) {
  return FirebaseFunctions.instance;
}

@Riverpod(keepAlive: true)
FirebaseMessaging firebaseMessaging(FirebaseMessagingRef ref) {
  return FirebaseMessaging.instance;
}

@Riverpod(keepAlive: true)
FirebaseCrashlytics firebaseCrashlytics(FirebaseCrashlyticsRef ref) {
  return FirebaseCrashlytics.instance;
}

@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin(FlutterLocalNotificationsPluginRef ref) {
  return FlutterLocalNotificationsPlugin();
}

@Riverpod(keepAlive: true)
StreamChatClient streamChatClient(StreamChatClientRef ref) {
  return StreamChatClient(kApiKeyStream);
}

@Riverpod(keepAlive: true)
FutureOr<BaseDeviceInfo> deviceInfo(DeviceInfoRef ref) async {
  return await DeviceInfoPlugin().deviceInfo;
}

@Riverpod(keepAlive: true)
FutureOr<PermissionStatus> notificationPermissions(NotificationPermissionsRef ref) async {
  return Permission.contacts.request();
}

@Riverpod(keepAlive: true)
LocalAuthentication localAuthentication(LocalAuthenticationRef ref) {
  return LocalAuthentication();
}

@Riverpod(keepAlive: true)
EventBus eventBus(EventBusRef ref) {
  return EventBus();
}
