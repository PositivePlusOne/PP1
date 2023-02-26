// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../services/third_party.dart';

part 'search_controller.freezed.dart';
part 'search_controller.g.dart';

@freezed
class SearchControllerState with _$SearchControllerState {
  const factory SearchControllerState({
    required String algoliaApplicationID,
    @Default('') String algoliaApiKey,
  }) = _SearchControllerState;

  factory SearchControllerState.fromAlgoliaApplicationID(String algoliaApplicationID) => SearchControllerState(algoliaApplicationID: algoliaApplicationID);
}

@Riverpod(keepAlive: true)
class SearchController extends _$SearchController {
  StreamSubscription<User?>? userSubscription;

  String get algoliaApplicationID {
    final SystemControllerState systemState = ref.read(systemControllerProvider);
    switch (systemState) {
      default:
        return 'DB7J3BMYAI';
    }
  }

  @override
  SearchControllerState build() {
    return SearchControllerState.fromAlgoliaApplicationID(algoliaApplicationID);
  }

  Future<void> setupListeners() async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    await userSubscription?.cancel();
    userSubscription = userController.userChangedController.stream.listen(onUserChanged);
  }

  Future<void> onUserChanged(User? user) async {
    final Logger log = ref.read(loggerProvider);
    log.d('[SearchController] onUserChanged()');

    await updateAlgoliaApi();
  }

  Future<void> performSearch() async {
    final Logger log = ref.read(loggerProvider);
    log.d('[SearchController] performSearch()');

    if (state.algoliaApiKey.isEmpty) {
      log.e('[SearchController] performSearch() algoliaApi is empty');
      return;
    }
  }

  Future<void> updateAlgoliaApi() async {
    final Logger log = ref.read(loggerProvider);
    final UserControllerState userState = ref.read(userControllerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    if (userState.user == null) {
      log.i('[SearchController] onUserChanged() user is null');
      state = state.copyWith(algoliaApiKey: '');
      return;
    }

    if (state.algoliaApiKey.isNotEmpty) {
      log.i('[SearchController] onUserChanged() algoliaApi is already set');
      return;
    }

    try {
      final HttpsCallableResult result = await firebaseFunctions.httpsCallable('search-getAPIKey').call();
      if (result.data == null || result.data is! String || result.data.isEmpty) {
        log.e('[SearchController] onUserChanged() algoliaApi is null');
        return;
      }

      final String algoliaApiKey = result.data as String;
      log.d('[SearchController] onUserChanged() algoliaApiKey: $algoliaApiKey');

      state = state.copyWith(algoliaApiKey: algoliaApiKey);
    } catch (ex) {
      log.e('[SearchController] onUserChanged() algoliaApiKey is null', ex);
      return;
    }
  }
}
