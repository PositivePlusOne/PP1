// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connections_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConnectedUser _$$_ConnectedUserFromJson(Map<String, dynamic> json) =>
    _$_ConnectedUser(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      profileImage: json['profileImage'] as String?,
      accentColor: json['accentColor'] as String?,
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
      'id': instance.id,
      'displayName': instance.displayName,
      'profileImage': instance.profileImage,
      'accentColor': instance.accentColor,
      'locationName': instance.locationName,
      'hivStatus': instance.hivStatus,
      'interests': instance.interests,
      'genders': instance.genders,
      'birthday': instance.birthday,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectedUsersControllerHash() =>
    r'71f99c9c63218cfbb1280228421b467ad1883560';

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
