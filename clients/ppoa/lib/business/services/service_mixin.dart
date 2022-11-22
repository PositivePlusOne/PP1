// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

// Project imports:
import 'package:ppoa/business/services/localization_service.dart';
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
  LocalizationService get localizations => locator.get();

  // Third Party Services
  AppRouter get router => locator.get();
  Logger get log => locator.isRegistered<Logger>() ? locator.get() : Logger.root;
  FirebaseApp get firebaseApp => locator.get();
  FirebaseFirestore get firestore => locator.get();

  bool isRegistered<T extends Object>() {
    return locator.isRegistered<T>();
  }
}
