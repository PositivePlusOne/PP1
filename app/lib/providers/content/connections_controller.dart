import 'dart:async';
import 'dart:convert';

import 'package:app/dtos/database/geo/user_location.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/services/third_party.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:geocoding/geocoding.dart';

part 'connections_controller.freezed.dart';

part 'connections_controller.g.dart';

@freezed
class ConnectedUser with _$ConnectedUser {
  const factory ConnectedUser({
    required String id,
    required String displayName,
    String? profileImage,
    String? accentColor,
    @JsonKey(fromJson: UserLocation.fromJsonSafe) UserLocation? location,
    String? locationName,
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
  }) = _ConnectedUserState;
}

@Riverpod(keepAlive: true)
class ConnectedUsersController extends _$ConnectedUsersController {
  @override
  Future<ConnectedUserState> build() async {
    return ConnectedUserState(
      users: await _fetchConnected(),
    );
  }

  Future<List<ConnectedUser>> _fetchConnected() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Updating connected relationships');

    try {
      final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
      final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-getConnectedUsers');
      final HttpsCallableResult response = await callable.call();

      logger.i('[Profile Service] - Connected relationships loaded: ${response.data}');
      final Map data = json.decodeSafe(response.data);

      if (!data.containsKey('users')) {
        logger.e('[Profile Service] - Connected relationships response is invalid: $response');
        return [];
      }
      final Iterable<dynamic> users = data['users'];
      final List<ConnectedUser> connectedUsers = await Future.wait(users.map((dynamic user) async {
        if (user is Map && user.containsKey('location') && user['location'] != null) {
          final location = UserLocation.fromJsonSafe(user['location']);
          if (location != null) {
            final placemark = await placemarkFromCoordinates(location.latitude.toDouble(), location.longitude.toDouble());
            user['locationName'] = placemark.first.locality;
          }
        }
        return ConnectedUser.fromJson(user as Map<String, dynamic>);
      }).toList());
      return connectedUsers;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
