// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Bookmark _$$_BookmarkFromJson(Map<String, dynamic> json) => _$_Bookmark(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      profile: json['profile'] == null
          ? null
          : firestoreDocRefFromJson(json['profile']),
      activity: json['activity'] == null
          ? null
          : firestoreDocRefFromJson(json['activity']),
      type: json['type'] == null
          ? const BookmarkType.post()
          : BookmarkType.fromJson(json['type'] as String),
    );

Map<String, dynamic> _$$_BookmarkToJson(_$_Bookmark instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'profile': firestoreDocRefToJson(instance.profile),
      'activity': firestoreDocRefToJson(instance.activity),
      'type': BookmarkType.toJson(instance.type),
    };
