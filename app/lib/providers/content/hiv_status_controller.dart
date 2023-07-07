// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:app/extensions/json_extensions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';

part 'hiv_status_controller.freezed.dart';

part 'hiv_status_controller.g.dart';

@freezed
class HivStatus with _$HivStatus {
  const factory HivStatus({
    required String value,
    required String label,
    List<HivStatus>? children,
  }) = _HivStatus;

  factory HivStatus.fromJson(Map<String, dynamic> json) => _$HivStatusFromJson(json);

  static List<HivStatus> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((dynamic data) => HivStatus.fromJson(json.decodeSafe(data))).toList();
  }
}

@freezed
class HivStatusControllerState with _$HivStatusControllerState {
  const factory HivStatusControllerState({
    @Default(<HivStatus>[]) List<HivStatus> hivStatuses,
  }) = _HivStatusControllerState;

  factory HivStatusControllerState.initialState() => const HivStatusControllerState();
}

@Riverpod(keepAlive: true)
class HivStatusController extends _$HivStatusController {
  @override
  HivStatusControllerState build() {
    return HivStatusControllerState.initialState();
  }

  Future<void> updateHivStatuses() async {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final Logger logger = ref.read(loggerProvider);

    if (state.hivStatuses.isNotEmpty) {
      logger.d('updateHivStatuses() - interests already loaded');
      return;
    }

    String locale = profileController.state.currentProfile?.locale ?? '';
    if (locale.isEmpty) {
      logger.d('updateInterests() - no locale found, using default locale: \'en\'');
      locale = 'en';
    }

    //* Get topics from cloud function
    final HttpsCallableResult result = await firebaseFunctions.httpsCallable('search-getHivStatuses')(
      {'locale': locale},
    );

    //* Update state
    final rawStatuses = json.decode(result.data);
    onHivStatusesUpdated(rawStatuses);
  }

  void onHivStatusesUpdated(List<dynamic> rawStatuses) {
    final Logger logger = ref.read(loggerProvider);
    final statuses = HivStatus.listFromJson(rawStatuses);
    logger.d('updateHivStatuses() - updating statuses: $statuses');
    state = state.copyWith(hivStatuses: statuses);
  }
}
