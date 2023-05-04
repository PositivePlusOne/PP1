// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../../converters/firestore_converters.dart';

part 'activities.freezed.dart';
part 'activities.g.dart';

@freezed
class Activity with _$Activity {
  factory Activity({
    @Default('') String foreignKey,
    @Default([]) List<Media> media,
    PricingInformation? pricingInformation,
    EnrichmentConfiguration? enrichmentConfiguration,
    PublisherInformation? publisherInformation,
    GeneralConfiguration? generalConfiguration,
    EventConfiguration? eventConfiguration,
    SecurityConfiguration? securityConfiguration,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}

@freezed
class PricingInformation with _$PricingInformation {
  factory PricingInformation({
    ExternalStoreInformation? externalStoreInformation,
    @Default('') String productId,
  }) = _PricingInformation;

  factory PricingInformation.fromJson(Map<String, dynamic> json) => _$PricingInformationFromJson(json);
}

@freezed
class ExternalStoreInformation with _$ExternalStoreInformation {
  factory ExternalStoreInformation({
    @Default('') String costMaximum,
    @Default('') String pricingStrategy,
    @Default('') String costMinimum,
    @Default('') String costExact,
  }) = _ExternalStoreInformation;

  factory ExternalStoreInformation.fromJson(Map<String, dynamic> json) => _$ExternalStoreInformationFromJson(json);
}

@freezed
class EnrichmentConfiguration with _$EnrichmentConfiguration {
  factory EnrichmentConfiguration({
    @Default(false) bool isSensitive,
    @Default([]) List<dynamic> mentions,
    @Default([]) List<String> tags,
  }) = _EnrichmentConfiguration;

  factory EnrichmentConfiguration.fromJson(Map<String, dynamic> json) => _$EnrichmentConfigurationFromJson(json);
}

@freezed
class PublisherInformation with _$PublisherInformation {
  factory PublisherInformation({
    @Default(true) bool published,
    @Default('') String foreignKey,
  }) = _PublisherInformation;

  factory PublisherInformation.fromJson(Map<String, dynamic> json) => _$PublisherInformationFromJson(json);
}

@freezed
class GeneralConfiguration with _$GeneralConfiguration {
  factory GeneralConfiguration({
    @Default('') String style,
    @Default('') String type,
    @Default('') String content,
  }) = _GeneralConfiguration;

  factory GeneralConfiguration.fromJson(Map<String, dynamic> json) => _$GeneralConfigurationFromJson(json);
}

@freezed
class Media with _$Media {
  factory Media({
    @Default('') String type,
    @Default(1000) int priority,
    @Default('') String url,
  }) = _Media;

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
}

@freezed
class EventConfiguration with _$EventConfiguration {
  factory EventConfiguration({
    @Default(0) int popularityScore,
    @Default('') @JsonKey(fromJson: documentIdFromJson) String venue,
    Schedule? schedule,
    @Default(false) bool isCancelled,
    @Default('') String name,
    @Default('') String location,
  }) = _EventConfiguration;

  factory EventConfiguration.fromJson(Map<String, dynamic> json) => _$EventConfigurationFromJson(json);
}

@freezed
class Schedule with _$Schedule {
  factory Schedule({
    @Default('') String reoccuranceRule,
    @Default('') String endDate,
    @Default('') String startDate,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
}

@freezed
class SecurityConfiguration with _$SecurityConfiguration {
  factory SecurityConfiguration({
    @Default('') String reactionMode,
    @Default('') String visibilityMode,
  }) = _SecurityConfiguration;

  factory SecurityConfiguration.fromJson(Map<String, dynamic> json) => _$SecurityConfigurationFromJson(json);
}
