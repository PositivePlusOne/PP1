// Package imports:
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freerasp/freerasp.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat/stream_chat.dart' hide Logger, Level;
import 'package:stream_chat_persistence/stream_chat_persistence.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart' hide Logger, Level;

// Project imports:
import 'package:app/providers/system/system_controller.dart';

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
Talsec talsec(TalsecRef ref) {
  return Talsec.instance;
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
FirebaseStorage firebaseStorage(FirebaseStorageRef ref) {
  return FirebaseStorage.instance;
}

@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin(FlutterLocalNotificationsPluginRef ref) {
  return FlutterLocalNotificationsPlugin();
}

@Riverpod(keepAlive: true)
StreamChatPersistenceClient streamChatPersistenceClient(StreamChatPersistenceClientRef ref) {
  return StreamChatPersistenceClient(connectionMode: ConnectionMode.background);
}

@Riverpod(keepAlive: true)
StreamChatClient streamChatClient(StreamChatClientRef ref) {
  // TODO(ryan): Move to be environmental
  final client = StreamChatClient('pw32v2pqjetx');
  client.chatPersistenceClient = ref.read(streamChatPersistenceClientProvider);
  return client;
}

@Riverpod(keepAlive: true)
StreamFeedClient streamFeedClient(StreamFeedClientRef ref) {
  return StreamFeedClient('pw32v2pqjetx');
}

@Riverpod(keepAlive: true)
FutureOr<Algolia> algolia(AlgoliaRef ref) async {
  final Logger logger = ref.read(loggerProvider);
  logger.i('Initializing Algolia');

  // TODO(ryan): Make these environmental
  return const Algolia.init(applicationId: 'N7Q08JSQY0', apiKey: '0011036dc6c06fc2211c001146162eda');
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
FutureOr<PackageInfo> packageInfo(PackageInfoRef ref) async {
  return await PackageInfo.fromPlatform();
}

@Riverpod(keepAlive: true)
FutureOr<PermissionStatus> cameraPermissions(CameraPermissionsRef ref) async {
  return Permission.camera.request();
}

@Riverpod(keepAlive: true)
LocalAuthentication localAuthentication(LocalAuthenticationRef ref) {
  return LocalAuthentication();
}

@Riverpod(keepAlive: true)
ImagePicker imagePicker(ImagePickerRef ref) {
  return ImagePicker();
}

@Riverpod(keepAlive: true)
EventBus eventBus(EventBusRef ref) {
  return EventBus();
}
