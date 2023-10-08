// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/extensions/json_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';

// Project imports:

// Project imports:

part 'company_sectors_controller.freezed.dart';

part 'company_sectors_controller.g.dart';

@freezed
class CompanySectorsOption with _$CompanySectorsOption {
  const CompanySectorsOption._();

  const factory CompanySectorsOption({
    required String label,
    required String value,
  }) = _CompanySectorsOption;

  factory CompanySectorsOption.fromJson(Map<String, dynamic> json) => _$CompanySectorsOptionFromJson(json);

  static List<CompanySectorsOption> listFromJson(List<dynamic> data) => data.map((e) {
        final data = json.decodeSafe(e);
        return CompanySectorsOption.fromJson(data);
      }).toList();
}

@freezed
class CompanySectorsControllerState with _$CompanySectorsControllerState {
  const CompanySectorsControllerState._();

  const factory CompanySectorsControllerState({
    @Default(<CompanySectorsOption>[]) List<CompanySectorsOption> options,
  }) = _CompanySectorsControllerState;

  factory CompanySectorsControllerState.initialState() => const CompanySectorsControllerState();
}

@Riverpod(keepAlive: true)
class CompanySectorsController extends _$CompanySectorsController {
  @override
  CompanySectorsControllerState build() {
    return CompanySectorsControllerState.initialState();
  }

  Future<void> updateCompanySectors() async {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final Logger logger = ref.read(loggerProvider);

    if (state.options.isNotEmpty) {
      logger.d('updateCompanySectors() - sectors already loaded');
      return;
    }

    String locale = profileController.state.currentProfile?.locale ?? '';
    if (locale.isEmpty) {
      logger.d('updateCompanySectors() - no locale found, using default locale: \'en\'');
      locale = 'en';
    }

    //* Get topics from cloud function
    final HttpsCallableResult result = await firebaseFunctions.httpsCallable('search-getCompanySectors').call({
      'locale': locale,
    });

    //* Update state
    final rawCompanySectors = jsonDecode(result.data) as List<dynamic>;
    onCompanySectorsUpdated(rawCompanySectors);
  }

  void onCompanySectorsUpdated(List<dynamic> result) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('updateCompanySectors() - updating CompanySectors: $result');
    state = state.copyWith(options: CompanySectorsOption.listFromJson(result));
  }
}
