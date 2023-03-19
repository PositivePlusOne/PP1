import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/exception_controller.dart';
import 'package:app/providers/system/security_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/messaging_controller.dart';
import 'package:app/providers/user/pledge_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freerasp/talsec_app.dart';
import 'package:logger/logger.dart';

import 'main.dart';

Future<void> setupApplication() async {
  //* Setup required services without concrete implementations
  WidgetsFlutterBinding.ensureInitialized();

  //* Get required controllers
  final Logger logger = providerContainer.read(loggerProvider);
  final MessagingController messagingController = providerContainer.read(messagingControllerProvider.notifier);
  final AnalyticsController analyticsController = providerContainer.read(analyticsControllerProvider.notifier);
  final UserController userController = providerContainer.read(userControllerProvider.notifier);
  final SystemController systemController = providerContainer.read(systemControllerProvider.notifier);
  final ExceptionController exceptionController = providerContainer.read(exceptionControllerProvider.notifier);

  //* Setup Firebase
  await Firebase.initializeApp();

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

  //* Setup providers
  await providerContainer.read(asyncPledgeControllerProvider.future);
  await providerContainer.read(asyncSecurityControllerProvider.future);

  final TalsecApp talsecApp = await providerContainer.read(talsecAppProvider.future);
  talsecApp.start();

  await messagingController.setupListeners();
  await analyticsController.flushEvents();
  await userController.setupListeners();

  await systemController.requestPushNotificationPermissions();
  await systemController.setupPushNotificationListeners();

  await exceptionController.setupCrashlyticListeners();

  //* Verify shared preferences future has been resolved
  await providerContainer.read(sharedPreferencesProvider.future);
}
