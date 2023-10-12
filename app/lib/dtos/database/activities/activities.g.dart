// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityImpl _$$ActivityImplFromJson(Map<String, dynamic> json) =>
    _$ActivityImpl(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      searchDescription: json['searchDescription'] as String? ?? '',
      generalConfiguration: json['generalConfiguration'] == null
          ? null
          : ActivityGeneralConfiguration.fromJson(
              json['generalConfiguration'] as Map<String, dynamic>),
      repostConfiguration: json['repostConfiguration'] == null
          ? null
          : ActivityRepostConfiguration.fromJson(
              json['repostConfiguration'] as Map<String, dynamic>),
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

Map<String, dynamic> _$$ActivityImplToJson(_$ActivityImpl instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'searchDescription': instance.searchDescription,
      'generalConfiguration': instance.generalConfiguration?.toJson(),
      'repostConfiguration': instance.repostConfiguration?.toJson(),
      'securityConfiguration': instance.securityConfiguration?.toJson(),
      'eventConfiguration': instance.eventConfiguration?.toJson(),
      'pricingInformation': instance.pricingInformation?.toJson(),
      'publisherInformation': instance.publisherInformation?.toJson(),
      'enrichmentConfiguration': instance.enrichmentConfiguration?.toJson(),
      'media': instance.media.map((e) => e.toJson()).toList(),
    };

_$ActivityRepostConfigurationImpl _$$ActivityRepostConfigurationImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivityRepostConfigurationImpl(
      targetActivityId: json['targetActivityId'] as String? ?? '',
      targetActivityPublisherId:
          json['targetActivityPublisherId'] as String? ?? '',
      targetActivityOriginFeed:
          json['targetActivityOriginFeed'] as String? ?? '',
    );

Map<String, dynamic> _$$ActivityRepostConfigurationImplToJson(
        _$ActivityRepostConfigurationImpl instance) =>
    <String, dynamic>{
      'targetActivityId': instance.targetActivityId,
      'targetActivityPublisherId': instance.targetActivityPublisherId,
      'targetActivityOriginFeed': instance.targetActivityOriginFeed,
    };

_$ActivityGeneralConfigurationImpl _$$ActivityGeneralConfigurationImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivityGeneralConfigurationImpl(
      type: json['type'] == null
          ? const ActivityGeneralConfigurationType.post()
          : ActivityGeneralConfigurationType.fromJson(json['type'] as String),
      style: json['style'] == null
          ? const ActivityGeneralConfigurationStyle.text()
          : ActivityGeneralConfigurationStyle.fromJson(json['style'] as String),
      content: json['content'] as String? ?? '',
      isSensitive: json['isSensitive'] as bool? ?? false,
    );

Map<String, dynamic> _$$ActivityGeneralConfigurationImplToJson(
        _$ActivityGeneralConfigurationImpl instance) =>
    <String, dynamic>{
      'type': ActivityGeneralConfigurationType.toJson(instance.type),
      'style': ActivityGeneralConfigurationStyle.toJson(instance.style),
      'content': instance.content,
      'isSensitive': instance.isSensitive,
    };

_$ActivitySecurityConfigurationImpl
    _$$ActivitySecurityConfigurationImplFromJson(Map<String, dynamic> json) =>
        _$ActivitySecurityConfigurationImpl(
          context: json['context'] as String? ?? '',
          viewMode: json['viewMode'] == null
              ? const ActivitySecurityConfigurationMode.private()
              : ActivitySecurityConfigurationMode.fromJson(
                  json['viewMode'] as String),
          commentMode: json['commentMode'] == null
              ? const ActivitySecurityConfigurationMode.signedIn()
              : ActivitySecurityConfigurationMode.fromJson(
                  json['commentMode'] as String),
          shareMode: json['shareMode'] == null
              ? const ActivitySecurityConfigurationMode.private()
              : ActivitySecurityConfigurationMode.fromJson(
                  json['shareMode'] as String),
        );

Map<String, dynamic> _$$ActivitySecurityConfigurationImplToJson(
        _$ActivitySecurityConfigurationImpl instance) =>
    <String, dynamic>{
      'context': instance.context,
      'viewMode': ActivitySecurityConfigurationMode.toJson(instance.viewMode),
      'commentMode':
          ActivitySecurityConfigurationMode.toJson(instance.commentMode),
      'shareMode': ActivitySecurityConfigurationMode.toJson(instance.shareMode),
    };

_$ActivityEventConfigurationImpl _$$ActivityEventConfigurationImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivityEventConfigurationImpl(
      venue: json['venue'],
      name: json['name'] as String? ?? '',
      schedule: json['schedule'] == null
          ? null
          : ActivitySchedule.fromJson(json['schedule'] as Map<String, dynamic>),
      location: json['location'] as String? ?? '',
      popularityScore: json['popularityScore'] as int? ?? 0,
      isCancelled: json['isCancelled'] as bool? ?? false,
    );

Map<String, dynamic> _$$ActivityEventConfigurationImplToJson(
        _$ActivityEventConfigurationImpl instance) =>
    <String, dynamic>{
      'venue': instance.venue,
      'name': instance.name,
      'schedule': instance.schedule?.toJson(),
      'location': instance.location,
      'popularityScore': instance.popularityScore,
      'isCancelled': instance.isCancelled,
    };

_$ActivityScheduleImpl _$$ActivityScheduleImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivityScheduleImpl(
      recurrenceRule: json['recurrenceRule'] as String? ?? '',
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$$ActivityScheduleImplToJson(
        _$ActivityScheduleImpl instance) =>
    <String, dynamic>{
      'recurrenceRule': instance.recurrenceRule,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
    };

_$ActivityPricingInformationImpl _$$ActivityPricingInformationImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivityPricingInformationImpl(
      productId: json['productId'] as String? ?? '',
      externalStoreInformation: json['externalStoreInformation'] == null
          ? null
          : ActivityPricingExternalStoreInformation.fromJson(
              json['externalStoreInformation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ActivityPricingInformationImplToJson(
        _$ActivityPricingInformationImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'externalStoreInformation': instance.externalStoreInformation?.toJson(),
    };

_$ActivityPricingExternalStoreInformationImpl
    _$$ActivityPricingExternalStoreInformationImplFromJson(
            Map<String, dynamic> json) =>
        _$ActivityPricingExternalStoreInformationImpl(
          costExact: json['costExact'] as String? ?? '',
          costMinimum: json['costMinimum'] as String? ?? '',
          costMaximum: json['costMaximum'] as String? ?? '',
          pricingStrategy: json['pricingStrategy'] == null
              ? const ActivityPricingExternalStoreInformationPricingStrategy
                  .onePerson()
              : ActivityPricingExternalStoreInformationPricingStrategy.fromJson(
                  json['pricingStrategy'] as String),
        );

Map<String, dynamic> _$$ActivityPricingExternalStoreInformationImplToJson(
        _$ActivityPricingExternalStoreInformationImpl instance) =>
    <String, dynamic>{
      'costExact': instance.costExact,
      'costMinimum': instance.costMinimum,
      'costMaximum': instance.costMaximum,
      'pricingStrategy':
          ActivityPricingExternalStoreInformationPricingStrategy.toJson(
              instance.pricingStrategy),
    };

_$ActivityPublisherInformationImpl _$$ActivityPublisherInformationImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivityPublisherInformationImpl(
      originFeed: json['originFeed'] as String? ?? '',
      publisherId: json['publisherId'] as String? ?? '',
    );

Map<String, dynamic> _$$ActivityPublisherInformationImplToJson(
        _$ActivityPublisherInformationImpl instance) =>
    <String, dynamic>{
      'originFeed': instance.originFeed,
      'publisherId': instance.publisherId,
    };

_$ActivityEnrichmentConfigurationImpl
    _$$ActivityEnrichmentConfigurationImplFromJson(Map<String, dynamic> json) =>
        _$ActivityEnrichmentConfigurationImpl(
          tags: json['tags'] == null
              ? const []
              : stringListFromJson(json['tags']),
          promotionKey: json['promotionKey'] as String? ?? '',
          publishLocation: json['publishLocation'] as String? ?? '',
          mentions: json['mentions'] == null
              ? const []
              : Mention.fromJsonList(json['mentions'] as List),
        );

Map<String, dynamic> _$$ActivityEnrichmentConfigurationImplToJson(
        _$ActivityEnrichmentConfigurationImpl instance) =>
    <String, dynamic>{
      'tags': instance.tags,
      'promotionKey': instance.promotionKey,
      'publishLocation': instance.publishLocation,
      'mentions': Mention.toJsonList(instance.mentions),
    };
