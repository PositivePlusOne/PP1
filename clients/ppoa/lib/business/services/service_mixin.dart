// Package imports:
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

// Project imports:
import '../../client/routing/app_router.gr.dart';
import '../state/app_state.dart';

class ServiceMixin {
  GetIt get locator => GetIt.instance;

  // State
  AppStateNotifier get stateNotifier => locator.get();
  StateNotifierProvider<AppStateNotifier, AppState> get stateProvider => locator.get();

  // Domain Services

  // Third Party Services
  AppRouter get router => locator.get();
  Logger get log => locator.isRegistered<Logger>() ? locator.get() : Logger.root;
}
