// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connections_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConnectedUser _$$_ConnectedUserFromJson(Map<String, dynamic> json) =>
    _$_ConnectedUser(
      displayName: json['displayName'] as String,
      profileImage: json['profileImage'] as String?,
      accentColor: json['accentColor'] as String?,
      location: UserLocation.fromJsonSafe(json['location']),
      locationName: json['locationName'] as String?,
      hivStatus: json['hivStatus'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      genders:
          (json['genders'] as List<dynamic>?)?.map((e) => e as String).toList(),
      birthday: json['birthday'] as String?,
    );

Map<String, dynamic> _$$_ConnectedUserToJson(_$_ConnectedUser instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'profileImage': instance.profileImage,
      'accentColor': instance.accentColor,
      'location': instance.location?.toJson(),
      'locationName': instance.locationName,
      'hivStatus': instance.hivStatus,
      'interests': instance.interests,
      'genders': instance.genders,
      'birthday': instance.birthday,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getConnectedUsersHash() => r'2d99c728f27e5943a99683622787b7f43661fd09';

/// See also [getConnectedUsers].
@ProviderFor(getConnectedUsers)
final getConnectedUsersProvider =
    AutoDisposeFutureProvider<List<ConnectedUser>>.internal(
  getConnectedUsers,
  name: r'getConnectedUsersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getConnectedUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetConnectedUsersRef
    = AutoDisposeFutureProviderRef<List<ConnectedUser>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
