// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

// Project imports:
import 'package:ppoa/business/services/system_service.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import '../../client/routing/app_router.gr.dart';
import '../handlers/android_foreground_notification_handler.dart';
import '../handlers/local_notification_receive_handler.dart';
import '../handlers/local_notification_response_handler.dart';
import '../state/app_state.dart';
import 'mutator_service.dart';

Future<void> prepareState(EnvironmentType environmentType) async {
  // Configure some UI properties
  WidgetsFlutterBinding.ensureInitialized();

  final AppState initialState = AppState.initialState(
    environmentType: environmentType,
  );

  final GetIt locator = GetIt.instance;
  final AppStateNotifier appStateNotifier = AppStateNotifier(state: initialState);

  final StateNotifierProvider<AppStateNotifier, AppState> appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
    return locator.get<AppStateNotifier>();
  });

  // Inject notifier
  locator.registerSingleton<EventBus>(EventBus());
  locator.registerSingleton<AppStateNotifier>(appStateNotifier);
  locator.registerSingleton<StateNotifierProvider<AppStateNotifier, AppState>>(appStateProvider);

  // Prepare Domain Services
  locator.registerSingleton(MutatorService());
  locator.registerSingleton(SystemService());

  // Prepare Third Party Services
  locator.registerSingleton(Logger());
  locator.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());
  locator.registerSingleton<AppRouter>(AppRouter());

  final bool isMobilePlatform = Platform.isAndroid || Platform.isIOS;

  //* Some code cannot be ran on desktop, and hence their function is disabled.
  if (!isMobilePlatform) {
    return;
  }

  locator.get<Logger>().i('Connecting to Firebase...');
  await Firebase.initializeApp();

  //* Record error events from Flutter and Framework
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  if (environmentType != EnvironmentType.production) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
    );
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('notification_icon');
  const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin, macOS: initializationSettingsDarwin);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidLocalNotificationsPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidLocalNotificationsPlugin == null) {
      return;
    }

    const AndroidNotificationChannel highImportanceNotificationChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    await androidLocalNotificationsPlugin.createNotificationChannel(highImportanceNotificationChannel);
    await configureAndroidForegroundMessages(
      channel: highImportanceNotificationChannel,
      notificationsPlugin: flutterLocalNotificationsPlugin,
    );
  }

  final FirebaseFunctions firebaseFunctions = FirebaseFunctions.instanceFor(region: 'europe-west1');

  //* Uncomment this line to use the firebase emulators
  //* Run this command to start it: firebase emulators:start --inspect-functions
  // firebaseFunctions.useFunctionsEmulator('localhost', 5001);
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  // FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  locator.registerSingleton<FirebaseApp>(Firebase.app());
  locator.registerSingleton<FirebaseAppCheck>(FirebaseAppCheck.instance);
  locator.registerSingleton<FirebaseCrashlytics>(FirebaseCrashlytics.instance);
  locator.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  locator.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  locator.registerSingleton<FirebaseFunctions>(firebaseFunctions);
  locator.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);
  locator.registerSingleton<FlutterLocalNotificationsPlugin>(flutterLocalNotificationsPlugin);
  locator.registerSingleton<GoogleSignIn>(GoogleSignIn(
    scopes: [
      'email',
    ],
  ));
}
