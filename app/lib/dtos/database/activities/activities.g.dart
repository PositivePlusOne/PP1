// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Activity _$$_ActivityFromJson(Map<String, dynamic> json) => _$_Activity(
      foreignKey: json['foreignKey'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pricingInformation: json['pricingInformation'] == null
          ? null
          : PricingInformation.fromJson(
              json['pricingInformation'] as Map<String, dynamic>),
      enrichmentConfiguration: json['enrichmentConfiguration'] == null
          ? null
          : EnrichmentConfiguration.fromJson(
              json['enrichmentConfiguration'] as Map<String, dynamic>),
      publisherInformation: json['publisherInformation'] == null
          ? null
          : PublisherInformation.fromJson(
              json['publisherInformation'] as Map<String, dynamic>),
      generalConfiguration: json['generalConfiguration'] == null
          ? null
          : GeneralConfiguration.fromJson(
              json['generalConfiguration'] as Map<String, dynamic>),
      eventConfiguration: json['eventConfiguration'] == null
          ? null
          : EventConfiguration.fromJson(
              json['eventConfiguration'] as Map<String, dynamic>),
      securityConfiguration: json['securityConfiguration'] == null
          ? null
          : SecurityConfiguration.fromJson(
              json['securityConfiguration'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ActivityToJson(_$_Activity instance) =>
    <String, dynamic>{
      'foreignKey': instance.foreignKey,
      'media': instance.media.map((e) => e.toJson()).toList(),
      'pricingInformation': instance.pricingInformation?.toJson(),
      'enrichmentConfiguration': instance.enrichmentConfiguration?.toJson(),
      'publisherInformation': instance.publisherInformation?.toJson(),
      'generalConfiguration': instance.generalConfiguration?.toJson(),
      'eventConfiguration': instance.eventConfiguration?.toJson(),
      'securityConfiguration': instance.securityConfiguration?.toJson(),
    };

_$_PricingInformation _$$_PricingInformationFromJson(
        Map<String, dynamic> json) =>
    _$_PricingInformation(
      externalStoreInformation: json['externalStoreInformation'] == null
          ? null
          : ExternalStoreInformation.fromJson(
              json['externalStoreInformation'] as Map<String, dynamic>),
      productId: json['productId'] as String? ?? '',
    );

Map<String, dynamic> _$$_PricingInformationToJson(
        _$_PricingInformation instance) =>
    <String, dynamic>{
      'externalStoreInformation': instance.externalStoreInformation?.toJson(),
      'productId': instance.productId,
    };

_$_ExternalStoreInformation _$$_ExternalStoreInformationFromJson(
        Map<String, dynamic> json) =>
    _$_ExternalStoreInformation(
      costMaximum: json['costMaximum'] as String? ?? '',
      pricingStrategy: json['pricingStrategy'] as String? ?? '',
      costMinimum: json['costMinimum'] as String? ?? '',
      costExact: json['costExact'] as String? ?? '',
    );

Map<String, dynamic> _$$_ExternalStoreInformationToJson(
        _$_ExternalStoreInformation instance) =>
    <String, dynamic>{
      'costMaximum': instance.costMaximum,
      'pricingStrategy': instance.pricingStrategy,
      'costMinimum': instance.costMinimum,
      'costExact': instance.costExact,
    };

_$_EnrichmentConfiguration _$$_EnrichmentConfigurationFromJson(
        Map<String, dynamic> json) =>
    _$_EnrichmentConfiguration(
      isSensitive: json['isSensitive'] as bool? ?? false,
      mentions: json['mentions'] as List<dynamic>? ?? const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$_EnrichmentConfigurationToJson(
        _$_EnrichmentConfiguration instance) =>
    <String, dynamic>{
      'isSensitive': instance.isSensitive,
      'mentions': instance.mentions,
      'tags': instance.tags,
    };

_$_PublisherInformation _$$_PublisherInformationFromJson(
        Map<String, dynamic> json) =>
    _$_PublisherInformation(
      published: json['published'] as bool? ?? true,
      foreignKey: json['foreignKey'] as String? ?? '',
    );

Map<String, dynamic> _$$_PublisherInformationToJson(
        _$_PublisherInformation instance) =>
    <String, dynamic>{
      'published': instance.published,
      'foreignKey': instance.foreignKey,
    };

_$_GeneralConfiguration _$$_GeneralConfigurationFromJson(
        Map<String, dynamic> json) =>
    _$_GeneralConfiguration(
      style: json['style'] as String? ?? '',
      type: json['type'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );

Map<String, dynamic> _$$_GeneralConfigurationToJson(
        _$_GeneralConfiguration instance) =>
    <String, dynamic>{
      'style': instance.style,
      'type': instance.type,
      'content': instance.content,
    };

_$_Media _$$_MediaFromJson(Map<String, dynamic> json) => _$_Media(
      type: json['type'] as String? ?? '',
      priority: json['priority'] as int? ?? 1000,
      url: json['url'] as String? ?? '',
    );

Map<String, dynamic> _$$_MediaToJson(_$_Media instance) => <String, dynamic>{
      'type': instance.type,
      'priority': instance.priority,
      'url': instance.url,
    };

_$_EventConfiguration _$$_EventConfigurationFromJson(
        Map<String, dynamic> json) =>
    _$_EventConfiguration(
      popularityScore: json['popularityScore'] as int? ?? 0,
      venue: json['venue'] as String? ?? '',
      schedule: json['schedule'] == null
          ? null
          : Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
      isCancelled: json['isCancelled'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );

Map<String, dynamic> _$$_EventConfigurationToJson(
        _$_EventConfiguration instance) =>
    <String, dynamic>{
      'popularityScore': instance.popularityScore,
      'venue': instance.venue,
      'schedule': instance.schedule?.toJson(),
      'isCancelled': instance.isCancelled,
      'name': instance.name,
      'location': instance.location,
    };

_$_Schedule _$$_ScheduleFromJson(Map<String, dynamic> json) => _$_Schedule(
      reoccuranceRule: json['reoccuranceRule'] as String? ?? '',
      endDate: json['endDate'] as Map<String, dynamic>? ?? const {},
      startDate: json['startDate'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$_ScheduleToJson(_$_Schedule instance) =>
    <String, dynamic>{
      'reoccuranceRule': instance.reoccuranceRule,
      'endDate': instance.endDate,
      'startDate': instance.startDate,
    };

_$_SecurityConfiguration _$$_SecurityConfigurationFromJson(
        Map<String, dynamic> json) =>
    _$_SecurityConfiguration(
      reactionMode: json['reactionMode'] as String? ?? '',
      visibilityMode: json['visibilityMode'] as String? ?? '',
    );

Map<String, dynamic> _$$_SecurityConfigurationToJson(
        _$_SecurityConfiguration instance) =>
    <String, dynamic>{
      'reactionMode': instance.reactionMode,
      'visibilityMode': instance.visibilityMode,
    };
