// Flutter imports:
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
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:ppoa/business/services/system_service.dart';
import '../../client/routing/app_router.gr.dart';
import '../state/app_state.dart';
import 'mutator_service.dart';

class ServiceMixin {
  GetIt get locator => GetIt.instance;

  // State
  AppStateNotifier get stateNotifier => locator.get();
  StateNotifierProvider<AppStateNotifier, AppState> get stateProvider => locator.get();

  // Domain Services
  MutatorService get mutator => locator.get();
  SystemService get system => locator.get();

  // Third Party Services
  AppRouter get router => locator.get();
  FlutterLocalNotificationsPlugin get localNotifications => locator.get();

  Logger get log => locator.isRegistered<Logger>() ? locator.get() : Logger.root;

  FirebaseApp get firebaseApp => locator.get();
  FirebaseAppCheck get firebaseAppCheck => locator.get();
  FirebaseFirestore get firebaseFirestore => locator.get();
  FirebaseMessaging get firebaseMessaging => locator.get();
  FirebaseCrashlytics get firebaseCrashlytics => locator.get();
  FirebaseAuth get firebaseAuth => locator.get();
  FirebaseFunctions get firebaseFunctions => locator.get();
  GoogleSignIn get googleSignIn => locator.get();

  SharedPreferences get sharedPreferences => locator.get();

  bool isRegistered<T extends Object>() {
    return locator.isRegistered<T>();
  }
}
