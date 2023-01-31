// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ContentState _$$_ContentStateFromJson(Map<String, dynamic> json) =>
    _$_ContentState(
      recommendedContent: (json['recommended_content'] as List<dynamic>)
          .map((e) => RecommendedContent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_ContentStateToJson(_$_ContentState instance) =>
    <String, dynamic>{
      'recommended_content': instance.recommendedContent,
    };
