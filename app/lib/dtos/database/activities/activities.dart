// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/converters/profile_converters.dart';
import 'package:app/dtos/database/activities/mentions.dart';
import 'package:app/dtos/database/common/fl_meta.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/extensions/json_extensions.dart';

part 'activities.freezed.dart';
part 'activities.g.dart';

@freezed
class Activity with _$Activity {
  const factory Activity({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default('') String searchDescription,
    ActivityGeneralConfiguration? generalConfiguration,
    ActivityRepostConfiguration? repostConfiguration,
    ActivitySecurityConfiguration? securityConfiguration,
    ActivityEventConfiguration? eventConfiguration,
    ActivityPricingInformation? pricingInformation,
    ActivityPublisherInformation? publisherInformation,
    ActivityEnrichmentConfiguration? enrichmentConfiguration,
    @JsonKey(fromJson: Media.fromJsonList) @Default([]) List<Media> media,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}

@freezed
class ActivityRepostConfiguration with _$ActivityRepostConfiguration {
  const factory ActivityRepostConfiguration({
    @Default('') String targetActivityId,
    @Default('') String targetActivityPublisherId,
    @Default('') String targetActivityOriginFeed,
  }) = _ActivityRepostConfiguration;

  factory ActivityRepostConfiguration.fromJson(Map<String, dynamic> json) => _$ActivityRepostConfigurationFromJson(json);
}

@freezed
class ActivityGeneralConfiguration with _$ActivityGeneralConfiguration {
  const factory ActivityGeneralConfiguration({
    @Default(ActivityGeneralConfigurationType.post()) @JsonKey(fromJson: ActivityGeneralConfigurationType.fromJson, toJson: ActivityGeneralConfigurationType.toJson) ActivityGeneralConfigurationType type,
    @Default(ActivityGeneralConfigurationStyle.text()) @JsonKey(fromJson: ActivityGeneralConfigurationStyle.fromJson, toJson: ActivityGeneralConfigurationStyle.toJson) ActivityGeneralConfigurationStyle style,
    @Default('') String content,
    @Default(false) bool isSensitive,
  }) = _ActivityGeneralConfiguration;

  factory ActivityGeneralConfiguration.fromJson(Map<String, dynamic> json) => _$ActivityGeneralConfigurationFromJson(json);
}

@freezed
class ActivityGeneralConfigurationType with _$ActivityGeneralConfigurationType {
  const factory ActivityGeneralConfigurationType.post() = _ActivityGeneralConfigurationTypePost;
  const factory ActivityGeneralConfigurationType.event() = _ActivityGeneralConfigurationTypeEvent;
  const factory ActivityGeneralConfigurationType.clip() = _ActivityGeneralConfigurationTypeClip;
  const factory ActivityGeneralConfigurationType.repost() = _ActivityGeneralConfigurationTypeRepost;

  static String toJson(ActivityGeneralConfigurationType type) {
    return type.when(
      post: () => 'post',
      event: () => 'event',
      clip: () => 'clip',
      repost: () => 'repost',
    );
  }

  factory ActivityGeneralConfigurationType.fromJson(String value) {
    switch (value) {
      case 'post':
        return const _ActivityGeneralConfigurationTypePost();
      case 'event':
        return const _ActivityGeneralConfigurationTypeEvent();
      case 'clip':
        return const _ActivityGeneralConfigurationTypeClip();
      case 'repost':
        return const _ActivityGeneralConfigurationTypeRepost();
      default:
        throw ArgumentError('Invalid value for ActivityGeneralConfigurationType: $value');
    }
  }
}

@freezed
class ActivityGeneralConfigurationStyle with _$ActivityGeneralConfigurationStyle {
  const factory ActivityGeneralConfigurationStyle.markdown() = _ActivityGeneralConfigurationStyleMarkdown;
  const factory ActivityGeneralConfigurationStyle.text() = _ActivityGeneralConfigurationStyleText;

  static String toJson(ActivityGeneralConfigurationStyle style) {
    return style.when(
      markdown: () => 'markdown',
      text: () => 'text',
    );
  }

  factory ActivityGeneralConfigurationStyle.fromJson(String value) {
    switch (value) {
      case 'markdown':
        return const _ActivityGeneralConfigurationStyleMarkdown();
      case 'text':
        return const _ActivityGeneralConfigurationStyleText();
      default:
        throw ArgumentError('Invalid value for ActivityGeneralConfigurationStyle: $value');
    }
  }
}

@freezed
class ActivitySecurityConfiguration with _$ActivitySecurityConfiguration {
  const factory ActivitySecurityConfiguration({
    @Default('') String context,
    @Default(ActivitySecurityConfigurationMode.private()) @JsonKey(fromJson: ActivitySecurityConfigurationMode.fromJson, toJson: ActivitySecurityConfigurationMode.toJson) ActivitySecurityConfigurationMode viewMode,
    @Default(ActivitySecurityConfigurationMode.signedIn()) @JsonKey(fromJson: ActivitySecurityConfigurationMode.fromJson, toJson: ActivitySecurityConfigurationMode.toJson) ActivitySecurityConfigurationMode commentMode,
    @Default(ActivitySecurityConfigurationMode.private()) @JsonKey(fromJson: ActivitySecurityConfigurationMode.fromJson, toJson: ActivitySecurityConfigurationMode.toJson) ActivitySecurityConfigurationMode shareMode,
  }) = _ActivitySecurityConfiguration;

  factory ActivitySecurityConfiguration.fromJson(Map<String, dynamic> json) => _$ActivitySecurityConfigurationFromJson(json);
}

@freezed
class ActivitySecurityConfigurationMode with _$ActivitySecurityConfigurationMode {
  const factory ActivitySecurityConfigurationMode.public() = _ActivitySecurityConfigurationModePublic;
  const factory ActivitySecurityConfigurationMode.followersAndConnections() = _ActivitySecurityConfigurationModeFollowersAndConnections;
  const factory ActivitySecurityConfigurationMode.connections() = _ActivitySecurityConfigurationModeConnections;
  const factory ActivitySecurityConfigurationMode.private() = _ActivitySecurityConfigurationModePrivate;
  const factory ActivitySecurityConfigurationMode.signedIn() = _ActivitySecurityConfigurationModeSignedIn;
  const factory ActivitySecurityConfigurationMode.disabled() = _ActivitySecurityConfigurationModeDisabled;

  static String toJson(ActivitySecurityConfigurationMode mode) {
    return mode.when(
      public: () => 'public',
      followersAndConnections: () => 'followers_and_connections',
      connections: () => 'connections',
      private: () => 'private',
      signedIn: () => 'signed_in',
      disabled: () => 'disabled',
    );
  }

  static Iterable<ActivitySecurityConfigurationMode> values = const [
    ActivitySecurityConfigurationMode.public(),
    ActivitySecurityConfigurationMode.followersAndConnections(),
    ActivitySecurityConfigurationMode.connections(),
    ActivitySecurityConfigurationMode.private(),
    ActivitySecurityConfigurationMode.signedIn(),
    ActivitySecurityConfigurationMode.disabled(),
  ];

  static String toLocale(ActivitySecurityConfigurationMode mode, AppLocalizations localisations) {
    return mode.when(
      public: () => localisations.shared_user_type_generic_everyone,
      followersAndConnections: () => localisations.shared_user_type_generic_followers,
      connections: () => localisations.shared_user_type_generic_connections,
      private: () => localisations.shared_user_type_generic_me,
      signedIn: () => localisations.shared_user_type_generic_signed_in,
      disabled: () => localisations.shared_user_type_generic_disabled,
    );
  }

  static List<ActivitySecurityConfigurationMode> get orderedVisibilityModes {
    return <ActivitySecurityConfigurationMode>[
      const ActivitySecurityConfigurationMode.public(),
      const ActivitySecurityConfigurationMode.signedIn(),
      const ActivitySecurityConfigurationMode.connections(),
      const ActivitySecurityConfigurationMode.followersAndConnections(),
      const ActivitySecurityConfigurationMode.private(),
    ];
  }

  static String toVisibilityLocale(ActivitySecurityConfigurationMode mode, AppLocalizations localisations) {
    return mode.when(
      public: () => 'Everyone',
      followersAndConnections: () => 'Followers',
      connections: () => 'Connections',
      private: () => 'Only Me',
      signedIn: () => 'Signed in Users',
      disabled: () => 'Disabled',
    );
  }

  static List<ActivitySecurityConfigurationMode> get orderedCommentModes {
    return <ActivitySecurityConfigurationMode>[
      const ActivitySecurityConfigurationMode.public(),
      const ActivitySecurityConfigurationMode.signedIn(),
      const ActivitySecurityConfigurationMode.connections(),
      const ActivitySecurityConfigurationMode.followersAndConnections(),
      // const ActivitySecurityConfigurationMode.private(),
      const ActivitySecurityConfigurationMode.disabled(),
    ];
  }

  static String toCommentLocale(ActivitySecurityConfigurationMode mode, AppLocalizations localisations) {
    return mode.when(
      public: () => 'Everyone',
      followersAndConnections: () => 'Followers',
      connections: () => 'Connections',
      private: () => 'Only Me',
      signedIn: () => 'Signed in Users',
      disabled: () => 'Disabled',
    );
  }

  factory ActivitySecurityConfigurationMode.fromJson(String value) {
    switch (value) {
      case 'public':
        return const _ActivitySecurityConfigurationModePublic();
      case 'followers_and_connections':
        return const _ActivitySecurityConfigurationModeFollowersAndConnections();
      case 'connections':
        return const _ActivitySecurityConfigurationModeConnections();
      case 'private':
        return const _ActivitySecurityConfigurationModePrivate();
      case 'signed_in':
        return const _ActivitySecurityConfigurationModeSignedIn();
      case 'disabled':
        return const _ActivitySecurityConfigurationModeDisabled();
      default:
        throw ArgumentError('Invalid value for ActivitySecurityConfigurationMode: $value');
    }
  }
}

@freezed
class ActivityEventConfiguration with _$ActivityEventConfiguration {
  const factory ActivityEventConfiguration({
    dynamic venue,
    @Default('') String name,
    ActivitySchedule? schedule,
    @Default('') String location,
    @Default(0) int popularityScore,
    @Default(false) bool isCancelled,
  }) = _ActivityEventConfiguration;

  factory ActivityEventConfiguration.fromJson(Map<String, dynamic> json) => _$ActivityEventConfigurationFromJson(json);
}

@freezed
class ActivitySchedule with _$ActivitySchedule {
  const factory ActivitySchedule({
    @Default('') String recurrenceRule,
    DateTime? start,
    DateTime? end,
  }) = _ActivitySchedule;

  static List<ActivitySchedule> fromJsonSchedules(String data) {
    return (jsonDecode(data) as List<dynamic>).map((e) => ActivitySchedule.fromJson(json.decodeSafe(e))).toList();
  }

  factory ActivitySchedule.fromJson(Map<String, dynamic> json) => _$ActivityScheduleFromJson(json);
}

@freezed
class ActivityPricingInformation with _$ActivityPricingInformation {
  const factory ActivityPricingInformation({
    @Default('') String productId,
    ActivityPricingExternalStoreInformation? externalStoreInformation,
  }) = _ActivityPricingInformation;

  factory ActivityPricingInformation.fromJson(Map<String, dynamic> json) => _$ActivityPricingInformationFromJson(json);
}

@freezed
class ActivityPricingExternalStoreInformation with _$ActivityPricingExternalStoreInformation {
  const factory ActivityPricingExternalStoreInformation({
    @Default('') String costExact,
    @Default('') String costMinimum,
    @Default('') String costMaximum,
    @Default(ActivityPricingExternalStoreInformationPricingStrategy.onePerson()) @JsonKey(toJson: ActivityPricingExternalStoreInformationPricingStrategy.toJson, fromJson: ActivityPricingExternalStoreInformationPricingStrategy.fromJson) ActivityPricingExternalStoreInformationPricingStrategy pricingStrategy,
  }) = _ActivityPricingExternalStoreInformation;

  factory ActivityPricingExternalStoreInformation.fromJson(Map<String, dynamic> json) => _$ActivityPricingExternalStoreInformationFromJson(json);
}

@freezed
class ActivityPricingExternalStoreInformationPricingStrategy with _$ActivityPricingExternalStoreInformationPricingStrategy {
  const factory ActivityPricingExternalStoreInformationPricingStrategy.onePerson() = _ActivityPricingExternalStoreInformationPricingStrategyOnePerson;

  static String toJson(ActivityPricingExternalStoreInformationPricingStrategy strategy) {
    return strategy.when(
      onePerson: () => 'persons_1',
    );
  }

  factory ActivityPricingExternalStoreInformationPricingStrategy.fromJson(String value) {
    switch (value) {
      case 'persons_1':
        return const _ActivityPricingExternalStoreInformationPricingStrategyOnePerson();
      default:
        throw ArgumentError('Invalid value for ActivityPricingExternalStoreInformationPricingStrategy: $value');
    }
  }
}

@freezed
class ActivityPublisherInformation with _$ActivityPublisherInformation {
  const factory ActivityPublisherInformation({
    @Default('') String originFeed,
    @Default('') String publisherId,
  }) = _ActivityPublisherInformation;

  factory ActivityPublisherInformation.fromJson(Map<String, dynamic> json) => _$ActivityPublisherInformationFromJson(json);
}

@freezed
class ActivityEnrichmentConfiguration with _$ActivityEnrichmentConfiguration {
  const factory ActivityEnrichmentConfiguration({
    @JsonKey(fromJson: stringListFromJson) @Default([]) List<String> tags,
    @Default('') String promotionKey,
    @Default('') String publishLocation,
    @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList) @Default([]) List<Mention> mentions,
  }) = _ActivityEnrichmentConfiguration;

  factory ActivityEnrichmentConfiguration.fromJson(Map<String, dynamic> json) => _$ActivityEnrichmentConfigurationFromJson(json);
}
