// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FeedbackWrapper _$$_FeedbackWrapperFromJson(Map<String, dynamic> json) =>
    _$_FeedbackWrapper(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      feedbackType: json['feedbackType'] == null
          ? const FeedbackType.unknown()
          : FeedbackType.fromJson(json['feedbackType'] as String),
      reportType: json['reportType'] == null
          ? const ReportType.unknown()
          : ReportType.fromJson(json['reportType'] as String),
      content: json['content'] as String? ?? '',
    );

Map<String, dynamic> _$$_FeedbackWrapperToJson(_$_FeedbackWrapper instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'feedbackType': FeedbackType.toJson(instance.feedbackType),
      'reportType': ReportType.toJson(instance.reportType),
      'content': instance.content,
    };
