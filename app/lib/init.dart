// Flutter imports:
import 'package:app/providers/content/promotions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/content/gallery_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/exception_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/system/security_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/providers/user/pledge_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'main.dart';

Future<void> setupApplication() async {
  //* Setup required services without concrete implementations
  WidgetsFlutterBinding.ensureInitialized();

  //* Set system UI to use a reduced/slimline version of native UI
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Firebase.initializeApp();

  //* Get required controllers
  final Logger logger = providerContainer.read(loggerProvider);
  final GetStreamController getStreamController = providerContainer.read(getStreamControllerProvider.notifier);
  final AnalyticsController analyticsController = providerContainer.read(analyticsControllerProvider.notifier);
  final UserController userController = providerContainer.read(userControllerProvider.notifier);
  final SystemController systemController = providerContainer.read(systemControllerProvider.notifier);
  final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
  final RelationshipController relationshipController = providerContainer.read(relationshipControllerProvider.notifier);
  final CommunitiesController communitiesController = providerContainer.read(communitiesControllerProvider.notifier);
  final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
  final ExceptionController exceptionController = providerContainer.read(exceptionControllerProvider.notifier);
  final AsyncSecurityController securityController = providerContainer.read(asyncSecurityControllerProvider.notifier);
  final GalleryController galleryController = providerContainer.read(galleryControllerProvider.notifier);
  final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
  final TagsController tagsController = providerContainer.read(tagsControllerProvider.notifier);
  final PromotionsController promotionsController = providerContainer.read(promotionsControllerProvider.notifier);

  //* Initialize security bindings
  await securityController.setupTalsec();

  //* Initial third party services
  final FirebaseEndpoint? firebaseAuthEndpoint = systemController.firebaseAuthEndpoint;
  final FirebaseEndpoint? firebaseFunctionsEndpoint = systemController.firebaseFunctionsEndpoint;
  final FirebaseEndpoint? firebaseFirestoreEndpoint = systemController.firebaseFirestoreEndpoint;
  final FirebaseEndpoint? firebaseStorageEndpoint = systemController.firebaseStorageEndpoint;

  if (firebaseFunctionsEndpoint != null) {
    logger.w('[setupApplication] Using Firebase Functions Emulator: ${firebaseFunctionsEndpoint.toString()}');
    FirebaseFunctions.instance.useFunctionsEmulator(firebaseFunctionsEndpoint.item1, firebaseFunctionsEndpoint.item2);
  }

  if (firebaseFirestoreEndpoint != null) {
    logger.w('[setupApplication] Using Firebase Firestore Emulator: ${firebaseFirestoreEndpoint.toString()}');
    FirebaseFirestore.instance.useFirestoreEmulator(firebaseFirestoreEndpoint.item1, firebaseFirestoreEndpoint.item2);
  }

  if (firebaseStorageEndpoint != null) {
    logger.w('[setupApplication] Using Firebase Storage Emulator: ${firebaseStorageEndpoint.toString()}');
    await FirebaseStorage.instance.useStorageEmulator(firebaseStorageEndpoint.item1, firebaseStorageEndpoint.item2);
  }

  if (firebaseAuthEndpoint != null) {
    logger.w('[setupApplication] Using Firebase Auth Emulator: ${firebaseAuthEndpoint.toString()}');
    await FirebaseAuth.instance.useAuthEmulator(firebaseAuthEndpoint.item1, firebaseAuthEndpoint.item2);
  }

  // Reset the application on a new install
  if (await systemController.isFirstInstall()) {
    await systemController.resetSharedPreferences();
    await systemController.notifyFirstInstall();
  }

  //* Setup providers
  await providerContainer.read(asyncPledgeControllerProvider.future);
  await providerContainer.read(asyncSecurityControllerProvider.future);

  await getStreamController.setupListeners();
  await analyticsController.flushEvents();
  await userController.setupListeners();
  await relationshipController.setupListeners();
  await communitiesController.setupListeners();
  await notificationsController.setupListeners();
  await profileController.setupListeners();
  await galleryController.setupListeners();
  await cacheController.setupListeners();
  await tagsController.setupListeners();

  await systemController.preloadPackageInformation();

  await notificationsController.requestPushNotificationPermissions();
  await notificationsController.setupPushNotificationListeners();

  await exceptionController.setupCrashlyticListeners();

  //* Verify shared preferences future has been resolved
  await providerContainer.read(sharedPreferencesProvider.future);

  //* Lock rotation of the application to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Set Photo Picker support for Image Picker
  final ImagePickerPlatform imagePickerImplementation = ImagePickerPlatform.instance;
  if (imagePickerImplementation is ImagePickerAndroid) {
    imagePickerImplementation.useAndroidPhotoPicker = true;
  }
}
