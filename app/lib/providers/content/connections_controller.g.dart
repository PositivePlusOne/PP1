// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connections_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConnectedUserResult _$$_ConnectedUserResultFromJson(
        Map<String, dynamic> json) =>
    _$_ConnectedUserResult(
      data: (json['data'] as List<dynamic>)
          .map((e) => ConnectedUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ConnectedUserResultToJson(
        _$_ConnectedUserResult instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };

_$_ConnectedUser _$$_ConnectedUserFromJson(Map<String, dynamic> json) =>
    _$_ConnectedUser(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      place: PositivePlace.fromJson(json['place'] as Map<String, Object?>),
      profileImage: json['profileImage'] as String?,
      accentColor: json['accentColor'] as String?,
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
      'id': instance.id,
      'displayName': instance.displayName,
      'place': instance.place?.toJson(),
      'profileImage': instance.profileImage,
      'accentColor': instance.accentColor,
      'hivStatus': instance.hivStatus,
      'interests': instance.interests,
      'genders': instance.genders,
      'birthday': instance.birthday,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectedUsersControllerHash() =>
    r'09a36464930a41d53212b0e59fe6f2560867d457';

/// See also [ConnectedUsersController].
@ProviderFor(ConnectedUsersController)
final connectedUsersControllerProvider = AsyncNotifierProvider<
    ConnectedUsersController, ConnectedUserState>.internal(
  ConnectedUsersController.new,
  name: r'connectedUsersControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectedUsersControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConnectedUsersController = AsyncNotifier<ConnectedUserState>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
