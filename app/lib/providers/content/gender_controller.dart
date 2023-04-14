// Dart imports:

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:

import 'package:app/providers/user/profile_controller.dart';
import 'package:app/services/third_party.dart';

// Project imports:

part 'gender_controller.freezed.dart';

part 'gender_controller.g.dart';

@freezed
class GenderOption with _$GenderOption {
  const GenderOption._();

  const factory GenderOption({
    required String label,
    required String value,
  }) = _GenderOption;

  factory GenderOption.fromJson(Map<String, dynamic> json) => _$GenderOptionFromJson(json);

  static List<GenderOption> listFromJson(List<dynamic> json) => json.map((e) => GenderOption.fromJson(e as Map<String, dynamic>)).toList();
}

@freezed
class GenderControllerState with _$GenderControllerState {
  const GenderControllerState._();

  const factory GenderControllerState({
    @Default(<GenderOption>[]) List<GenderOption> options,
  }) = _GenderControllerState;

  factory GenderControllerState.initialState() => const GenderControllerState();
}

@Riverpod(keepAlive: true)
class GenderController extends _$GenderController {
  @override
  GenderControllerState build() {
    return GenderControllerState.initialState();
  }

  Future<void> updateGenders() async {
    final ProfileControllerState profileControllerState = ref.read(profileControllerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final Logger logger = ref.read(loggerProvider);

    if (state.options.isNotEmpty) {
      logger.d('updateInterests() - interests already loaded');
      return;
    }

    String locale = profileControllerState.userProfile?.locale ?? '';
    if (locale.isEmpty) {
      logger.d('updateInterests() - no locale found, using default locale: \'en\'');
      locale = 'en';
    }

    //* Get topics from cloud function
    final HttpsCallableResult result = await firebaseFunctions.httpsCallable('search-getGenders').call({
      'locale': locale,
    });

    //* Update state
    final rawInterests = jsonDecode(result.data) as List<dynamic>;

    logger.d('updateInterests() - updating interests: $rawInterests');
    state = state.copyWith(options: GenderOption.listFromJson(rawInterests));
  }
}
