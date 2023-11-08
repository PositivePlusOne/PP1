// Dart imports:
import 'dart:math';

// Package imports:
import 'package:algolia/algolia.dart';
import 'package:app_links/app_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cron/cron.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freerasp/freerasp.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat/src/client/retry_policy.dart';
import 'package:stream_chat/stream_chat.dart' hide Logger, Level;

// Project imports:
import 'package:app/providers/profiles/jobs/profile_fetch_processor.dart';
import 'package:app/providers/system/system_controller.dart';

// ignore: unused_import

part 'third_party.g.dart';

@Riverpod(keepAlive: true)
FutureOr<ProfileFetchProcessor> profileFetchProcessor(ProfileFetchProcessorRef ref) async {
  final ProfileFetchProcessor profileFetchProcessor = ProfileFetchProcessor();
  await profileFetchProcessor.startScheduler();
  return profileFetchProcessor;
}

@Riverpod(keepAlive: true)
FutureOr<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return await SharedPreferences.getInstance();
}

@Riverpod(keepAlive: true)
FutureOr<FlutterSecureStorage> flutterSecureStorage(FlutterSecureStorageRef ref) async {
  return const FlutterSecureStorage();
}

@Riverpod(keepAlive: true)
FutureOr<DefaultCacheManager> defaultCacheManager(DefaultCacheManagerRef ref) async {
  return DefaultCacheManager();
}

@Riverpod(keepAlive: true)
Random random(RandomRef ref) {
  return Random();
}

@Riverpod(keepAlive: true)
AppLinks appLinks(AppLinksRef ref) {
  return AppLinks();
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
      return Logger(level: Level.debug, printer: PrettyPrinter());
  }
}

@Riverpod(keepAlive: true)
Cron cron(CronRef ref) {
  return Cron();
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
  return FirebaseFunctions.instanceFor(region: 'europe-west3');
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
FirebasePerformance firebasePerformance(FirebasePerformanceRef ref) {
  return FirebasePerformance.instance;
}

@Riverpod(keepAlive: true)
Future<FirebaseRemoteConfig> firebaseRemoteConfig(FirebaseRemoteConfigRef ref) async {
  final FirebaseRemoteConfig instance = FirebaseRemoteConfig.instance;

  // Add default values
  await instance.setDefaults(<String, dynamic>{
    SystemController.kFirebaseRemoteConfigFeedPromotionFrequencyKey: 4,
    SystemController.kFirebaseRemoteConfigChatPromotionFrequencyKey: 4,
  });

  return instance;
}

@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin(FlutterLocalNotificationsPluginRef ref) {
  return FlutterLocalNotificationsPlugin();
}

@Riverpod(keepAlive: true)
StreamChatClient streamChatClient(StreamChatClientRef ref) {
  final RetryPolicy retryPolicy = RetryPolicy(
    maxRetryAttempts: 3,
    delayFactor: const Duration(seconds: 1),
    maxDelay: const Duration(seconds: 5),
    shouldRetry: (client, count, error) {
      return false;
    },
  );

  final SystemController systemController = ref.read(systemControllerProvider.notifier);
  late final StreamChatClient client;
  switch (systemController.environment) {
    case SystemEnvironment.staging:
      client = StreamChatClient(
        'hxhyhpru9ze8',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        retryPolicy: retryPolicy,
      );
      break;
    case SystemEnvironment.develop:
      client = StreamChatClient(
        'pw32v2pqjetx',
        connectTimeout: const Duration(seconds: 300),
        receiveTimeout: const Duration(seconds: 300),
        retryPolicy: retryPolicy,
      );
      break;
    case SystemEnvironment.production:
      client = StreamChatClient(
        'h3mtdn8hajhg',
        connectTimeout: const Duration(seconds: 300),
        receiveTimeout: const Duration(seconds: 300),
        retryPolicy: retryPolicy,
      );
      break;
  }

  return client;
}

@Riverpod(keepAlive: true)
FutureOr<Algolia> algolia(AlgoliaRef ref) async {
  final Logger logger = ref.read(loggerProvider);
  logger.i('Initializing Algolia');

  final SystemController systemController = ref.read(systemControllerProvider.notifier);
  switch (systemController.environment) {
    case SystemEnvironment.develop:
      return const Algolia.init(applicationId: 'N7Q08JSQY0', apiKey: '0011036dc6c06fc2211c001146162eda');
    case SystemEnvironment.staging:
      return const Algolia.init(applicationId: 'AWKMEQDRX7', apiKey: '5a93c4dd3739ea7086014c3d323cc59a');
    case SystemEnvironment.production:
      return const Algolia.init(applicationId: 'DB7J3BMYAI', apiKey: '01c205da1edb779162d0991de0f01500');
  }
}

@Riverpod(keepAlive: true)
GoogleMapsGeocoding googleMapsGeocoding(GoogleMapsGeocodingRef ref) {
  const String apiKey = String.fromEnvironment("MAPS_KEY");
  final GoogleMapsGeocoding googleMapsGeocoding = GoogleMapsGeocoding(apiKey: apiKey);
  return googleMapsGeocoding;
}

@Riverpod(keepAlive: true)
GoogleMapsPlaces googleMapsPlaces(GoogleMapsPlacesRef ref) {
  const String apiKey = String.fromEnvironment("MAPS_KEY");
  final GoogleMapsPlaces googleMapsPlaces = GoogleMapsPlaces(apiKey: apiKey);
  return googleMapsPlaces;
}

@Riverpod(keepAlive: true)
FutureOr<BaseDeviceInfo> deviceInfo(DeviceInfoRef ref) async {
  return await DeviceInfoPlugin().deviceInfo;
}

@Riverpod(keepAlive: true)
FutureOr<PermissionStatus> notificationPermissions(NotificationPermissionsRef ref) async {
  return Permission.notification.request();
}

@Riverpod(keepAlive: true)
FutureOr<PermissionStatus> locationPermissions(LocationPermissionsRef ref) async {
  return Permission.location.request();
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
FutureOr<PermissionStatus> microphonePermissions(MicrophonePermissionsRef ref) async {
  return Permission.microphone.request();
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
