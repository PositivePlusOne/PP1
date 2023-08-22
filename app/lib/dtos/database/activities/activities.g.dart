// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Activity _$$_ActivityFromJson(Map<String, dynamic> json) => _$_Activity(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      generalConfiguration: json['generalConfiguration'] == null
          ? null
          : ActivityGeneralConfiguration.fromJson(
              json['generalConfiguration'] as Map<String, dynamic>),
      securityConfiguration: json['securityConfiguration'] == null
          ? null
          : ActivitySecurityConfiguration.fromJson(
              json['securityConfiguration'] as Map<String, dynamic>),
      eventConfiguration: json['eventConfiguration'] == null
          ? null
          : ActivityEventConfiguration.fromJson(
              json['eventConfiguration'] as Map<String, dynamic>),
      pricingInformation: json['pricingInformation'] == null
          ? null
          : ActivityPricingInformation.fromJson(
              json['pricingInformation'] as Map<String, dynamic>),
      publisherInformation: json['publisherInformation'] == null
          ? null
          : ActivityPublisherInformation.fromJson(
              json['publisherInformation'] as Map<String, dynamic>),
      enrichmentConfiguration: json['enrichmentConfiguration'] == null
          ? null
          : ActivityEnrichmentConfiguration.fromJson(
              json['enrichmentConfiguration'] as Map<String, dynamic>),
      media: json['media'] == null
          ? const []
          : Media.fromJsonList(json['media'] as List),
    );

Map<String, dynamic> _$$_ActivityToJson(_$_Activity instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'generalConfiguration': instance.generalConfiguration?.toJson(),
      'securityConfiguration': instance.securityConfiguration?.toJson(),
      'eventConfiguration': instance.eventConfiguration?.toJson(),
      'pricingInformation': instance.pricingInformation?.toJson(),
      'publisherInformation': instance.publisherInformation?.toJson(),
      'enrichmentConfiguration': instance.enrichmentConfiguration?.toJson(),
      'media': instance.media.map((e) => e.toJson()).toList(),
    };

_$_ActivityGeneralConfiguration _$$_ActivityGeneralConfigurationFromJson(
        Map<String, dynamic> json) =>
    _$_ActivityGeneralConfiguration(
      type: json['type'] == null
          ? const ActivityGeneralConfigurationType.post()
          : ActivityGeneralConfigurationType.fromJson(json['type'] as String),
      reactionType: json['reactionType'] == null
          ? const ActivityGeneralConfigurationType.post()
          : ActivityGeneralConfigurationType.fromJson(
              json['reactionType'] as String),
      style: json['style'] == null
          ? const ActivityGeneralConfigurationStyle.text()
          : ActivityGeneralConfigurationStyle.fromJson(json['style'] as String),
      content: json['content'] as String? ?? '',
    );

Map<String, dynamic> _$$_ActivityGeneralConfigurationToJson(
        _$_ActivityGeneralConfiguration instance) =>
    <String, dynamic>{
      'type': ActivityGeneralConfigurationType.toJson(instance.type),
      'reactionType':
          ActivityGeneralConfigurationType.toJson(instance.reactionType),
      'style': ActivityGeneralConfigurationStyle.toJson(instance.style),
      'content': instance.content,
    };

_$_ActivitySecurityConfiguration _$$_ActivitySecurityConfigurationFromJson(
        Map<String, dynamic> json) =>
    _$_ActivitySecurityConfiguration(
      context: json['context'] as String? ?? '',
      viewMode: json['viewMode'] == null
          ? const ActivitySecurityConfigurationMode.private()
          : ActivitySecurityConfigurationMode.fromJson(
              json['viewMode'] as String),
      commentMode: json['commentMode'] == null
          ? const ActivitySecurityConfigurationMode.private()
          : ActivitySecurityConfigurationMode.fromJson(
              json['commentMode'] as String),
      shareMode: json['shareMode'] == null
          ? const ActivitySecurityConfigurationMode.private()
          : ActivitySecurityConfigurationMode.fromJson(
              json['shareMode'] as String),
    );

Map<String, dynamic> _$$_ActivitySecurityConfigurationToJson(
        _$_ActivitySecurityConfiguration instance) =>
    <String, dynamic>{
      'context': instance.context,
      'viewMode': ActivitySecurityConfigurationMode.toJson(instance.viewMode),
      'commentMode':
          ActivitySecurityConfigurationMode.toJson(instance.commentMode),
      'shareMode': ActivitySecurityConfigurationMode.toJson(instance.shareMode),
    };

_$_ActivityEventConfiguration _$$_ActivityEventConfigurationFromJson(
        Map<String, dynamic> json) =>
    _$_ActivityEventConfiguration(
      venue: json['venue'],
      name: json['name'] as String? ?? '',
      schedule: json['schedule'] == null
          ? null
          : ActivitySchedule.fromJson(json['schedule'] as Map<String, dynamic>),
      location: json['location'] as String? ?? '',
      popularityScore: json['popularityScore'] as int? ?? 0,
      isCancelled: json['isCancelled'] as bool? ?? false,
    );

Map<String, dynamic> _$$_ActivityEventConfigurationToJson(
        _$_ActivityEventConfiguration instance) =>
    <String, dynamic>{
      'venue': instance.venue,
      'name': instance.name,
      'schedule': instance.schedule?.toJson(),
      'location': instance.location,
      'popularityScore': instance.popularityScore,
      'isCancelled': instance.isCancelled,
    };

_$_ActivitySchedule _$$_ActivityScheduleFromJson(Map<String, dynamic> json) =>
    _$_ActivitySchedule(
      recurrenceRule: json['recurrenceRule'] as String? ?? '',
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$$_ActivityScheduleToJson(_$_ActivitySchedule instance) =>
    <String, dynamic>{
      'recurrenceRule': instance.recurrenceRule,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
    };

_$_ActivityPricingInformation _$$_ActivityPricingInformationFromJson(
        Map<String, dynamic> json) =>
    _$_ActivityPricingInformation(
      productId: json['productId'] as String? ?? '',
      externalStoreInformation: json['externalStoreInformation'] == null
          ? null
          : ActivityPricingExternalStoreInformation.fromJson(
              json['externalStoreInformation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ActivityPricingInformationToJson(
        _$_ActivityPricingInformation instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'externalStoreInformation': instance.externalStoreInformation?.toJson(),
    };

_$_ActivityPricingExternalStoreInformation
    _$$_ActivityPricingExternalStoreInformationFromJson(
            Map<String, dynamic> json) =>
        _$_ActivityPricingExternalStoreInformation(
          costExact: json['costExact'] as String? ?? '',
          costMinimum: json['costMinimum'] as String? ?? '',
          costMaximum: json['costMaximum'] as String? ?? '',
          pricingStrategy: json['pricingStrategy'] == null
              ? const ActivityPricingExternalStoreInformationPricingStrategy
                  .onePerson()
              : ActivityPricingExternalStoreInformationPricingStrategy.fromJson(
                  json['pricingStrategy'] as String),
        );

Map<String, dynamic> _$$_ActivityPricingExternalStoreInformationToJson(
        _$_ActivityPricingExternalStoreInformation instance) =>
    <String, dynamic>{
      'costExact': instance.costExact,
      'costMinimum': instance.costMinimum,
      'costMaximum': instance.costMaximum,
      'pricingStrategy':
          ActivityPricingExternalStoreInformationPricingStrategy.toJson(
              instance.pricingStrategy),
    };

_$_ActivityPublisherInformation _$$_ActivityPublisherInformationFromJson(
        Map<String, dynamic> json) =>
    _$_ActivityPublisherInformation(
      originFeed: json['originFeed'] as String? ?? '',
      publisherId: json['publisherId'] as String? ?? '',
      actorId: json['actorId'] as String? ?? '',
    );

Map<String, dynamic> _$$_ActivityPublisherInformationToJson(
        _$_ActivityPublisherInformation instance) =>
    <String, dynamic>{
      'originFeed': instance.originFeed,
      'publisherId': instance.publisherId,
      'actorId': instance.actorId,
    };

_$_ActivityEnrichmentConfiguration _$$_ActivityEnrichmentConfigurationFromJson(
        Map<String, dynamic> json) =>
    _$_ActivityEnrichmentConfiguration(
      title: json['title'] as String? ?? '',
      tags: json['tags'] == null ? const [] : stringListFromJson(json['tags']),
      isSensitive: json['isSensitive'] as bool? ?? false,
      publishLocation: json['publishLocation'] as String? ?? '',
      mentions: json['mentions'] == null
          ? const []
          : Mention.fromJsonList(json['mentions'] as List),
      reactionCounts: (json['reactionCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          const {},
    );

Map<String, dynamic> _$$_ActivityEnrichmentConfigurationToJson(
        _$_ActivityEnrichmentConfiguration instance) =>
    <String, dynamic>{
      'title': instance.title,
      'tags': instance.tags,
      'isSensitive': instance.isSensitive,
      'publishLocation': instance.publishLocation,
      'mentions': Mention.toJsonList(instance.mentions),
      'reactionCounts': instance.reactionCounts,
    };
