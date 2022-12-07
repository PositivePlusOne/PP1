// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      emailAddress: json['email_address'] as String,
      hasCreatedProfile: json['has_created_profile'] as bool,
      authProviders: (json['auth_providers'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$UserAuthProviderEnumMap, e))
              .toList() ??
          const <UserAuthProvider>[],
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'email_address': instance.emailAddress,
      'has_created_profile': instance.hasCreatedProfile,
      'auth_providers': instance.authProviders
          .map((e) => _$UserAuthProviderEnumMap[e]!)
          .toList(),
    };

const _$UserAuthProviderEnumMap = {
  UserAuthProvider.google: 'google',
  UserAuthProvider.apple: 'apple',
  UserAuthProvider.facebook: 'facebook',
  UserAuthProvider.email: 'email',
};
