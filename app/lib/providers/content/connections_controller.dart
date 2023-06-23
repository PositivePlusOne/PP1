// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/geo/positive_place.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/services/third_party.dart';

part 'connections_controller.freezed.dart';

part 'connections_controller.g.dart';

@freezed
class ConnectedUserResult with _$ConnectedUserResult {
  const factory ConnectedUserResult({
    required List<ConnectedUser> data,
    required Pagination pagination,
  }) = _ConnectedUserResult;

  factory ConnectedUserResult.fromJson(Map<String, dynamic> json) => _$ConnectedUserResultFromJson(json);
}

@freezed
class ConnectedUser with _$ConnectedUser {
  const factory ConnectedUser({
    required String id,
    required String displayName,
    @JsonKey(fromJson: PositivePlace.fromJson) PositivePlace? place,
    String? profileImage,
    String? accentColor,
    String? hivStatus,
    List<String>? interests,
    List<String>? genders,
    String? birthday,
  }) = _ConnectedUser;

  factory ConnectedUser.fromJson(Map<String, dynamic> json) => _$ConnectedUserFromJson(json);
}

@freezed
class ConnectedUserState with _$ConnectedUserState {
  const factory ConnectedUserState({
    @Default(<ConnectedUser>[]) List<ConnectedUser> users,
    @Default(false) bool hasReachMax,
    required Pagination pagination,
    @Default(<ConnectedUser>[]) List<ConnectedUser> filteredUsers,
  }) = _ConnectedUserState;
}

@Riverpod(keepAlive: true)
class ConnectedUsersController extends _$ConnectedUsersController {
  @override
  Future<ConnectedUserState> build() async {
    const initialPagination = Pagination(cursor: null, limit: 15);
    final res = await _fetchConnected(initialPagination);
    return ConnectedUserState(
      pagination: res?.pagination ?? initialPagination,
      users: res?.data ?? [],
      filteredUsers: res?.data ?? [],
    );
  }

  Future<ConnectedUserResult?> _fetchConnected(Pagination pagination) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Updating connected relationships');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-getConnectedUsers');
    final HttpsCallableResult response = await callable.call({"pagination": pagination.toJson()});

    logger.i('[Profile Service] - Connected relationships loaded: ${response.data}');
    final Map<String, dynamic> data = json.decodeSafe(response.data);

    return ConnectedUserResult.fromJson(data);
  }

  Future<void> fetchMore() async {
    final stateValue = state.value;
    if (stateValue == null) return;
    final pagination = stateValue.pagination;
    final res = await _fetchConnected(pagination);
    if (res == null) return;
    final hasReachMax = res.data.isEmpty;
    state = AsyncData(stateValue.copyWith(
      pagination: res.pagination,
      hasReachMax: hasReachMax,
      users: [...stateValue.users, ...res.data],
      filteredUsers: [...stateValue.users, ...res.data],
    ));
  }

  void searchConnections(String search) {
    final stateValue = state.value;
    if (stateValue == null) return;
    final filtered = stateValue.users.where((element) => element.displayName.toLowerCase().contains(search.toLowerCase())).toList();
    state = AsyncData(stateValue.copyWith(filteredUsers: filtered));
  }

  void resetSearch() {
    final stateValue = state.value;
    if (stateValue == null) return;
    state = AsyncData(stateValue.copyWith(filteredUsers: stateValue.users));
  }
}
