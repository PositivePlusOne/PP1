// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return _Activity.fromJson(json);
}

/// @nodoc
mixin _$Activity {
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  String get searchDescription => throw _privateConstructorUsedError;
  ActivityGeneralConfiguration? get generalConfiguration =>
      throw _privateConstructorUsedError;
  ActivityRepostConfiguration? get repostConfiguration =>
      throw _privateConstructorUsedError;
  ActivitySecurityConfiguration? get securityConfiguration =>
      throw _privateConstructorUsedError;
  ActivityEventConfiguration? get eventConfiguration =>
      throw _privateConstructorUsedError;
  ActivityPricingInformation? get pricingInformation =>
      throw _privateConstructorUsedError;
  ActivityPublisherInformation? get publisherInformation =>
      throw _privateConstructorUsedError;
  ActivityEnrichmentConfiguration? get enrichmentConfiguration =>
      throw _privateConstructorUsedError;
  @JsonKey(fromJson: Media.fromJsonList)
  List<Media> get media => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityCopyWith<Activity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityCopyWith<$Res> {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) then) =
      _$ActivityCopyWithImpl<$Res, Activity>;
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String searchDescription,
      ActivityGeneralConfiguration? generalConfiguration,
      ActivityRepostConfiguration? repostConfiguration,
      ActivitySecurityConfiguration? securityConfiguration,
      ActivityEventConfiguration? eventConfiguration,
      ActivityPricingInformation? pricingInformation,
      ActivityPublisherInformation? publisherInformation,
      ActivityEnrichmentConfiguration? enrichmentConfiguration,
      @JsonKey(fromJson: Media.fromJsonList) List<Media> media});

  $FlMetaCopyWith<$Res>? get flMeta;
  $ActivityGeneralConfigurationCopyWith<$Res>? get generalConfiguration;
  $ActivityRepostConfigurationCopyWith<$Res>? get repostConfiguration;
  $ActivitySecurityConfigurationCopyWith<$Res>? get securityConfiguration;
  $ActivityEventConfigurationCopyWith<$Res>? get eventConfiguration;
  $ActivityPricingInformationCopyWith<$Res>? get pricingInformation;
  $ActivityPublisherInformationCopyWith<$Res>? get publisherInformation;
  $ActivityEnrichmentConfigurationCopyWith<$Res>? get enrichmentConfiguration;
}

/// @nodoc
class _$ActivityCopyWithImpl<$Res, $Val extends Activity>
    implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? searchDescription = null,
    Object? generalConfiguration = freezed,
    Object? repostConfiguration = freezed,
    Object? securityConfiguration = freezed,
    Object? eventConfiguration = freezed,
    Object? pricingInformation = freezed,
    Object? publisherInformation = freezed,
    Object? enrichmentConfiguration = freezed,
    Object? media = null,
  }) {
    return _then(_value.copyWith(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      searchDescription: null == searchDescription
          ? _value.searchDescription
          : searchDescription // ignore: cast_nullable_to_non_nullable
              as String,
      generalConfiguration: freezed == generalConfiguration
          ? _value.generalConfiguration
          : generalConfiguration // ignore: cast_nullable_to_non_nullable
              as ActivityGeneralConfiguration?,
      repostConfiguration: freezed == repostConfiguration
          ? _value.repostConfiguration
          : repostConfiguration // ignore: cast_nullable_to_non_nullable
              as ActivityRepostConfiguration?,
      securityConfiguration: freezed == securityConfiguration
          ? _value.securityConfiguration
          : securityConfiguration // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfiguration?,
      eventConfiguration: freezed == eventConfiguration
          ? _value.eventConfiguration
          : eventConfiguration // ignore: cast_nullable_to_non_nullable
              as ActivityEventConfiguration?,
      pricingInformation: freezed == pricingInformation
          ? _value.pricingInformation
          : pricingInformation // ignore: cast_nullable_to_non_nullable
              as ActivityPricingInformation?,
      publisherInformation: freezed == publisherInformation
          ? _value.publisherInformation
          : publisherInformation // ignore: cast_nullable_to_non_nullable
              as ActivityPublisherInformation?,
      enrichmentConfiguration: freezed == enrichmentConfiguration
          ? _value.enrichmentConfiguration
          : enrichmentConfiguration // ignore: cast_nullable_to_non_nullable
              as ActivityEnrichmentConfiguration?,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FlMetaCopyWith<$Res>? get flMeta {
    if (_value.flMeta == null) {
      return null;
    }

    return $FlMetaCopyWith<$Res>(_value.flMeta!, (value) {
      return _then(_value.copyWith(flMeta: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityGeneralConfigurationCopyWith<$Res>? get generalConfiguration {
    if (_value.generalConfiguration == null) {
      return null;
    }

    return $ActivityGeneralConfigurationCopyWith<$Res>(
        _value.generalConfiguration!, (value) {
      return _then(_value.copyWith(generalConfiguration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityRepostConfigurationCopyWith<$Res>? get repostConfiguration {
    if (_value.repostConfiguration == null) {
      return null;
    }

    return $ActivityRepostConfigurationCopyWith<$Res>(
        _value.repostConfiguration!, (value) {
      return _then(_value.copyWith(repostConfiguration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivitySecurityConfigurationCopyWith<$Res>? get securityConfiguration {
    if (_value.securityConfiguration == null) {
      return null;
    }

    return $ActivitySecurityConfigurationCopyWith<$Res>(
        _value.securityConfiguration!, (value) {
      return _then(_value.copyWith(securityConfiguration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityEventConfigurationCopyWith<$Res>? get eventConfiguration {
    if (_value.eventConfiguration == null) {
      return null;
    }

    return $ActivityEventConfigurationCopyWith<$Res>(_value.eventConfiguration!,
        (value) {
      return _then(_value.copyWith(eventConfiguration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityPricingInformationCopyWith<$Res>? get pricingInformation {
    if (_value.pricingInformation == null) {
      return null;
    }

    return $ActivityPricingInformationCopyWith<$Res>(_value.pricingInformation!,
        (value) {
      return _then(_value.copyWith(pricingInformation: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityPublisherInformationCopyWith<$Res>? get publisherInformation {
    if (_value.publisherInformation == null) {
      return null;
    }

    return $ActivityPublisherInformationCopyWith<$Res>(
        _value.publisherInformation!, (value) {
      return _then(_value.copyWith(publisherInformation: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityEnrichmentConfigurationCopyWith<$Res>? get enrichmentConfiguration {
    if (_value.enrichmentConfiguration == null) {
      return null;
    }

    return $ActivityEnrichmentConfigurationCopyWith<$Res>(
        _value.enrichmentConfiguration!, (value) {
      return _then(_value.copyWith(enrichmentConfiguration: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityImplCopyWith<$Res>
    implements $ActivityCopyWith<$Res> {
  factory _$$ActivityImplCopyWith(
          _$ActivityImpl value, $Res Function(_$ActivityImpl) then) =
      __$$ActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String searchDescription,
      ActivityGeneralConfiguration? generalConfiguration,
      ActivityRepostConfiguration? repostConfiguration,
      ActivitySecurityConfiguration? securityConfiguration,
      ActivityEventConfiguration? eventConfiguration,
      ActivityPricingInformation? pricingInformation,
      ActivityPublisherInformation? publisherInformation,
      ActivityEnrichmentConfiguration? enrichmentConfiguration,
      @JsonKey(fromJson: Media.fromJsonList) List<Media> media});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
  @override
  $ActivityGeneralConfigurationCopyWith<$Res>? get generalConfiguration;
  @override
  $ActivityRepostConfigurationCopyWith<$Res>? get repostConfiguration;
  @override
  $ActivitySecurityConfigurationCopyWith<$Res>? get securityConfiguration;
  @override
  $ActivityEventConfigurationCopyWith<$Res>? get eventConfiguration;
  @override
  $ActivityPricingInformationCopyWith<$Res>? get pricingInformation;
  @override
  $ActivityPublisherInformationCopyWith<$Res>? get publisherInformation;
  @override
  $ActivityEnrichmentConfigurationCopyWith<$Res>? get enrichmentConfiguration;
}

/// @nodoc
class __$$ActivityImplCopyWithImpl<$Res>
    extends _$ActivityCopyWithImpl<$Res, _$ActivityImpl>
    implements _$$ActivityImplCopyWith<$Res> {
  __$$ActivityImplCopyWithImpl(
      _$ActivityImpl _value, $Res Function(_$ActivityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? searchDescription = null,
    Object? generalConfiguration = freezed,
    Object? repostConfiguration = freezed,
    Object? securityConfiguration = freezed,
    Object? eventConfiguration = freezed,
    Object? pricingInformation = freezed,
    Object? publisherInformation = freezed,
    Object? enrichmentConfiguration = freezed,
    Object? media = null,
  }) {
    return _then(_$ActivityImpl(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      searchDescription: null == searchDescription
          ? _value.searchDescription
          : searchDescription // ignore: cast_nullable_to_non_nullable
              as String,
      generalConfiguration: freezed == generalConfiguration
          ? _value.generalConfiguration
          : generalConfiguration // ignore: cast_nullable_to_non_nullable
              as ActivityGeneralConfiguration?,
      repostConfiguration: freezed == repostConfiguration
          ? _value.repostConfiguration
          : repostConfiguration // ignore: cast_nullable_to_non_nullable
              as ActivityRepostConfiguration?,
      securityConfiguration: freezed == securityConfiguration
          ? _value.securityConfiguration
          : securityConfiguration // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfiguration?,
      eventConfiguration: freezed == eventConfiguration
          ? _value.eventConfiguration
          : eventConfiguration // ignore: cast_nullable_to_non_nullable
              as ActivityEventConfiguration?,
      pricingInformation: freezed == pricingInformation
          ? _value.pricingInformation
          : pricingInformation // ignore: cast_nullable_to_non_nullable
              as ActivityPricingInformation?,
      publisherInformation: freezed == publisherInformation
          ? _value.publisherInformation
          : publisherInformation // ignore: cast_nullable_to_non_nullable
              as ActivityPublisherInformation?,
      enrichmentConfiguration: freezed == enrichmentConfiguration
          ? _value.enrichmentConfiguration
          : enrichmentConfiguration // ignore: cast_nullable_to_non_nullable
              as ActivityEnrichmentConfiguration?,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityImpl implements _Activity {
  const _$ActivityImpl(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      this.searchDescription = '',
      this.generalConfiguration,
      this.repostConfiguration,
      this.securityConfiguration,
      this.eventConfiguration,
      this.pricingInformation,
      this.publisherInformation,
      this.enrichmentConfiguration,
      @JsonKey(fromJson: Media.fromJsonList)
      final List<Media> media = const []})
      : _media = media;

  factory _$ActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityImplFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey()
  final String searchDescription;
  @override
  final ActivityGeneralConfiguration? generalConfiguration;
  @override
  final ActivityRepostConfiguration? repostConfiguration;
  @override
  final ActivitySecurityConfiguration? securityConfiguration;
  @override
  final ActivityEventConfiguration? eventConfiguration;
  @override
  final ActivityPricingInformation? pricingInformation;
  @override
  final ActivityPublisherInformation? publisherInformation;
  @override
  final ActivityEnrichmentConfiguration? enrichmentConfiguration;
  final List<Media> _media;
  @override
  @JsonKey(fromJson: Media.fromJsonList)
  List<Media> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  @override
  String toString() {
    return 'Activity(flMeta: $flMeta, searchDescription: $searchDescription, generalConfiguration: $generalConfiguration, repostConfiguration: $repostConfiguration, securityConfiguration: $securityConfiguration, eventConfiguration: $eventConfiguration, pricingInformation: $pricingInformation, publisherInformation: $publisherInformation, enrichmentConfiguration: $enrichmentConfiguration, media: $media)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityImpl &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.searchDescription, searchDescription) ||
                other.searchDescription == searchDescription) &&
            (identical(other.generalConfiguration, generalConfiguration) ||
                other.generalConfiguration == generalConfiguration) &&
            (identical(other.repostConfiguration, repostConfiguration) ||
                other.repostConfiguration == repostConfiguration) &&
            (identical(other.securityConfiguration, securityConfiguration) ||
                other.securityConfiguration == securityConfiguration) &&
            (identical(other.eventConfiguration, eventConfiguration) ||
                other.eventConfiguration == eventConfiguration) &&
            (identical(other.pricingInformation, pricingInformation) ||
                other.pricingInformation == pricingInformation) &&
            (identical(other.publisherInformation, publisherInformation) ||
                other.publisherInformation == publisherInformation) &&
            (identical(
                    other.enrichmentConfiguration, enrichmentConfiguration) ||
                other.enrichmentConfiguration == enrichmentConfiguration) &&
            const DeepCollectionEquality().equals(other._media, _media));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      flMeta,
      searchDescription,
      generalConfiguration,
      repostConfiguration,
      securityConfiguration,
      eventConfiguration,
      pricingInformation,
      publisherInformation,
      enrichmentConfiguration,
      const DeepCollectionEquality().hash(_media));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      __$$ActivityImplCopyWithImpl<_$ActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityImplToJson(
      this,
    );
  }
}

abstract class _Activity implements Activity {
  const factory _Activity(
          {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
          final String searchDescription,
          final ActivityGeneralConfiguration? generalConfiguration,
          final ActivityRepostConfiguration? repostConfiguration,
          final ActivitySecurityConfiguration? securityConfiguration,
          final ActivityEventConfiguration? eventConfiguration,
          final ActivityPricingInformation? pricingInformation,
          final ActivityPublisherInformation? publisherInformation,
          final ActivityEnrichmentConfiguration? enrichmentConfiguration,
          @JsonKey(fromJson: Media.fromJsonList) final List<Media> media}) =
      _$ActivityImpl;

  factory _Activity.fromJson(Map<String, dynamic> json) =
      _$ActivityImpl.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  String get searchDescription;
  @override
  ActivityGeneralConfiguration? get generalConfiguration;
  @override
  ActivityRepostConfiguration? get repostConfiguration;
  @override
  ActivitySecurityConfiguration? get securityConfiguration;
  @override
  ActivityEventConfiguration? get eventConfiguration;
  @override
  ActivityPricingInformation? get pricingInformation;
  @override
  ActivityPublisherInformation? get publisherInformation;
  @override
  ActivityEnrichmentConfiguration? get enrichmentConfiguration;
  @override
  @JsonKey(fromJson: Media.fromJsonList)
  List<Media> get media;
  @override
  @JsonKey(ignore: true)
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityRepostConfiguration _$ActivityRepostConfigurationFromJson(
    Map<String, dynamic> json) {
  return _ActivityRepostConfiguration.fromJson(json);
}

/// @nodoc
mixin _$ActivityRepostConfiguration {
  String get targetActivityId => throw _privateConstructorUsedError;
  String get targetActivityPublisherId => throw _privateConstructorUsedError;
  String get targetActivityOriginFeed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityRepostConfigurationCopyWith<ActivityRepostConfiguration>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityRepostConfigurationCopyWith<$Res> {
  factory $ActivityRepostConfigurationCopyWith(
          ActivityRepostConfiguration value,
          $Res Function(ActivityRepostConfiguration) then) =
      _$ActivityRepostConfigurationCopyWithImpl<$Res,
          ActivityRepostConfiguration>;
  @useResult
  $Res call(
      {String targetActivityId,
      String targetActivityPublisherId,
      String targetActivityOriginFeed});
}

/// @nodoc
class _$ActivityRepostConfigurationCopyWithImpl<$Res,
        $Val extends ActivityRepostConfiguration>
    implements $ActivityRepostConfigurationCopyWith<$Res> {
  _$ActivityRepostConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetActivityId = null,
    Object? targetActivityPublisherId = null,
    Object? targetActivityOriginFeed = null,
  }) {
    return _then(_value.copyWith(
      targetActivityId: null == targetActivityId
          ? _value.targetActivityId
          : targetActivityId // ignore: cast_nullable_to_non_nullable
              as String,
      targetActivityPublisherId: null == targetActivityPublisherId
          ? _value.targetActivityPublisherId
          : targetActivityPublisherId // ignore: cast_nullable_to_non_nullable
              as String,
      targetActivityOriginFeed: null == targetActivityOriginFeed
          ? _value.targetActivityOriginFeed
          : targetActivityOriginFeed // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityRepostConfigurationImplCopyWith<$Res>
    implements $ActivityRepostConfigurationCopyWith<$Res> {
  factory _$$ActivityRepostConfigurationImplCopyWith(
          _$ActivityRepostConfigurationImpl value,
          $Res Function(_$ActivityRepostConfigurationImpl) then) =
      __$$ActivityRepostConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String targetActivityId,
      String targetActivityPublisherId,
      String targetActivityOriginFeed});
}

/// @nodoc
class __$$ActivityRepostConfigurationImplCopyWithImpl<$Res>
    extends _$ActivityRepostConfigurationCopyWithImpl<$Res,
        _$ActivityRepostConfigurationImpl>
    implements _$$ActivityRepostConfigurationImplCopyWith<$Res> {
  __$$ActivityRepostConfigurationImplCopyWithImpl(
      _$ActivityRepostConfigurationImpl _value,
      $Res Function(_$ActivityRepostConfigurationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetActivityId = null,
    Object? targetActivityPublisherId = null,
    Object? targetActivityOriginFeed = null,
  }) {
    return _then(_$ActivityRepostConfigurationImpl(
      targetActivityId: null == targetActivityId
          ? _value.targetActivityId
          : targetActivityId // ignore: cast_nullable_to_non_nullable
              as String,
      targetActivityPublisherId: null == targetActivityPublisherId
          ? _value.targetActivityPublisherId
          : targetActivityPublisherId // ignore: cast_nullable_to_non_nullable
              as String,
      targetActivityOriginFeed: null == targetActivityOriginFeed
          ? _value.targetActivityOriginFeed
          : targetActivityOriginFeed // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityRepostConfigurationImpl
    implements _ActivityRepostConfiguration {
  const _$ActivityRepostConfigurationImpl(
      {this.targetActivityId = '',
      this.targetActivityPublisherId = '',
      this.targetActivityOriginFeed = ''});

  factory _$ActivityRepostConfigurationImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ActivityRepostConfigurationImplFromJson(json);

  @override
  @JsonKey()
  final String targetActivityId;
  @override
  @JsonKey()
  final String targetActivityPublisherId;
  @override
  @JsonKey()
  final String targetActivityOriginFeed;

  @override
  String toString() {
    return 'ActivityRepostConfiguration(targetActivityId: $targetActivityId, targetActivityPublisherId: $targetActivityPublisherId, targetActivityOriginFeed: $targetActivityOriginFeed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityRepostConfigurationImpl &&
            (identical(other.targetActivityId, targetActivityId) ||
                other.targetActivityId == targetActivityId) &&
            (identical(other.targetActivityPublisherId,
                    targetActivityPublisherId) ||
                other.targetActivityPublisherId == targetActivityPublisherId) &&
            (identical(
                    other.targetActivityOriginFeed, targetActivityOriginFeed) ||
                other.targetActivityOriginFeed == targetActivityOriginFeed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, targetActivityId,
      targetActivityPublisherId, targetActivityOriginFeed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityRepostConfigurationImplCopyWith<_$ActivityRepostConfigurationImpl>
      get copyWith => __$$ActivityRepostConfigurationImplCopyWithImpl<
          _$ActivityRepostConfigurationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityRepostConfigurationImplToJson(
      this,
    );
  }
}

abstract class _ActivityRepostConfiguration
    implements ActivityRepostConfiguration {
  const factory _ActivityRepostConfiguration(
          {final String targetActivityId,
          final String targetActivityPublisherId,
          final String targetActivityOriginFeed}) =
      _$ActivityRepostConfigurationImpl;

  factory _ActivityRepostConfiguration.fromJson(Map<String, dynamic> json) =
      _$ActivityRepostConfigurationImpl.fromJson;

  @override
  String get targetActivityId;
  @override
  String get targetActivityPublisherId;
  @override
  String get targetActivityOriginFeed;
  @override
  @JsonKey(ignore: true)
  _$$ActivityRepostConfigurationImplCopyWith<_$ActivityRepostConfigurationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ActivityGeneralConfiguration _$ActivityGeneralConfigurationFromJson(
    Map<String, dynamic> json) {
  return _ActivityGeneralConfiguration.fromJson(json);
}

/// @nodoc
mixin _$ActivityGeneralConfiguration {
  @JsonKey(
      fromJson: ActivityGeneralConfigurationType.fromJson,
      toJson: ActivityGeneralConfigurationType.toJson)
  ActivityGeneralConfigurationType get type =>
      throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: ActivityGeneralConfigurationStyle.fromJson,
      toJson: ActivityGeneralConfigurationStyle.toJson)
  ActivityGeneralConfigurationStyle get style =>
      throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  bool get isSensitive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityGeneralConfigurationCopyWith<ActivityGeneralConfiguration>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityGeneralConfigurationCopyWith<$Res> {
  factory $ActivityGeneralConfigurationCopyWith(
          ActivityGeneralConfiguration value,
          $Res Function(ActivityGeneralConfiguration) then) =
      _$ActivityGeneralConfigurationCopyWithImpl<$Res,
          ActivityGeneralConfiguration>;
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: ActivityGeneralConfigurationType.fromJson,
          toJson: ActivityGeneralConfigurationType.toJson)
      ActivityGeneralConfigurationType type,
      @JsonKey(
          fromJson: ActivityGeneralConfigurationStyle.fromJson,
          toJson: ActivityGeneralConfigurationStyle.toJson)
      ActivityGeneralConfigurationStyle style,
      String content,
      bool isSensitive});

  $ActivityGeneralConfigurationTypeCopyWith<$Res> get type;
  $ActivityGeneralConfigurationStyleCopyWith<$Res> get style;
}

/// @nodoc
class _$ActivityGeneralConfigurationCopyWithImpl<$Res,
        $Val extends ActivityGeneralConfiguration>
    implements $ActivityGeneralConfigurationCopyWith<$Res> {
  _$ActivityGeneralConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? style = null,
    Object? content = null,
    Object? isSensitive = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActivityGeneralConfigurationType,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as ActivityGeneralConfigurationStyle,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isSensitive: null == isSensitive
          ? _value.isSensitive
          : isSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityGeneralConfigurationTypeCopyWith<$Res> get type {
    return $ActivityGeneralConfigurationTypeCopyWith<$Res>(_value.type,
        (value) {
      return _then(_value.copyWith(type: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityGeneralConfigurationStyleCopyWith<$Res> get style {
    return $ActivityGeneralConfigurationStyleCopyWith<$Res>(_value.style,
        (value) {
      return _then(_value.copyWith(style: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityGeneralConfigurationImplCopyWith<$Res>
    implements $ActivityGeneralConfigurationCopyWith<$Res> {
  factory _$$ActivityGeneralConfigurationImplCopyWith(
          _$ActivityGeneralConfigurationImpl value,
          $Res Function(_$ActivityGeneralConfigurationImpl) then) =
      __$$ActivityGeneralConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: ActivityGeneralConfigurationType.fromJson,
          toJson: ActivityGeneralConfigurationType.toJson)
      ActivityGeneralConfigurationType type,
      @JsonKey(
          fromJson: ActivityGeneralConfigurationStyle.fromJson,
          toJson: ActivityGeneralConfigurationStyle.toJson)
      ActivityGeneralConfigurationStyle style,
      String content,
      bool isSensitive});

  @override
  $ActivityGeneralConfigurationTypeCopyWith<$Res> get type;
  @override
  $ActivityGeneralConfigurationStyleCopyWith<$Res> get style;
}

/// @nodoc
class __$$ActivityGeneralConfigurationImplCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationCopyWithImpl<$Res,
        _$ActivityGeneralConfigurationImpl>
    implements _$$ActivityGeneralConfigurationImplCopyWith<$Res> {
  __$$ActivityGeneralConfigurationImplCopyWithImpl(
      _$ActivityGeneralConfigurationImpl _value,
      $Res Function(_$ActivityGeneralConfigurationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? style = null,
    Object? content = null,
    Object? isSensitive = null,
  }) {
    return _then(_$ActivityGeneralConfigurationImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActivityGeneralConfigurationType,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as ActivityGeneralConfigurationStyle,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isSensitive: null == isSensitive
          ? _value.isSensitive
          : isSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityGeneralConfigurationImpl
    implements _ActivityGeneralConfiguration {
  const _$ActivityGeneralConfigurationImpl(
      {@JsonKey(
          fromJson: ActivityGeneralConfigurationType.fromJson,
          toJson: ActivityGeneralConfigurationType.toJson)
      this.type = const ActivityGeneralConfigurationType.post(),
      @JsonKey(
          fromJson: ActivityGeneralConfigurationStyle.fromJson,
          toJson: ActivityGeneralConfigurationStyle.toJson)
      this.style = const ActivityGeneralConfigurationStyle.text(),
      this.content = '',
      this.isSensitive = false});

  factory _$ActivityGeneralConfigurationImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ActivityGeneralConfigurationImplFromJson(json);

  @override
  @JsonKey(
      fromJson: ActivityGeneralConfigurationType.fromJson,
      toJson: ActivityGeneralConfigurationType.toJson)
  final ActivityGeneralConfigurationType type;
  @override
  @JsonKey(
      fromJson: ActivityGeneralConfigurationStyle.fromJson,
      toJson: ActivityGeneralConfigurationStyle.toJson)
  final ActivityGeneralConfigurationStyle style;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final bool isSensitive;

  @override
  String toString() {
    return 'ActivityGeneralConfiguration(type: $type, style: $style, content: $content, isSensitive: $isSensitive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityGeneralConfigurationImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isSensitive, isSensitive) ||
                other.isSensitive == isSensitive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, style, content, isSensitive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityGeneralConfigurationImplCopyWith<
          _$ActivityGeneralConfigurationImpl>
      get copyWith => __$$ActivityGeneralConfigurationImplCopyWithImpl<
          _$ActivityGeneralConfigurationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityGeneralConfigurationImplToJson(
      this,
    );
  }
}

abstract class _ActivityGeneralConfiguration
    implements ActivityGeneralConfiguration {
  const factory _ActivityGeneralConfiguration(
      {@JsonKey(
          fromJson: ActivityGeneralConfigurationType.fromJson,
          toJson: ActivityGeneralConfigurationType.toJson)
      final ActivityGeneralConfigurationType type,
      @JsonKey(
          fromJson: ActivityGeneralConfigurationStyle.fromJson,
          toJson: ActivityGeneralConfigurationStyle.toJson)
      final ActivityGeneralConfigurationStyle style,
      final String content,
      final bool isSensitive}) = _$ActivityGeneralConfigurationImpl;

  factory _ActivityGeneralConfiguration.fromJson(Map<String, dynamic> json) =
      _$ActivityGeneralConfigurationImpl.fromJson;

  @override
  @JsonKey(
      fromJson: ActivityGeneralConfigurationType.fromJson,
      toJson: ActivityGeneralConfigurationType.toJson)
  ActivityGeneralConfigurationType get type;
  @override
  @JsonKey(
      fromJson: ActivityGeneralConfigurationStyle.fromJson,
      toJson: ActivityGeneralConfigurationStyle.toJson)
  ActivityGeneralConfigurationStyle get style;
  @override
  String get content;
  @override
  bool get isSensitive;
  @override
  @JsonKey(ignore: true)
  _$$ActivityGeneralConfigurationImplCopyWith<
          _$ActivityGeneralConfigurationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ActivityGeneralConfigurationType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityGeneralConfigurationTypePost value) post,
    required TResult Function(_ActivityGeneralConfigurationTypeEvent value)
        event,
    required TResult Function(_ActivityGeneralConfigurationTypeClip value) clip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult? Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult? Function(_ActivityGeneralConfigurationTypeClip value)? clip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityGeneralConfigurationTypeCopyWith<$Res> {
  factory $ActivityGeneralConfigurationTypeCopyWith(
          ActivityGeneralConfigurationType value,
          $Res Function(ActivityGeneralConfigurationType) then) =
      _$ActivityGeneralConfigurationTypeCopyWithImpl<$Res,
          ActivityGeneralConfigurationType>;
}

/// @nodoc
class _$ActivityGeneralConfigurationTypeCopyWithImpl<$Res,
        $Val extends ActivityGeneralConfigurationType>
    implements $ActivityGeneralConfigurationTypeCopyWith<$Res> {
  _$ActivityGeneralConfigurationTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ActivityGeneralConfigurationTypePostImplCopyWith<$Res> {
  factory _$$ActivityGeneralConfigurationTypePostImplCopyWith(
          _$ActivityGeneralConfigurationTypePostImpl value,
          $Res Function(_$ActivityGeneralConfigurationTypePostImpl) then) =
      __$$ActivityGeneralConfigurationTypePostImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityGeneralConfigurationTypePostImplCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationTypeCopyWithImpl<$Res,
        _$ActivityGeneralConfigurationTypePostImpl>
    implements _$$ActivityGeneralConfigurationTypePostImplCopyWith<$Res> {
  __$$ActivityGeneralConfigurationTypePostImplCopyWithImpl(
      _$ActivityGeneralConfigurationTypePostImpl _value,
      $Res Function(_$ActivityGeneralConfigurationTypePostImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityGeneralConfigurationTypePostImpl
    implements _ActivityGeneralConfigurationTypePost {
  const _$ActivityGeneralConfigurationTypePostImpl();

  @override
  String toString() {
    return 'ActivityGeneralConfigurationType.post()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityGeneralConfigurationTypePostImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
  }) {
    return post();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
  }) {
    return post?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    required TResult orElse(),
  }) {
    if (post != null) {
      return post();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityGeneralConfigurationTypePost value) post,
    required TResult Function(_ActivityGeneralConfigurationTypeEvent value)
        event,
    required TResult Function(_ActivityGeneralConfigurationTypeClip value) clip,
  }) {
    return post(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult? Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult? Function(_ActivityGeneralConfigurationTypeClip value)? clip,
  }) {
    return post?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    required TResult orElse(),
  }) {
    if (post != null) {
      return post(this);
    }
    return orElse();
  }
}

abstract class _ActivityGeneralConfigurationTypePost
    implements ActivityGeneralConfigurationType {
  const factory _ActivityGeneralConfigurationTypePost() =
      _$ActivityGeneralConfigurationTypePostImpl;
}

/// @nodoc
abstract class _$$ActivityGeneralConfigurationTypeEventImplCopyWith<$Res> {
  factory _$$ActivityGeneralConfigurationTypeEventImplCopyWith(
          _$ActivityGeneralConfigurationTypeEventImpl value,
          $Res Function(_$ActivityGeneralConfigurationTypeEventImpl) then) =
      __$$ActivityGeneralConfigurationTypeEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityGeneralConfigurationTypeEventImplCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationTypeCopyWithImpl<$Res,
        _$ActivityGeneralConfigurationTypeEventImpl>
    implements _$$ActivityGeneralConfigurationTypeEventImplCopyWith<$Res> {
  __$$ActivityGeneralConfigurationTypeEventImplCopyWithImpl(
      _$ActivityGeneralConfigurationTypeEventImpl _value,
      $Res Function(_$ActivityGeneralConfigurationTypeEventImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityGeneralConfigurationTypeEventImpl
    implements _ActivityGeneralConfigurationTypeEvent {
  const _$ActivityGeneralConfigurationTypeEventImpl();

  @override
  String toString() {
    return 'ActivityGeneralConfigurationType.event()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityGeneralConfigurationTypeEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
  }) {
    return event();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
  }) {
    return event?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    required TResult orElse(),
  }) {
    if (event != null) {
      return event();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityGeneralConfigurationTypePost value) post,
    required TResult Function(_ActivityGeneralConfigurationTypeEvent value)
        event,
    required TResult Function(_ActivityGeneralConfigurationTypeClip value) clip,
  }) {
    return event(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult? Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult? Function(_ActivityGeneralConfigurationTypeClip value)? clip,
  }) {
    return event?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    required TResult orElse(),
  }) {
    if (event != null) {
      return event(this);
    }
    return orElse();
  }
}

abstract class _ActivityGeneralConfigurationTypeEvent
    implements ActivityGeneralConfigurationType {
  const factory _ActivityGeneralConfigurationTypeEvent() =
      _$ActivityGeneralConfigurationTypeEventImpl;
}

/// @nodoc
abstract class _$$ActivityGeneralConfigurationTypeClipImplCopyWith<$Res> {
  factory _$$ActivityGeneralConfigurationTypeClipImplCopyWith(
          _$ActivityGeneralConfigurationTypeClipImpl value,
          $Res Function(_$ActivityGeneralConfigurationTypeClipImpl) then) =
      __$$ActivityGeneralConfigurationTypeClipImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityGeneralConfigurationTypeClipImplCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationTypeCopyWithImpl<$Res,
        _$ActivityGeneralConfigurationTypeClipImpl>
    implements _$$ActivityGeneralConfigurationTypeClipImplCopyWith<$Res> {
  __$$ActivityGeneralConfigurationTypeClipImplCopyWithImpl(
      _$ActivityGeneralConfigurationTypeClipImpl _value,
      $Res Function(_$ActivityGeneralConfigurationTypeClipImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityGeneralConfigurationTypeClipImpl
    implements _ActivityGeneralConfigurationTypeClip {
  const _$ActivityGeneralConfigurationTypeClipImpl();

  @override
  String toString() {
    return 'ActivityGeneralConfigurationType.clip()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityGeneralConfigurationTypeClipImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
  }) {
    return clip();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
  }) {
    return clip?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    required TResult orElse(),
  }) {
    if (clip != null) {
      return clip();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityGeneralConfigurationTypePost value) post,
    required TResult Function(_ActivityGeneralConfigurationTypeEvent value)
        event,
    required TResult Function(_ActivityGeneralConfigurationTypeClip value) clip,
  }) {
    return clip(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult? Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult? Function(_ActivityGeneralConfigurationTypeClip value)? clip,
  }) {
    return clip?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    required TResult orElse(),
  }) {
    if (clip != null) {
      return clip(this);
    }
    return orElse();
  }
}

abstract class _ActivityGeneralConfigurationTypeClip
    implements ActivityGeneralConfigurationType {
  const factory _ActivityGeneralConfigurationTypeClip() =
      _$ActivityGeneralConfigurationTypeClipImpl;
}

/// @nodoc
mixin _$ActivityGeneralConfigurationStyle {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() markdown,
    required TResult Function() text,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? markdown,
    TResult? Function()? text,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? markdown,
    TResult Function()? text,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityGeneralConfigurationStyleMarkdown value)
        markdown,
    required TResult Function(_ActivityGeneralConfigurationStyleText value)
        text,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityGeneralConfigurationStyleMarkdown value)?
        markdown,
    TResult? Function(_ActivityGeneralConfigurationStyleText value)? text,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityGeneralConfigurationStyleMarkdown value)?
        markdown,
    TResult Function(_ActivityGeneralConfigurationStyleText value)? text,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityGeneralConfigurationStyleCopyWith<$Res> {
  factory $ActivityGeneralConfigurationStyleCopyWith(
          ActivityGeneralConfigurationStyle value,
          $Res Function(ActivityGeneralConfigurationStyle) then) =
      _$ActivityGeneralConfigurationStyleCopyWithImpl<$Res,
          ActivityGeneralConfigurationStyle>;
}

/// @nodoc
class _$ActivityGeneralConfigurationStyleCopyWithImpl<$Res,
        $Val extends ActivityGeneralConfigurationStyle>
    implements $ActivityGeneralConfigurationStyleCopyWith<$Res> {
  _$ActivityGeneralConfigurationStyleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ActivityGeneralConfigurationStyleMarkdownImplCopyWith<$Res> {
  factory _$$ActivityGeneralConfigurationStyleMarkdownImplCopyWith(
          _$ActivityGeneralConfigurationStyleMarkdownImpl value,
          $Res Function(_$ActivityGeneralConfigurationStyleMarkdownImpl) then) =
      __$$ActivityGeneralConfigurationStyleMarkdownImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityGeneralConfigurationStyleMarkdownImplCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationStyleCopyWithImpl<$Res,
        _$ActivityGeneralConfigurationStyleMarkdownImpl>
    implements _$$ActivityGeneralConfigurationStyleMarkdownImplCopyWith<$Res> {
  __$$ActivityGeneralConfigurationStyleMarkdownImplCopyWithImpl(
      _$ActivityGeneralConfigurationStyleMarkdownImpl _value,
      $Res Function(_$ActivityGeneralConfigurationStyleMarkdownImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityGeneralConfigurationStyleMarkdownImpl
    implements _ActivityGeneralConfigurationStyleMarkdown {
  const _$ActivityGeneralConfigurationStyleMarkdownImpl();

  @override
  String toString() {
    return 'ActivityGeneralConfigurationStyle.markdown()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityGeneralConfigurationStyleMarkdownImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() markdown,
    required TResult Function() text,
  }) {
    return markdown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? markdown,
    TResult? Function()? text,
  }) {
    return markdown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? markdown,
    TResult Function()? text,
    required TResult orElse(),
  }) {
    if (markdown != null) {
      return markdown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityGeneralConfigurationStyleMarkdown value)
        markdown,
    required TResult Function(_ActivityGeneralConfigurationStyleText value)
        text,
  }) {
    return markdown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityGeneralConfigurationStyleMarkdown value)?
        markdown,
    TResult? Function(_ActivityGeneralConfigurationStyleText value)? text,
  }) {
    return markdown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityGeneralConfigurationStyleMarkdown value)?
        markdown,
    TResult Function(_ActivityGeneralConfigurationStyleText value)? text,
    required TResult orElse(),
  }) {
    if (markdown != null) {
      return markdown(this);
    }
    return orElse();
  }
}

abstract class _ActivityGeneralConfigurationStyleMarkdown
    implements ActivityGeneralConfigurationStyle {
  const factory _ActivityGeneralConfigurationStyleMarkdown() =
      _$ActivityGeneralConfigurationStyleMarkdownImpl;
}

/// @nodoc
abstract class _$$ActivityGeneralConfigurationStyleTextImplCopyWith<$Res> {
  factory _$$ActivityGeneralConfigurationStyleTextImplCopyWith(
          _$ActivityGeneralConfigurationStyleTextImpl value,
          $Res Function(_$ActivityGeneralConfigurationStyleTextImpl) then) =
      __$$ActivityGeneralConfigurationStyleTextImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityGeneralConfigurationStyleTextImplCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationStyleCopyWithImpl<$Res,
        _$ActivityGeneralConfigurationStyleTextImpl>
    implements _$$ActivityGeneralConfigurationStyleTextImplCopyWith<$Res> {
  __$$ActivityGeneralConfigurationStyleTextImplCopyWithImpl(
      _$ActivityGeneralConfigurationStyleTextImpl _value,
      $Res Function(_$ActivityGeneralConfigurationStyleTextImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityGeneralConfigurationStyleTextImpl
    implements _ActivityGeneralConfigurationStyleText {
  const _$ActivityGeneralConfigurationStyleTextImpl();

  @override
  String toString() {
    return 'ActivityGeneralConfigurationStyle.text()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityGeneralConfigurationStyleTextImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() markdown,
    required TResult Function() text,
  }) {
    return text();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? markdown,
    TResult? Function()? text,
  }) {
    return text?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? markdown,
    TResult Function()? text,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityGeneralConfigurationStyleMarkdown value)
        markdown,
    required TResult Function(_ActivityGeneralConfigurationStyleText value)
        text,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityGeneralConfigurationStyleMarkdown value)?
        markdown,
    TResult? Function(_ActivityGeneralConfigurationStyleText value)? text,
  }) {
    return text?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityGeneralConfigurationStyleMarkdown value)?
        markdown,
    TResult Function(_ActivityGeneralConfigurationStyleText value)? text,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this);
    }
    return orElse();
  }
}

abstract class _ActivityGeneralConfigurationStyleText
    implements ActivityGeneralConfigurationStyle {
  const factory _ActivityGeneralConfigurationStyleText() =
      _$ActivityGeneralConfigurationStyleTextImpl;
}

ActivitySecurityConfiguration _$ActivitySecurityConfigurationFromJson(
    Map<String, dynamic> json) {
  return _ActivitySecurityConfiguration.fromJson(json);
}

/// @nodoc
mixin _$ActivitySecurityConfiguration {
  String get context => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  ActivitySecurityConfigurationMode get viewMode =>
      throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  ActivitySecurityConfigurationMode get commentMode =>
      throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  ActivitySecurityConfigurationMode get shareMode =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivitySecurityConfigurationCopyWith<ActivitySecurityConfiguration>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivitySecurityConfigurationCopyWith<$Res> {
  factory $ActivitySecurityConfigurationCopyWith(
          ActivitySecurityConfiguration value,
          $Res Function(ActivitySecurityConfiguration) then) =
      _$ActivitySecurityConfigurationCopyWithImpl<$Res,
          ActivitySecurityConfiguration>;
  @useResult
  $Res call(
      {String context,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      ActivitySecurityConfigurationMode viewMode,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      ActivitySecurityConfigurationMode commentMode,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      ActivitySecurityConfigurationMode shareMode});

  $ActivitySecurityConfigurationModeCopyWith<$Res> get viewMode;
  $ActivitySecurityConfigurationModeCopyWith<$Res> get commentMode;
  $ActivitySecurityConfigurationModeCopyWith<$Res> get shareMode;
}

/// @nodoc
class _$ActivitySecurityConfigurationCopyWithImpl<$Res,
        $Val extends ActivitySecurityConfiguration>
    implements $ActivitySecurityConfigurationCopyWith<$Res> {
  _$ActivitySecurityConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
    Object? viewMode = null,
    Object? commentMode = null,
    Object? shareMode = null,
  }) {
    return _then(_value.copyWith(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String,
      viewMode: null == viewMode
          ? _value.viewMode
          : viewMode // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfigurationMode,
      commentMode: null == commentMode
          ? _value.commentMode
          : commentMode // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfigurationMode,
      shareMode: null == shareMode
          ? _value.shareMode
          : shareMode // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfigurationMode,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivitySecurityConfigurationModeCopyWith<$Res> get viewMode {
    return $ActivitySecurityConfigurationModeCopyWith<$Res>(_value.viewMode,
        (value) {
      return _then(_value.copyWith(viewMode: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivitySecurityConfigurationModeCopyWith<$Res> get commentMode {
    return $ActivitySecurityConfigurationModeCopyWith<$Res>(_value.commentMode,
        (value) {
      return _then(_value.copyWith(commentMode: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivitySecurityConfigurationModeCopyWith<$Res> get shareMode {
    return $ActivitySecurityConfigurationModeCopyWith<$Res>(_value.shareMode,
        (value) {
      return _then(_value.copyWith(shareMode: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivitySecurityConfigurationImplCopyWith<$Res>
    implements $ActivitySecurityConfigurationCopyWith<$Res> {
  factory _$$ActivitySecurityConfigurationImplCopyWith(
          _$ActivitySecurityConfigurationImpl value,
          $Res Function(_$ActivitySecurityConfigurationImpl) then) =
      __$$ActivitySecurityConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String context,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      ActivitySecurityConfigurationMode viewMode,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      ActivitySecurityConfigurationMode commentMode,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      ActivitySecurityConfigurationMode shareMode});

  @override
  $ActivitySecurityConfigurationModeCopyWith<$Res> get viewMode;
  @override
  $ActivitySecurityConfigurationModeCopyWith<$Res> get commentMode;
  @override
  $ActivitySecurityConfigurationModeCopyWith<$Res> get shareMode;
}

/// @nodoc
class __$$ActivitySecurityConfigurationImplCopyWithImpl<$Res>
    extends _$ActivitySecurityConfigurationCopyWithImpl<$Res,
        _$ActivitySecurityConfigurationImpl>
    implements _$$ActivitySecurityConfigurationImplCopyWith<$Res> {
  __$$ActivitySecurityConfigurationImplCopyWithImpl(
      _$ActivitySecurityConfigurationImpl _value,
      $Res Function(_$ActivitySecurityConfigurationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
    Object? viewMode = null,
    Object? commentMode = null,
    Object? shareMode = null,
  }) {
    return _then(_$ActivitySecurityConfigurationImpl(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String,
      viewMode: null == viewMode
          ? _value.viewMode
          : viewMode // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfigurationMode,
      commentMode: null == commentMode
          ? _value.commentMode
          : commentMode // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfigurationMode,
      shareMode: null == shareMode
          ? _value.shareMode
          : shareMode // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfigurationMode,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivitySecurityConfigurationImpl
    implements _ActivitySecurityConfiguration {
  const _$ActivitySecurityConfigurationImpl(
      {this.context = '',
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      this.viewMode = const ActivitySecurityConfigurationMode.private(),
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      this.commentMode = const ActivitySecurityConfigurationMode.signedIn(),
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      this.shareMode = const ActivitySecurityConfigurationMode.private()});

  factory _$ActivitySecurityConfigurationImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ActivitySecurityConfigurationImplFromJson(json);

  @override
  @JsonKey()
  final String context;
  @override
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  final ActivitySecurityConfigurationMode viewMode;
  @override
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  final ActivitySecurityConfigurationMode commentMode;
  @override
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  final ActivitySecurityConfigurationMode shareMode;

  @override
  String toString() {
    return 'ActivitySecurityConfiguration(context: $context, viewMode: $viewMode, commentMode: $commentMode, shareMode: $shareMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivitySecurityConfigurationImpl &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.viewMode, viewMode) ||
                other.viewMode == viewMode) &&
            (identical(other.commentMode, commentMode) ||
                other.commentMode == commentMode) &&
            (identical(other.shareMode, shareMode) ||
                other.shareMode == shareMode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, context, viewMode, commentMode, shareMode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivitySecurityConfigurationImplCopyWith<
          _$ActivitySecurityConfigurationImpl>
      get copyWith => __$$ActivitySecurityConfigurationImplCopyWithImpl<
          _$ActivitySecurityConfigurationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivitySecurityConfigurationImplToJson(
      this,
    );
  }
}

abstract class _ActivitySecurityConfiguration
    implements ActivitySecurityConfiguration {
  const factory _ActivitySecurityConfiguration(
          {final String context,
          @JsonKey(
              fromJson: ActivitySecurityConfigurationMode.fromJson,
              toJson: ActivitySecurityConfigurationMode.toJson)
          final ActivitySecurityConfigurationMode viewMode,
          @JsonKey(
              fromJson: ActivitySecurityConfigurationMode.fromJson,
              toJson: ActivitySecurityConfigurationMode.toJson)
          final ActivitySecurityConfigurationMode commentMode,
          @JsonKey(
              fromJson: ActivitySecurityConfigurationMode.fromJson,
              toJson: ActivitySecurityConfigurationMode.toJson)
          final ActivitySecurityConfigurationMode shareMode}) =
      _$ActivitySecurityConfigurationImpl;

  factory _ActivitySecurityConfiguration.fromJson(Map<String, dynamic> json) =
      _$ActivitySecurityConfigurationImpl.fromJson;

  @override
  String get context;
  @override
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  ActivitySecurityConfigurationMode get viewMode;
  @override
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  ActivitySecurityConfigurationMode get commentMode;
  @override
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  ActivitySecurityConfigurationMode get shareMode;
  @override
  @JsonKey(ignore: true)
  _$$ActivitySecurityConfigurationImplCopyWith<
          _$ActivitySecurityConfigurationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ActivitySecurityConfigurationMode {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() public,
    required TResult Function() followersAndConnections,
    required TResult Function() connections,
    required TResult Function() private,
    required TResult Function() signedIn,
    required TResult Function() disabled,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? public,
    TResult? Function()? followersAndConnections,
    TResult? Function()? connections,
    TResult? Function()? private,
    TResult? Function()? signedIn,
    TResult? Function()? disabled,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? public,
    TResult Function()? followersAndConnections,
    TResult Function()? connections,
    TResult Function()? private,
    TResult Function()? signedIn,
    TResult Function()? disabled,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivitySecurityConfigurationModePublic value)
        public,
    required TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)
        followersAndConnections,
    required TResult Function(
            _ActivitySecurityConfigurationModeConnections value)
        connections,
    required TResult Function(_ActivitySecurityConfigurationModePrivate value)
        private,
    required TResult Function(_ActivitySecurityConfigurationModeSignedIn value)
        signedIn,
    required TResult Function(_ActivitySecurityConfigurationModeDisabled value)
        disabled,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult? Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult? Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult? Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult? Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult? Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivitySecurityConfigurationModeCopyWith<$Res> {
  factory $ActivitySecurityConfigurationModeCopyWith(
          ActivitySecurityConfigurationMode value,
          $Res Function(ActivitySecurityConfigurationMode) then) =
      _$ActivitySecurityConfigurationModeCopyWithImpl<$Res,
          ActivitySecurityConfigurationMode>;
}

/// @nodoc
class _$ActivitySecurityConfigurationModeCopyWithImpl<$Res,
        $Val extends ActivitySecurityConfigurationMode>
    implements $ActivitySecurityConfigurationModeCopyWith<$Res> {
  _$ActivitySecurityConfigurationModeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ActivitySecurityConfigurationModePublicImplCopyWith<$Res> {
  factory _$$ActivitySecurityConfigurationModePublicImplCopyWith(
          _$ActivitySecurityConfigurationModePublicImpl value,
          $Res Function(_$ActivitySecurityConfigurationModePublicImpl) then) =
      __$$ActivitySecurityConfigurationModePublicImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivitySecurityConfigurationModePublicImplCopyWithImpl<$Res>
    extends _$ActivitySecurityConfigurationModeCopyWithImpl<$Res,
        _$ActivitySecurityConfigurationModePublicImpl>
    implements _$$ActivitySecurityConfigurationModePublicImplCopyWith<$Res> {
  __$$ActivitySecurityConfigurationModePublicImplCopyWithImpl(
      _$ActivitySecurityConfigurationModePublicImpl _value,
      $Res Function(_$ActivitySecurityConfigurationModePublicImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivitySecurityConfigurationModePublicImpl
    implements _ActivitySecurityConfigurationModePublic {
  const _$ActivitySecurityConfigurationModePublicImpl();

  @override
  String toString() {
    return 'ActivitySecurityConfigurationMode.public()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivitySecurityConfigurationModePublicImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() public,
    required TResult Function() followersAndConnections,
    required TResult Function() connections,
    required TResult Function() private,
    required TResult Function() signedIn,
    required TResult Function() disabled,
  }) {
    return public();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? public,
    TResult? Function()? followersAndConnections,
    TResult? Function()? connections,
    TResult? Function()? private,
    TResult? Function()? signedIn,
    TResult? Function()? disabled,
  }) {
    return public?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? public,
    TResult Function()? followersAndConnections,
    TResult Function()? connections,
    TResult Function()? private,
    TResult Function()? signedIn,
    TResult Function()? disabled,
    required TResult orElse(),
  }) {
    if (public != null) {
      return public();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivitySecurityConfigurationModePublic value)
        public,
    required TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)
        followersAndConnections,
    required TResult Function(
            _ActivitySecurityConfigurationModeConnections value)
        connections,
    required TResult Function(_ActivitySecurityConfigurationModePrivate value)
        private,
    required TResult Function(_ActivitySecurityConfigurationModeSignedIn value)
        signedIn,
    required TResult Function(_ActivitySecurityConfigurationModeDisabled value)
        disabled,
  }) {
    return public(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult? Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult? Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult? Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult? Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult? Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
  }) {
    return public?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
    required TResult orElse(),
  }) {
    if (public != null) {
      return public(this);
    }
    return orElse();
  }
}

abstract class _ActivitySecurityConfigurationModePublic
    implements ActivitySecurityConfigurationMode {
  const factory _ActivitySecurityConfigurationModePublic() =
      _$ActivitySecurityConfigurationModePublicImpl;
}

/// @nodoc
abstract class _$$ActivitySecurityConfigurationModeFollowersAndConnectionsImplCopyWith<
    $Res> {
  factory _$$ActivitySecurityConfigurationModeFollowersAndConnectionsImplCopyWith(
          _$ActivitySecurityConfigurationModeFollowersAndConnectionsImpl value,
          $Res Function(
                  _$ActivitySecurityConfigurationModeFollowersAndConnectionsImpl)
              then) =
      __$$ActivitySecurityConfigurationModeFollowersAndConnectionsImplCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$ActivitySecurityConfigurationModeFollowersAndConnectionsImplCopyWithImpl<
        $Res>
    extends _$ActivitySecurityConfigurationModeCopyWithImpl<$Res,
        _$ActivitySecurityConfigurationModeFollowersAndConnectionsImpl>
    implements
        _$$ActivitySecurityConfigurationModeFollowersAndConnectionsImplCopyWith<
            $Res> {
  __$$ActivitySecurityConfigurationModeFollowersAndConnectionsImplCopyWithImpl(
      _$ActivitySecurityConfigurationModeFollowersAndConnectionsImpl _value,
      $Res Function(
              _$ActivitySecurityConfigurationModeFollowersAndConnectionsImpl)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivitySecurityConfigurationModeFollowersAndConnectionsImpl
    implements _ActivitySecurityConfigurationModeFollowersAndConnections {
  const _$ActivitySecurityConfigurationModeFollowersAndConnectionsImpl();

  @override
  String toString() {
    return 'ActivitySecurityConfigurationMode.followersAndConnections()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$ActivitySecurityConfigurationModeFollowersAndConnectionsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() public,
    required TResult Function() followersAndConnections,
    required TResult Function() connections,
    required TResult Function() private,
    required TResult Function() signedIn,
    required TResult Function() disabled,
  }) {
    return followersAndConnections();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? public,
    TResult? Function()? followersAndConnections,
    TResult? Function()? connections,
    TResult? Function()? private,
    TResult? Function()? signedIn,
    TResult? Function()? disabled,
  }) {
    return followersAndConnections?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? public,
    TResult Function()? followersAndConnections,
    TResult Function()? connections,
    TResult Function()? private,
    TResult Function()? signedIn,
    TResult Function()? disabled,
    required TResult orElse(),
  }) {
    if (followersAndConnections != null) {
      return followersAndConnections();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivitySecurityConfigurationModePublic value)
        public,
    required TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)
        followersAndConnections,
    required TResult Function(
            _ActivitySecurityConfigurationModeConnections value)
        connections,
    required TResult Function(_ActivitySecurityConfigurationModePrivate value)
        private,
    required TResult Function(_ActivitySecurityConfigurationModeSignedIn value)
        signedIn,
    required TResult Function(_ActivitySecurityConfigurationModeDisabled value)
        disabled,
  }) {
    return followersAndConnections(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult? Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult? Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult? Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult? Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult? Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
  }) {
    return followersAndConnections?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
    required TResult orElse(),
  }) {
    if (followersAndConnections != null) {
      return followersAndConnections(this);
    }
    return orElse();
  }
}

abstract class _ActivitySecurityConfigurationModeFollowersAndConnections
    implements ActivitySecurityConfigurationMode {
  const factory _ActivitySecurityConfigurationModeFollowersAndConnections() =
      _$ActivitySecurityConfigurationModeFollowersAndConnectionsImpl;
}

/// @nodoc
abstract class _$$ActivitySecurityConfigurationModeConnectionsImplCopyWith<
    $Res> {
  factory _$$ActivitySecurityConfigurationModeConnectionsImplCopyWith(
          _$ActivitySecurityConfigurationModeConnectionsImpl value,
          $Res Function(_$ActivitySecurityConfigurationModeConnectionsImpl)
              then) =
      __$$ActivitySecurityConfigurationModeConnectionsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivitySecurityConfigurationModeConnectionsImplCopyWithImpl<$Res>
    extends _$ActivitySecurityConfigurationModeCopyWithImpl<$Res,
        _$ActivitySecurityConfigurationModeConnectionsImpl>
    implements
        _$$ActivitySecurityConfigurationModeConnectionsImplCopyWith<$Res> {
  __$$ActivitySecurityConfigurationModeConnectionsImplCopyWithImpl(
      _$ActivitySecurityConfigurationModeConnectionsImpl _value,
      $Res Function(_$ActivitySecurityConfigurationModeConnectionsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivitySecurityConfigurationModeConnectionsImpl
    implements _ActivitySecurityConfigurationModeConnections {
  const _$ActivitySecurityConfigurationModeConnectionsImpl();

  @override
  String toString() {
    return 'ActivitySecurityConfigurationMode.connections()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivitySecurityConfigurationModeConnectionsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() public,
    required TResult Function() followersAndConnections,
    required TResult Function() connections,
    required TResult Function() private,
    required TResult Function() signedIn,
    required TResult Function() disabled,
  }) {
    return connections();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? public,
    TResult? Function()? followersAndConnections,
    TResult? Function()? connections,
    TResult? Function()? private,
    TResult? Function()? signedIn,
    TResult? Function()? disabled,
  }) {
    return connections?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? public,
    TResult Function()? followersAndConnections,
    TResult Function()? connections,
    TResult Function()? private,
    TResult Function()? signedIn,
    TResult Function()? disabled,
    required TResult orElse(),
  }) {
    if (connections != null) {
      return connections();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivitySecurityConfigurationModePublic value)
        public,
    required TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)
        followersAndConnections,
    required TResult Function(
            _ActivitySecurityConfigurationModeConnections value)
        connections,
    required TResult Function(_ActivitySecurityConfigurationModePrivate value)
        private,
    required TResult Function(_ActivitySecurityConfigurationModeSignedIn value)
        signedIn,
    required TResult Function(_ActivitySecurityConfigurationModeDisabled value)
        disabled,
  }) {
    return connections(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult? Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult? Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult? Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult? Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult? Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
  }) {
    return connections?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
    required TResult orElse(),
  }) {
    if (connections != null) {
      return connections(this);
    }
    return orElse();
  }
}

abstract class _ActivitySecurityConfigurationModeConnections
    implements ActivitySecurityConfigurationMode {
  const factory _ActivitySecurityConfigurationModeConnections() =
      _$ActivitySecurityConfigurationModeConnectionsImpl;
}

/// @nodoc
abstract class _$$ActivitySecurityConfigurationModePrivateImplCopyWith<$Res> {
  factory _$$ActivitySecurityConfigurationModePrivateImplCopyWith(
          _$ActivitySecurityConfigurationModePrivateImpl value,
          $Res Function(_$ActivitySecurityConfigurationModePrivateImpl) then) =
      __$$ActivitySecurityConfigurationModePrivateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivitySecurityConfigurationModePrivateImplCopyWithImpl<$Res>
    extends _$ActivitySecurityConfigurationModeCopyWithImpl<$Res,
        _$ActivitySecurityConfigurationModePrivateImpl>
    implements _$$ActivitySecurityConfigurationModePrivateImplCopyWith<$Res> {
  __$$ActivitySecurityConfigurationModePrivateImplCopyWithImpl(
      _$ActivitySecurityConfigurationModePrivateImpl _value,
      $Res Function(_$ActivitySecurityConfigurationModePrivateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivitySecurityConfigurationModePrivateImpl
    implements _ActivitySecurityConfigurationModePrivate {
  const _$ActivitySecurityConfigurationModePrivateImpl();

  @override
  String toString() {
    return 'ActivitySecurityConfigurationMode.private()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivitySecurityConfigurationModePrivateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() public,
    required TResult Function() followersAndConnections,
    required TResult Function() connections,
    required TResult Function() private,
    required TResult Function() signedIn,
    required TResult Function() disabled,
  }) {
    return private();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? public,
    TResult? Function()? followersAndConnections,
    TResult? Function()? connections,
    TResult? Function()? private,
    TResult? Function()? signedIn,
    TResult? Function()? disabled,
  }) {
    return private?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? public,
    TResult Function()? followersAndConnections,
    TResult Function()? connections,
    TResult Function()? private,
    TResult Function()? signedIn,
    TResult Function()? disabled,
    required TResult orElse(),
  }) {
    if (private != null) {
      return private();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivitySecurityConfigurationModePublic value)
        public,
    required TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)
        followersAndConnections,
    required TResult Function(
            _ActivitySecurityConfigurationModeConnections value)
        connections,
    required TResult Function(_ActivitySecurityConfigurationModePrivate value)
        private,
    required TResult Function(_ActivitySecurityConfigurationModeSignedIn value)
        signedIn,
    required TResult Function(_ActivitySecurityConfigurationModeDisabled value)
        disabled,
  }) {
    return private(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult? Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult? Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult? Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult? Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult? Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
  }) {
    return private?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
    required TResult orElse(),
  }) {
    if (private != null) {
      return private(this);
    }
    return orElse();
  }
}

abstract class _ActivitySecurityConfigurationModePrivate
    implements ActivitySecurityConfigurationMode {
  const factory _ActivitySecurityConfigurationModePrivate() =
      _$ActivitySecurityConfigurationModePrivateImpl;
}

/// @nodoc
abstract class _$$ActivitySecurityConfigurationModeSignedInImplCopyWith<$Res> {
  factory _$$ActivitySecurityConfigurationModeSignedInImplCopyWith(
          _$ActivitySecurityConfigurationModeSignedInImpl value,
          $Res Function(_$ActivitySecurityConfigurationModeSignedInImpl) then) =
      __$$ActivitySecurityConfigurationModeSignedInImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivitySecurityConfigurationModeSignedInImplCopyWithImpl<$Res>
    extends _$ActivitySecurityConfigurationModeCopyWithImpl<$Res,
        _$ActivitySecurityConfigurationModeSignedInImpl>
    implements _$$ActivitySecurityConfigurationModeSignedInImplCopyWith<$Res> {
  __$$ActivitySecurityConfigurationModeSignedInImplCopyWithImpl(
      _$ActivitySecurityConfigurationModeSignedInImpl _value,
      $Res Function(_$ActivitySecurityConfigurationModeSignedInImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivitySecurityConfigurationModeSignedInImpl
    implements _ActivitySecurityConfigurationModeSignedIn {
  const _$ActivitySecurityConfigurationModeSignedInImpl();

  @override
  String toString() {
    return 'ActivitySecurityConfigurationMode.signedIn()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivitySecurityConfigurationModeSignedInImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() public,
    required TResult Function() followersAndConnections,
    required TResult Function() connections,
    required TResult Function() private,
    required TResult Function() signedIn,
    required TResult Function() disabled,
  }) {
    return signedIn();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? public,
    TResult? Function()? followersAndConnections,
    TResult? Function()? connections,
    TResult? Function()? private,
    TResult? Function()? signedIn,
    TResult? Function()? disabled,
  }) {
    return signedIn?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? public,
    TResult Function()? followersAndConnections,
    TResult Function()? connections,
    TResult Function()? private,
    TResult Function()? signedIn,
    TResult Function()? disabled,
    required TResult orElse(),
  }) {
    if (signedIn != null) {
      return signedIn();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivitySecurityConfigurationModePublic value)
        public,
    required TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)
        followersAndConnections,
    required TResult Function(
            _ActivitySecurityConfigurationModeConnections value)
        connections,
    required TResult Function(_ActivitySecurityConfigurationModePrivate value)
        private,
    required TResult Function(_ActivitySecurityConfigurationModeSignedIn value)
        signedIn,
    required TResult Function(_ActivitySecurityConfigurationModeDisabled value)
        disabled,
  }) {
    return signedIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult? Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult? Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult? Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult? Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult? Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
  }) {
    return signedIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
    required TResult orElse(),
  }) {
    if (signedIn != null) {
      return signedIn(this);
    }
    return orElse();
  }
}

abstract class _ActivitySecurityConfigurationModeSignedIn
    implements ActivitySecurityConfigurationMode {
  const factory _ActivitySecurityConfigurationModeSignedIn() =
      _$ActivitySecurityConfigurationModeSignedInImpl;
}

/// @nodoc
abstract class _$$ActivitySecurityConfigurationModeDisabledImplCopyWith<$Res> {
  factory _$$ActivitySecurityConfigurationModeDisabledImplCopyWith(
          _$ActivitySecurityConfigurationModeDisabledImpl value,
          $Res Function(_$ActivitySecurityConfigurationModeDisabledImpl) then) =
      __$$ActivitySecurityConfigurationModeDisabledImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivitySecurityConfigurationModeDisabledImplCopyWithImpl<$Res>
    extends _$ActivitySecurityConfigurationModeCopyWithImpl<$Res,
        _$ActivitySecurityConfigurationModeDisabledImpl>
    implements _$$ActivitySecurityConfigurationModeDisabledImplCopyWith<$Res> {
  __$$ActivitySecurityConfigurationModeDisabledImplCopyWithImpl(
      _$ActivitySecurityConfigurationModeDisabledImpl _value,
      $Res Function(_$ActivitySecurityConfigurationModeDisabledImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivitySecurityConfigurationModeDisabledImpl
    implements _ActivitySecurityConfigurationModeDisabled {
  const _$ActivitySecurityConfigurationModeDisabledImpl();

  @override
  String toString() {
    return 'ActivitySecurityConfigurationMode.disabled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivitySecurityConfigurationModeDisabledImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() public,
    required TResult Function() followersAndConnections,
    required TResult Function() connections,
    required TResult Function() private,
    required TResult Function() signedIn,
    required TResult Function() disabled,
  }) {
    return disabled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? public,
    TResult? Function()? followersAndConnections,
    TResult? Function()? connections,
    TResult? Function()? private,
    TResult? Function()? signedIn,
    TResult? Function()? disabled,
  }) {
    return disabled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? public,
    TResult Function()? followersAndConnections,
    TResult Function()? connections,
    TResult Function()? private,
    TResult Function()? signedIn,
    TResult Function()? disabled,
    required TResult orElse(),
  }) {
    if (disabled != null) {
      return disabled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivitySecurityConfigurationModePublic value)
        public,
    required TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)
        followersAndConnections,
    required TResult Function(
            _ActivitySecurityConfigurationModeConnections value)
        connections,
    required TResult Function(_ActivitySecurityConfigurationModePrivate value)
        private,
    required TResult Function(_ActivitySecurityConfigurationModeSignedIn value)
        signedIn,
    required TResult Function(_ActivitySecurityConfigurationModeDisabled value)
        disabled,
  }) {
    return disabled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult? Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult? Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult? Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult? Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult? Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
  }) {
    return disabled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivitySecurityConfigurationModePublic value)? public,
    TResult Function(
            _ActivitySecurityConfigurationModeFollowersAndConnections value)?
        followersAndConnections,
    TResult Function(_ActivitySecurityConfigurationModeConnections value)?
        connections,
    TResult Function(_ActivitySecurityConfigurationModePrivate value)? private,
    TResult Function(_ActivitySecurityConfigurationModeSignedIn value)?
        signedIn,
    TResult Function(_ActivitySecurityConfigurationModeDisabled value)?
        disabled,
    required TResult orElse(),
  }) {
    if (disabled != null) {
      return disabled(this);
    }
    return orElse();
  }
}

abstract class _ActivitySecurityConfigurationModeDisabled
    implements ActivitySecurityConfigurationMode {
  const factory _ActivitySecurityConfigurationModeDisabled() =
      _$ActivitySecurityConfigurationModeDisabledImpl;
}

ActivityEventConfiguration _$ActivityEventConfigurationFromJson(
    Map<String, dynamic> json) {
  return _ActivityEventConfiguration.fromJson(json);
}

/// @nodoc
mixin _$ActivityEventConfiguration {
  dynamic get venue => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  ActivitySchedule? get schedule => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  int get popularityScore => throw _privateConstructorUsedError;
  bool get isCancelled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityEventConfigurationCopyWith<ActivityEventConfiguration>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityEventConfigurationCopyWith<$Res> {
  factory $ActivityEventConfigurationCopyWith(ActivityEventConfiguration value,
          $Res Function(ActivityEventConfiguration) then) =
      _$ActivityEventConfigurationCopyWithImpl<$Res,
          ActivityEventConfiguration>;
  @useResult
  $Res call(
      {dynamic venue,
      String name,
      ActivitySchedule? schedule,
      String location,
      int popularityScore,
      bool isCancelled});

  $ActivityScheduleCopyWith<$Res>? get schedule;
}

/// @nodoc
class _$ActivityEventConfigurationCopyWithImpl<$Res,
        $Val extends ActivityEventConfiguration>
    implements $ActivityEventConfigurationCopyWith<$Res> {
  _$ActivityEventConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venue = freezed,
    Object? name = null,
    Object? schedule = freezed,
    Object? location = null,
    Object? popularityScore = null,
    Object? isCancelled = null,
  }) {
    return _then(_value.copyWith(
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      schedule: freezed == schedule
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as ActivitySchedule?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      popularityScore: null == popularityScore
          ? _value.popularityScore
          : popularityScore // ignore: cast_nullable_to_non_nullable
              as int,
      isCancelled: null == isCancelled
          ? _value.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityScheduleCopyWith<$Res>? get schedule {
    if (_value.schedule == null) {
      return null;
    }

    return $ActivityScheduleCopyWith<$Res>(_value.schedule!, (value) {
      return _then(_value.copyWith(schedule: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityEventConfigurationImplCopyWith<$Res>
    implements $ActivityEventConfigurationCopyWith<$Res> {
  factory _$$ActivityEventConfigurationImplCopyWith(
          _$ActivityEventConfigurationImpl value,
          $Res Function(_$ActivityEventConfigurationImpl) then) =
      __$$ActivityEventConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {dynamic venue,
      String name,
      ActivitySchedule? schedule,
      String location,
      int popularityScore,
      bool isCancelled});

  @override
  $ActivityScheduleCopyWith<$Res>? get schedule;
}

/// @nodoc
class __$$ActivityEventConfigurationImplCopyWithImpl<$Res>
    extends _$ActivityEventConfigurationCopyWithImpl<$Res,
        _$ActivityEventConfigurationImpl>
    implements _$$ActivityEventConfigurationImplCopyWith<$Res> {
  __$$ActivityEventConfigurationImplCopyWithImpl(
      _$ActivityEventConfigurationImpl _value,
      $Res Function(_$ActivityEventConfigurationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venue = freezed,
    Object? name = null,
    Object? schedule = freezed,
    Object? location = null,
    Object? popularityScore = null,
    Object? isCancelled = null,
  }) {
    return _then(_$ActivityEventConfigurationImpl(
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      schedule: freezed == schedule
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as ActivitySchedule?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      popularityScore: null == popularityScore
          ? _value.popularityScore
          : popularityScore // ignore: cast_nullable_to_non_nullable
              as int,
      isCancelled: null == isCancelled
          ? _value.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityEventConfigurationImpl implements _ActivityEventConfiguration {
  const _$ActivityEventConfigurationImpl(
      {this.venue,
      this.name = '',
      this.schedule,
      this.location = '',
      this.popularityScore = 0,
      this.isCancelled = false});

  factory _$ActivityEventConfigurationImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ActivityEventConfigurationImplFromJson(json);

  @override
  final dynamic venue;
  @override
  @JsonKey()
  final String name;
  @override
  final ActivitySchedule? schedule;
  @override
  @JsonKey()
  final String location;
  @override
  @JsonKey()
  final int popularityScore;
  @override
  @JsonKey()
  final bool isCancelled;

  @override
  String toString() {
    return 'ActivityEventConfiguration(venue: $venue, name: $name, schedule: $schedule, location: $location, popularityScore: $popularityScore, isCancelled: $isCancelled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEventConfigurationImpl &&
            const DeepCollectionEquality().equals(other.venue, venue) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.popularityScore, popularityScore) ||
                other.popularityScore == popularityScore) &&
            (identical(other.isCancelled, isCancelled) ||
                other.isCancelled == isCancelled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(venue),
      name,
      schedule,
      location,
      popularityScore,
      isCancelled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityEventConfigurationImplCopyWith<_$ActivityEventConfigurationImpl>
      get copyWith => __$$ActivityEventConfigurationImplCopyWithImpl<
          _$ActivityEventConfigurationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityEventConfigurationImplToJson(
      this,
    );
  }
}

abstract class _ActivityEventConfiguration
    implements ActivityEventConfiguration {
  const factory _ActivityEventConfiguration(
      {final dynamic venue,
      final String name,
      final ActivitySchedule? schedule,
      final String location,
      final int popularityScore,
      final bool isCancelled}) = _$ActivityEventConfigurationImpl;

  factory _ActivityEventConfiguration.fromJson(Map<String, dynamic> json) =
      _$ActivityEventConfigurationImpl.fromJson;

  @override
  dynamic get venue;
  @override
  String get name;
  @override
  ActivitySchedule? get schedule;
  @override
  String get location;
  @override
  int get popularityScore;
  @override
  bool get isCancelled;
  @override
  @JsonKey(ignore: true)
  _$$ActivityEventConfigurationImplCopyWith<_$ActivityEventConfigurationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ActivitySchedule _$ActivityScheduleFromJson(Map<String, dynamic> json) {
  return _ActivitySchedule.fromJson(json);
}

/// @nodoc
mixin _$ActivitySchedule {
  String get recurrenceRule => throw _privateConstructorUsedError;
  DateTime? get start => throw _privateConstructorUsedError;
  DateTime? get end => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityScheduleCopyWith<ActivitySchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityScheduleCopyWith<$Res> {
  factory $ActivityScheduleCopyWith(
          ActivitySchedule value, $Res Function(ActivitySchedule) then) =
      _$ActivityScheduleCopyWithImpl<$Res, ActivitySchedule>;
  @useResult
  $Res call({String recurrenceRule, DateTime? start, DateTime? end});
}

/// @nodoc
class _$ActivityScheduleCopyWithImpl<$Res, $Val extends ActivitySchedule>
    implements $ActivityScheduleCopyWith<$Res> {
  _$ActivityScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recurrenceRule = null,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(_value.copyWith(
      recurrenceRule: null == recurrenceRule
          ? _value.recurrenceRule
          : recurrenceRule // ignore: cast_nullable_to_non_nullable
              as String,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityScheduleImplCopyWith<$Res>
    implements $ActivityScheduleCopyWith<$Res> {
  factory _$$ActivityScheduleImplCopyWith(_$ActivityScheduleImpl value,
          $Res Function(_$ActivityScheduleImpl) then) =
      __$$ActivityScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String recurrenceRule, DateTime? start, DateTime? end});
}

/// @nodoc
class __$$ActivityScheduleImplCopyWithImpl<$Res>
    extends _$ActivityScheduleCopyWithImpl<$Res, _$ActivityScheduleImpl>
    implements _$$ActivityScheduleImplCopyWith<$Res> {
  __$$ActivityScheduleImplCopyWithImpl(_$ActivityScheduleImpl _value,
      $Res Function(_$ActivityScheduleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recurrenceRule = null,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(_$ActivityScheduleImpl(
      recurrenceRule: null == recurrenceRule
          ? _value.recurrenceRule
          : recurrenceRule // ignore: cast_nullable_to_non_nullable
              as String,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityScheduleImpl implements _ActivitySchedule {
  const _$ActivityScheduleImpl(
      {this.recurrenceRule = '', this.start, this.end});

  factory _$ActivityScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityScheduleImplFromJson(json);

  @override
  @JsonKey()
  final String recurrenceRule;
  @override
  final DateTime? start;
  @override
  final DateTime? end;

  @override
  String toString() {
    return 'ActivitySchedule(recurrenceRule: $recurrenceRule, start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityScheduleImpl &&
            (identical(other.recurrenceRule, recurrenceRule) ||
                other.recurrenceRule == recurrenceRule) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, recurrenceRule, start, end);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityScheduleImplCopyWith<_$ActivityScheduleImpl> get copyWith =>
      __$$ActivityScheduleImplCopyWithImpl<_$ActivityScheduleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityScheduleImplToJson(
      this,
    );
  }
}

abstract class _ActivitySchedule implements ActivitySchedule {
  const factory _ActivitySchedule(
      {final String recurrenceRule,
      final DateTime? start,
      final DateTime? end}) = _$ActivityScheduleImpl;

  factory _ActivitySchedule.fromJson(Map<String, dynamic> json) =
      _$ActivityScheduleImpl.fromJson;

  @override
  String get recurrenceRule;
  @override
  DateTime? get start;
  @override
  DateTime? get end;
  @override
  @JsonKey(ignore: true)
  _$$ActivityScheduleImplCopyWith<_$ActivityScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityPricingInformation _$ActivityPricingInformationFromJson(
    Map<String, dynamic> json) {
  return _ActivityPricingInformation.fromJson(json);
}

/// @nodoc
mixin _$ActivityPricingInformation {
  String get productId => throw _privateConstructorUsedError;
  ActivityPricingExternalStoreInformation? get externalStoreInformation =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityPricingInformationCopyWith<ActivityPricingInformation>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityPricingInformationCopyWith<$Res> {
  factory $ActivityPricingInformationCopyWith(ActivityPricingInformation value,
          $Res Function(ActivityPricingInformation) then) =
      _$ActivityPricingInformationCopyWithImpl<$Res,
          ActivityPricingInformation>;
  @useResult
  $Res call(
      {String productId,
      ActivityPricingExternalStoreInformation? externalStoreInformation});

  $ActivityPricingExternalStoreInformationCopyWith<$Res>?
      get externalStoreInformation;
}

/// @nodoc
class _$ActivityPricingInformationCopyWithImpl<$Res,
        $Val extends ActivityPricingInformation>
    implements $ActivityPricingInformationCopyWith<$Res> {
  _$ActivityPricingInformationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? externalStoreInformation = freezed,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      externalStoreInformation: freezed == externalStoreInformation
          ? _value.externalStoreInformation
          : externalStoreInformation // ignore: cast_nullable_to_non_nullable
              as ActivityPricingExternalStoreInformation?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityPricingExternalStoreInformationCopyWith<$Res>?
      get externalStoreInformation {
    if (_value.externalStoreInformation == null) {
      return null;
    }

    return $ActivityPricingExternalStoreInformationCopyWith<$Res>(
        _value.externalStoreInformation!, (value) {
      return _then(_value.copyWith(externalStoreInformation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityPricingInformationImplCopyWith<$Res>
    implements $ActivityPricingInformationCopyWith<$Res> {
  factory _$$ActivityPricingInformationImplCopyWith(
          _$ActivityPricingInformationImpl value,
          $Res Function(_$ActivityPricingInformationImpl) then) =
      __$$ActivityPricingInformationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      ActivityPricingExternalStoreInformation? externalStoreInformation});

  @override
  $ActivityPricingExternalStoreInformationCopyWith<$Res>?
      get externalStoreInformation;
}

/// @nodoc
class __$$ActivityPricingInformationImplCopyWithImpl<$Res>
    extends _$ActivityPricingInformationCopyWithImpl<$Res,
        _$ActivityPricingInformationImpl>
    implements _$$ActivityPricingInformationImplCopyWith<$Res> {
  __$$ActivityPricingInformationImplCopyWithImpl(
      _$ActivityPricingInformationImpl _value,
      $Res Function(_$ActivityPricingInformationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? externalStoreInformation = freezed,
  }) {
    return _then(_$ActivityPricingInformationImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      externalStoreInformation: freezed == externalStoreInformation
          ? _value.externalStoreInformation
          : externalStoreInformation // ignore: cast_nullable_to_non_nullable
              as ActivityPricingExternalStoreInformation?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityPricingInformationImpl implements _ActivityPricingInformation {
  const _$ActivityPricingInformationImpl(
      {this.productId = '', this.externalStoreInformation});

  factory _$ActivityPricingInformationImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ActivityPricingInformationImplFromJson(json);

  @override
  @JsonKey()
  final String productId;
  @override
  final ActivityPricingExternalStoreInformation? externalStoreInformation;

  @override
  String toString() {
    return 'ActivityPricingInformation(productId: $productId, externalStoreInformation: $externalStoreInformation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityPricingInformationImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(
                    other.externalStoreInformation, externalStoreInformation) ||
                other.externalStoreInformation == externalStoreInformation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, externalStoreInformation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityPricingInformationImplCopyWith<_$ActivityPricingInformationImpl>
      get copyWith => __$$ActivityPricingInformationImplCopyWithImpl<
          _$ActivityPricingInformationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityPricingInformationImplToJson(
      this,
    );
  }
}

abstract class _ActivityPricingInformation
    implements ActivityPricingInformation {
  const factory _ActivityPricingInformation(
      {final String productId,
      final ActivityPricingExternalStoreInformation?
          externalStoreInformation}) = _$ActivityPricingInformationImpl;

  factory _ActivityPricingInformation.fromJson(Map<String, dynamic> json) =
      _$ActivityPricingInformationImpl.fromJson;

  @override
  String get productId;
  @override
  ActivityPricingExternalStoreInformation? get externalStoreInformation;
  @override
  @JsonKey(ignore: true)
  _$$ActivityPricingInformationImplCopyWith<_$ActivityPricingInformationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ActivityPricingExternalStoreInformation
    _$ActivityPricingExternalStoreInformationFromJson(
        Map<String, dynamic> json) {
  return _ActivityPricingExternalStoreInformation.fromJson(json);
}

/// @nodoc
mixin _$ActivityPricingExternalStoreInformation {
  String get costExact => throw _privateConstructorUsedError;
  String get costMinimum => throw _privateConstructorUsedError;
  String get costMaximum => throw _privateConstructorUsedError;
  @JsonKey(
      toJson: ActivityPricingExternalStoreInformationPricingStrategy.toJson,
      fromJson: ActivityPricingExternalStoreInformationPricingStrategy.fromJson)
  ActivityPricingExternalStoreInformationPricingStrategy get pricingStrategy =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityPricingExternalStoreInformationCopyWith<
          ActivityPricingExternalStoreInformation>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityPricingExternalStoreInformationCopyWith<$Res> {
  factory $ActivityPricingExternalStoreInformationCopyWith(
          ActivityPricingExternalStoreInformation value,
          $Res Function(ActivityPricingExternalStoreInformation) then) =
      _$ActivityPricingExternalStoreInformationCopyWithImpl<$Res,
          ActivityPricingExternalStoreInformation>;
  @useResult
  $Res call(
      {String costExact,
      String costMinimum,
      String costMaximum,
      @JsonKey(
          toJson: ActivityPricingExternalStoreInformationPricingStrategy.toJson,
          fromJson:
              ActivityPricingExternalStoreInformationPricingStrategy.fromJson)
      ActivityPricingExternalStoreInformationPricingStrategy pricingStrategy});

  $ActivityPricingExternalStoreInformationPricingStrategyCopyWith<$Res>
      get pricingStrategy;
}

/// @nodoc
class _$ActivityPricingExternalStoreInformationCopyWithImpl<$Res,
        $Val extends ActivityPricingExternalStoreInformation>
    implements $ActivityPricingExternalStoreInformationCopyWith<$Res> {
  _$ActivityPricingExternalStoreInformationCopyWithImpl(
      this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? costExact = null,
    Object? costMinimum = null,
    Object? costMaximum = null,
    Object? pricingStrategy = null,
  }) {
    return _then(_value.copyWith(
      costExact: null == costExact
          ? _value.costExact
          : costExact // ignore: cast_nullable_to_non_nullable
              as String,
      costMinimum: null == costMinimum
          ? _value.costMinimum
          : costMinimum // ignore: cast_nullable_to_non_nullable
              as String,
      costMaximum: null == costMaximum
          ? _value.costMaximum
          : costMaximum // ignore: cast_nullable_to_non_nullable
              as String,
      pricingStrategy: null == pricingStrategy
          ? _value.pricingStrategy
          : pricingStrategy // ignore: cast_nullable_to_non_nullable
              as ActivityPricingExternalStoreInformationPricingStrategy,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivityPricingExternalStoreInformationPricingStrategyCopyWith<$Res>
      get pricingStrategy {
    return $ActivityPricingExternalStoreInformationPricingStrategyCopyWith<
        $Res>(_value.pricingStrategy, (value) {
      return _then(_value.copyWith(pricingStrategy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityPricingExternalStoreInformationImplCopyWith<$Res>
    implements $ActivityPricingExternalStoreInformationCopyWith<$Res> {
  factory _$$ActivityPricingExternalStoreInformationImplCopyWith(
          _$ActivityPricingExternalStoreInformationImpl value,
          $Res Function(_$ActivityPricingExternalStoreInformationImpl) then) =
      __$$ActivityPricingExternalStoreInformationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String costExact,
      String costMinimum,
      String costMaximum,
      @JsonKey(
          toJson: ActivityPricingExternalStoreInformationPricingStrategy.toJson,
          fromJson:
              ActivityPricingExternalStoreInformationPricingStrategy.fromJson)
      ActivityPricingExternalStoreInformationPricingStrategy pricingStrategy});

  @override
  $ActivityPricingExternalStoreInformationPricingStrategyCopyWith<$Res>
      get pricingStrategy;
}

/// @nodoc
class __$$ActivityPricingExternalStoreInformationImplCopyWithImpl<$Res>
    extends _$ActivityPricingExternalStoreInformationCopyWithImpl<$Res,
        _$ActivityPricingExternalStoreInformationImpl>
    implements _$$ActivityPricingExternalStoreInformationImplCopyWith<$Res> {
  __$$ActivityPricingExternalStoreInformationImplCopyWithImpl(
      _$ActivityPricingExternalStoreInformationImpl _value,
      $Res Function(_$ActivityPricingExternalStoreInformationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? costExact = null,
    Object? costMinimum = null,
    Object? costMaximum = null,
    Object? pricingStrategy = null,
  }) {
    return _then(_$ActivityPricingExternalStoreInformationImpl(
      costExact: null == costExact
          ? _value.costExact
          : costExact // ignore: cast_nullable_to_non_nullable
              as String,
      costMinimum: null == costMinimum
          ? _value.costMinimum
          : costMinimum // ignore: cast_nullable_to_non_nullable
              as String,
      costMaximum: null == costMaximum
          ? _value.costMaximum
          : costMaximum // ignore: cast_nullable_to_non_nullable
              as String,
      pricingStrategy: null == pricingStrategy
          ? _value.pricingStrategy
          : pricingStrategy // ignore: cast_nullable_to_non_nullable
              as ActivityPricingExternalStoreInformationPricingStrategy,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityPricingExternalStoreInformationImpl
    implements _ActivityPricingExternalStoreInformation {
  const _$ActivityPricingExternalStoreInformationImpl(
      {this.costExact = '',
      this.costMinimum = '',
      this.costMaximum = '',
      @JsonKey(
          toJson: ActivityPricingExternalStoreInformationPricingStrategy.toJson,
          fromJson:
              ActivityPricingExternalStoreInformationPricingStrategy.fromJson)
      this.pricingStrategy =
          const ActivityPricingExternalStoreInformationPricingStrategy
              .onePerson()});

  factory _$ActivityPricingExternalStoreInformationImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ActivityPricingExternalStoreInformationImplFromJson(json);

  @override
  @JsonKey()
  final String costExact;
  @override
  @JsonKey()
  final String costMinimum;
  @override
  @JsonKey()
  final String costMaximum;
  @override
  @JsonKey(
      toJson: ActivityPricingExternalStoreInformationPricingStrategy.toJson,
      fromJson: ActivityPricingExternalStoreInformationPricingStrategy.fromJson)
  final ActivityPricingExternalStoreInformationPricingStrategy pricingStrategy;

  @override
  String toString() {
    return 'ActivityPricingExternalStoreInformation(costExact: $costExact, costMinimum: $costMinimum, costMaximum: $costMaximum, pricingStrategy: $pricingStrategy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityPricingExternalStoreInformationImpl &&
            (identical(other.costExact, costExact) ||
                other.costExact == costExact) &&
            (identical(other.costMinimum, costMinimum) ||
                other.costMinimum == costMinimum) &&
            (identical(other.costMaximum, costMaximum) ||
                other.costMaximum == costMaximum) &&
            (identical(other.pricingStrategy, pricingStrategy) ||
                other.pricingStrategy == pricingStrategy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, costExact, costMinimum, costMaximum, pricingStrategy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityPricingExternalStoreInformationImplCopyWith<
          _$ActivityPricingExternalStoreInformationImpl>
      get copyWith =>
          __$$ActivityPricingExternalStoreInformationImplCopyWithImpl<
              _$ActivityPricingExternalStoreInformationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityPricingExternalStoreInformationImplToJson(
      this,
    );
  }
}

abstract class _ActivityPricingExternalStoreInformation
    implements ActivityPricingExternalStoreInformation {
  const factory _ActivityPricingExternalStoreInformation(
      {final String costExact,
      final String costMinimum,
      final String costMaximum,
      @JsonKey(
          toJson: ActivityPricingExternalStoreInformationPricingStrategy.toJson,
          fromJson:
              ActivityPricingExternalStoreInformationPricingStrategy.fromJson)
      final ActivityPricingExternalStoreInformationPricingStrategy
          pricingStrategy}) = _$ActivityPricingExternalStoreInformationImpl;

  factory _ActivityPricingExternalStoreInformation.fromJson(
          Map<String, dynamic> json) =
      _$ActivityPricingExternalStoreInformationImpl.fromJson;

  @override
  String get costExact;
  @override
  String get costMinimum;
  @override
  String get costMaximum;
  @override
  @JsonKey(
      toJson: ActivityPricingExternalStoreInformationPricingStrategy.toJson,
      fromJson: ActivityPricingExternalStoreInformationPricingStrategy.fromJson)
  ActivityPricingExternalStoreInformationPricingStrategy get pricingStrategy;
  @override
  @JsonKey(ignore: true)
  _$$ActivityPricingExternalStoreInformationImplCopyWith<
          _$ActivityPricingExternalStoreInformationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ActivityPricingExternalStoreInformationPricingStrategy {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onePerson,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onePerson,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onePerson,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _ActivityPricingExternalStoreInformationPricingStrategyOnePerson
                value)
        onePerson,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            _ActivityPricingExternalStoreInformationPricingStrategyOnePerson
                value)?
        onePerson,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            _ActivityPricingExternalStoreInformationPricingStrategyOnePerson
                value)?
        onePerson,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityPricingExternalStoreInformationPricingStrategyCopyWith<
    $Res> {
  factory $ActivityPricingExternalStoreInformationPricingStrategyCopyWith(
          ActivityPricingExternalStoreInformationPricingStrategy value,
          $Res Function(ActivityPricingExternalStoreInformationPricingStrategy)
              then) =
      _$ActivityPricingExternalStoreInformationPricingStrategyCopyWithImpl<$Res,
          ActivityPricingExternalStoreInformationPricingStrategy>;
}

/// @nodoc
class _$ActivityPricingExternalStoreInformationPricingStrategyCopyWithImpl<$Res,
        $Val extends ActivityPricingExternalStoreInformationPricingStrategy>
    implements
        $ActivityPricingExternalStoreInformationPricingStrategyCopyWith<$Res> {
  _$ActivityPricingExternalStoreInformationPricingStrategyCopyWithImpl(
      this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImplCopyWith<
    $Res> {
  factory _$$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImplCopyWith(
          _$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImpl
              value,
          $Res Function(
                  _$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImpl)
              then) =
      __$$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImplCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImplCopyWithImpl<
        $Res>
    extends _$ActivityPricingExternalStoreInformationPricingStrategyCopyWithImpl<
        $Res,
        _$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImpl>
    implements
        _$$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImplCopyWith<
            $Res> {
  __$$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImplCopyWithImpl(
      _$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImpl
          _value,
      $Res Function(
              _$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImpl)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImpl
    implements
        _ActivityPricingExternalStoreInformationPricingStrategyOnePerson {
  const _$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImpl();

  @override
  String toString() {
    return 'ActivityPricingExternalStoreInformationPricingStrategy.onePerson()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() onePerson,
  }) {
    return onePerson();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? onePerson,
  }) {
    return onePerson?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? onePerson,
    required TResult orElse(),
  }) {
    if (onePerson != null) {
      return onePerson();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _ActivityPricingExternalStoreInformationPricingStrategyOnePerson
                value)
        onePerson,
  }) {
    return onePerson(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            _ActivityPricingExternalStoreInformationPricingStrategyOnePerson
                value)?
        onePerson,
  }) {
    return onePerson?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            _ActivityPricingExternalStoreInformationPricingStrategyOnePerson
                value)?
        onePerson,
    required TResult orElse(),
  }) {
    if (onePerson != null) {
      return onePerson(this);
    }
    return orElse();
  }
}

abstract class _ActivityPricingExternalStoreInformationPricingStrategyOnePerson
    implements ActivityPricingExternalStoreInformationPricingStrategy {
  const factory _ActivityPricingExternalStoreInformationPricingStrategyOnePerson() =
      _$ActivityPricingExternalStoreInformationPricingStrategyOnePersonImpl;
}

ActivityPublisherInformation _$ActivityPublisherInformationFromJson(
    Map<String, dynamic> json) {
  return _ActivityPublisherInformation.fromJson(json);
}

/// @nodoc
mixin _$ActivityPublisherInformation {
  String get originFeed => throw _privateConstructorUsedError;
  String get publisherId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityPublisherInformationCopyWith<ActivityPublisherInformation>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityPublisherInformationCopyWith<$Res> {
  factory $ActivityPublisherInformationCopyWith(
          ActivityPublisherInformation value,
          $Res Function(ActivityPublisherInformation) then) =
      _$ActivityPublisherInformationCopyWithImpl<$Res,
          ActivityPublisherInformation>;
  @useResult
  $Res call({String originFeed, String publisherId});
}

/// @nodoc
class _$ActivityPublisherInformationCopyWithImpl<$Res,
        $Val extends ActivityPublisherInformation>
    implements $ActivityPublisherInformationCopyWith<$Res> {
  _$ActivityPublisherInformationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originFeed = null,
    Object? publisherId = null,
  }) {
    return _then(_value.copyWith(
      originFeed: null == originFeed
          ? _value.originFeed
          : originFeed // ignore: cast_nullable_to_non_nullable
              as String,
      publisherId: null == publisherId
          ? _value.publisherId
          : publisherId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityPublisherInformationImplCopyWith<$Res>
    implements $ActivityPublisherInformationCopyWith<$Res> {
  factory _$$ActivityPublisherInformationImplCopyWith(
          _$ActivityPublisherInformationImpl value,
          $Res Function(_$ActivityPublisherInformationImpl) then) =
      __$$ActivityPublisherInformationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String originFeed, String publisherId});
}

/// @nodoc
class __$$ActivityPublisherInformationImplCopyWithImpl<$Res>
    extends _$ActivityPublisherInformationCopyWithImpl<$Res,
        _$ActivityPublisherInformationImpl>
    implements _$$ActivityPublisherInformationImplCopyWith<$Res> {
  __$$ActivityPublisherInformationImplCopyWithImpl(
      _$ActivityPublisherInformationImpl _value,
      $Res Function(_$ActivityPublisherInformationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originFeed = null,
    Object? publisherId = null,
  }) {
    return _then(_$ActivityPublisherInformationImpl(
      originFeed: null == originFeed
          ? _value.originFeed
          : originFeed // ignore: cast_nullable_to_non_nullable
              as String,
      publisherId: null == publisherId
          ? _value.publisherId
          : publisherId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityPublisherInformationImpl
    implements _ActivityPublisherInformation {
  const _$ActivityPublisherInformationImpl(
      {this.originFeed = '', this.publisherId = ''});

  factory _$ActivityPublisherInformationImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ActivityPublisherInformationImplFromJson(json);

  @override
  @JsonKey()
  final String originFeed;
  @override
  @JsonKey()
  final String publisherId;

  @override
  String toString() {
    return 'ActivityPublisherInformation(originFeed: $originFeed, publisherId: $publisherId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityPublisherInformationImpl &&
            (identical(other.originFeed, originFeed) ||
                other.originFeed == originFeed) &&
            (identical(other.publisherId, publisherId) ||
                other.publisherId == publisherId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, originFeed, publisherId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityPublisherInformationImplCopyWith<
          _$ActivityPublisherInformationImpl>
      get copyWith => __$$ActivityPublisherInformationImplCopyWithImpl<
          _$ActivityPublisherInformationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityPublisherInformationImplToJson(
      this,
    );
  }
}

abstract class _ActivityPublisherInformation
    implements ActivityPublisherInformation {
  const factory _ActivityPublisherInformation(
      {final String originFeed,
      final String publisherId}) = _$ActivityPublisherInformationImpl;

  factory _ActivityPublisherInformation.fromJson(Map<String, dynamic> json) =
      _$ActivityPublisherInformationImpl.fromJson;

  @override
  String get originFeed;
  @override
  String get publisherId;
  @override
  @JsonKey(ignore: true)
  _$$ActivityPublisherInformationImplCopyWith<
          _$ActivityPublisherInformationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ActivityEnrichmentConfiguration _$ActivityEnrichmentConfigurationFromJson(
    Map<String, dynamic> json) {
  return _ActivityEnrichmentConfiguration.fromJson(json);
}

/// @nodoc
mixin _$ActivityEnrichmentConfiguration {
  @JsonKey(fromJson: stringListFromJson)
  List<String> get tags => throw _privateConstructorUsedError;
  @JsonKey(fromJson: stringListFromJson)
  List<String> get taggedUsers => throw _privateConstructorUsedError;
  String get promotionKey => throw _privateConstructorUsedError;
  String get publishLocation => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
  List<Mention> get mentions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityEnrichmentConfigurationCopyWith<ActivityEnrichmentConfiguration>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityEnrichmentConfigurationCopyWith<$Res> {
  factory $ActivityEnrichmentConfigurationCopyWith(
          ActivityEnrichmentConfiguration value,
          $Res Function(ActivityEnrichmentConfiguration) then) =
      _$ActivityEnrichmentConfigurationCopyWithImpl<$Res,
          ActivityEnrichmentConfiguration>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: stringListFromJson) List<String> tags,
      @JsonKey(fromJson: stringListFromJson) List<String> taggedUsers,
      String promotionKey,
      String publishLocation,
      @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
      List<Mention> mentions});
}

/// @nodoc
class _$ActivityEnrichmentConfigurationCopyWithImpl<$Res,
        $Val extends ActivityEnrichmentConfiguration>
    implements $ActivityEnrichmentConfigurationCopyWith<$Res> {
  _$ActivityEnrichmentConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tags = null,
    Object? taggedUsers = null,
    Object? promotionKey = null,
    Object? publishLocation = null,
    Object? mentions = null,
  }) {
    return _then(_value.copyWith(
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      taggedUsers: null == taggedUsers
          ? _value.taggedUsers
          : taggedUsers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      promotionKey: null == promotionKey
          ? _value.promotionKey
          : promotionKey // ignore: cast_nullable_to_non_nullable
              as String,
      publishLocation: null == publishLocation
          ? _value.publishLocation
          : publishLocation // ignore: cast_nullable_to_non_nullable
              as String,
      mentions: null == mentions
          ? _value.mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<Mention>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityEnrichmentConfigurationImplCopyWith<$Res>
    implements $ActivityEnrichmentConfigurationCopyWith<$Res> {
  factory _$$ActivityEnrichmentConfigurationImplCopyWith(
          _$ActivityEnrichmentConfigurationImpl value,
          $Res Function(_$ActivityEnrichmentConfigurationImpl) then) =
      __$$ActivityEnrichmentConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: stringListFromJson) List<String> tags,
      @JsonKey(fromJson: stringListFromJson) List<String> taggedUsers,
      String promotionKey,
      String publishLocation,
      @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
      List<Mention> mentions});
}

/// @nodoc
class __$$ActivityEnrichmentConfigurationImplCopyWithImpl<$Res>
    extends _$ActivityEnrichmentConfigurationCopyWithImpl<$Res,
        _$ActivityEnrichmentConfigurationImpl>
    implements _$$ActivityEnrichmentConfigurationImplCopyWith<$Res> {
  __$$ActivityEnrichmentConfigurationImplCopyWithImpl(
      _$ActivityEnrichmentConfigurationImpl _value,
      $Res Function(_$ActivityEnrichmentConfigurationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tags = null,
    Object? taggedUsers = null,
    Object? promotionKey = null,
    Object? publishLocation = null,
    Object? mentions = null,
  }) {
    return _then(_$ActivityEnrichmentConfigurationImpl(
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      taggedUsers: null == taggedUsers
          ? _value._taggedUsers
          : taggedUsers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      promotionKey: null == promotionKey
          ? _value.promotionKey
          : promotionKey // ignore: cast_nullable_to_non_nullable
              as String,
      publishLocation: null == publishLocation
          ? _value.publishLocation
          : publishLocation // ignore: cast_nullable_to_non_nullable
              as String,
      mentions: null == mentions
          ? _value._mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<Mention>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityEnrichmentConfigurationImpl
    implements _ActivityEnrichmentConfiguration {
  const _$ActivityEnrichmentConfigurationImpl(
      {@JsonKey(fromJson: stringListFromJson)
      final List<String> tags = const [],
      @JsonKey(fromJson: stringListFromJson)
      final List<String> taggedUsers = const [],
      this.promotionKey = '',
      this.publishLocation = '',
      @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
      final List<Mention> mentions = const []})
      : _tags = tags,
        _taggedUsers = taggedUsers,
        _mentions = mentions;

  factory _$ActivityEnrichmentConfigurationImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ActivityEnrichmentConfigurationImplFromJson(json);

  final List<String> _tags;
  @override
  @JsonKey(fromJson: stringListFromJson)
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _taggedUsers;
  @override
  @JsonKey(fromJson: stringListFromJson)
  List<String> get taggedUsers {
    if (_taggedUsers is EqualUnmodifiableListView) return _taggedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taggedUsers);
  }

  @override
  @JsonKey()
  final String promotionKey;
  @override
  @JsonKey()
  final String publishLocation;
  final List<Mention> _mentions;
  @override
  @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
  List<Mention> get mentions {
    if (_mentions is EqualUnmodifiableListView) return _mentions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mentions);
  }

  @override
  String toString() {
    return 'ActivityEnrichmentConfiguration(tags: $tags, taggedUsers: $taggedUsers, promotionKey: $promotionKey, publishLocation: $publishLocation, mentions: $mentions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEnrichmentConfigurationImpl &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._taggedUsers, _taggedUsers) &&
            (identical(other.promotionKey, promotionKey) ||
                other.promotionKey == promotionKey) &&
            (identical(other.publishLocation, publishLocation) ||
                other.publishLocation == publishLocation) &&
            const DeepCollectionEquality().equals(other._mentions, _mentions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_taggedUsers),
      promotionKey,
      publishLocation,
      const DeepCollectionEquality().hash(_mentions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityEnrichmentConfigurationImplCopyWith<
          _$ActivityEnrichmentConfigurationImpl>
      get copyWith => __$$ActivityEnrichmentConfigurationImplCopyWithImpl<
          _$ActivityEnrichmentConfigurationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityEnrichmentConfigurationImplToJson(
      this,
    );
  }
}

abstract class _ActivityEnrichmentConfiguration
    implements ActivityEnrichmentConfiguration {
  const factory _ActivityEnrichmentConfiguration(
      {@JsonKey(fromJson: stringListFromJson) final List<String> tags,
      @JsonKey(fromJson: stringListFromJson) final List<String> taggedUsers,
      final String promotionKey,
      final String publishLocation,
      @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
      final List<Mention> mentions}) = _$ActivityEnrichmentConfigurationImpl;

  factory _ActivityEnrichmentConfiguration.fromJson(Map<String, dynamic> json) =
      _$ActivityEnrichmentConfigurationImpl.fromJson;

  @override
  @JsonKey(fromJson: stringListFromJson)
  List<String> get tags;
  @override
  @JsonKey(fromJson: stringListFromJson)
  List<String> get taggedUsers;
  @override
  String get promotionKey;
  @override
  String get publishLocation;
  @override
  @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
  List<Mention> get mentions;
  @override
  @JsonKey(ignore: true)
  _$$ActivityEnrichmentConfigurationImplCopyWith<
          _$ActivityEnrichmentConfigurationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
