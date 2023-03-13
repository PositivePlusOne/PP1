// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserFeedback _$$_UserFeedbackFromJson(Map<String, dynamic> json) =>
    _$_UserFeedback(
      content: json['content'] as String? ?? '',
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_UserFeedbackToJson(_$_UserFeedback instance) =>
    <String, dynamic>{
      'content': instance.content,
      '_fl_meta_': instance.flMeta,
    };
