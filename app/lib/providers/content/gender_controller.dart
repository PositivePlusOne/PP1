// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/extensions/json_extensions.dart';

// Project imports:
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';

// Project imports:

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

  static List<GenderOption> listFromJson(List<dynamic> data) => data.map((e) {
        final data = json.decodeSafe(e);
        return GenderOption.fromJson(data);
      }).toList();
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
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final Logger logger = ref.read(loggerProvider);

    if (state.options.isNotEmpty) {
      logger.d('updateInterests() - interests already loaded');
      return;
    }

    String locale = profileController.state.currentProfile?.locale ?? '';
    if (locale.isEmpty) {
      logger.d('updateInterests() - no locale found, using default locale: \'en\'');
      locale = 'en';
    }

    //* Get topics from cloud function
    final HttpsCallableResult result = await firebaseFunctions.httpsCallable('search-getGenders').call({
      'locale': locale,
    });

    //* Update state
    final rawGenders = jsonDecode(result.data) as List<dynamic>;
    onGendersUpdated(rawGenders);
  }

  void onGendersUpdated(List<dynamic> result) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('updateGenders() - updating genders: $result');
    state = state.copyWith(options: GenderOption.listFromJson(result));
  }
}
