// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as String,
      hasCreatedProfile: json['has_created_profile'] as bool,
      publicData: json['public_data'] as Map<String, dynamic>? ?? const {},
      privateData: json['private_data'] as Map<String, dynamic>? ?? const {},
      systemData: json['system_data'] as Map<String, dynamic>? ?? const {},
      authProviders: (json['auth_providers'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$UserAuthProviderEnumMap, e))
              .toList() ??
          const <UserAuthProvider>[],
      notificationPreferences:
          (json['notification_preferences'] as List<dynamic>?)
                  ?.map((e) => $enumDecode(_$NotificationPreferenceEnumMap, e))
                  .toList() ??
              const <NotificationPreference>[],
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'has_created_profile': instance.hasCreatedProfile,
      'public_data': instance.publicData,
      'private_data': instance.privateData,
      'system_data': instance.systemData,
      'auth_providers': instance.authProviders
          .map((e) => _$UserAuthProviderEnumMap[e]!)
          .toList(),
      'notification_preferences': instance.notificationPreferences
          .map((e) => _$NotificationPreferenceEnumMap[e]!)
          .toList(),
    };

const _$UserAuthProviderEnumMap = {
  UserAuthProvider.google: 'google',
  UserAuthProvider.apple: 'apple',
  UserAuthProvider.facebook: 'facebook',
  UserAuthProvider.email: 'email',
};

const _$NotificationPreferenceEnumMap = {
  NotificationPreference.postLikes: 'postLikes',
  NotificationPreference.newFollowers: 'newFollowers',
  NotificationPreference.connectionRequests: 'connectionRequests',
  NotificationPreference.newComments: 'newComments',
  NotificationPreference.postBookmarks: 'postBookmarks',
  NotificationPreference.postShares: 'postShares',
};
