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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return _Activity.fromJson(json);
}

/// @nodoc
mixin _$Activity {
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  String get foreignKey => throw _privateConstructorUsedError;
  ActivityGeneralConfiguration? get generalConfiguration =>
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
      String foreignKey,
      ActivityGeneralConfiguration? generalConfiguration,
      ActivitySecurityConfiguration? securityConfiguration,
      ActivityEventConfiguration? eventConfiguration,
      ActivityPricingInformation? pricingInformation,
      ActivityPublisherInformation? publisherInformation,
      ActivityEnrichmentConfiguration? enrichmentConfiguration,
      @JsonKey(fromJson: Media.fromJsonList) List<Media> media});

  $FlMetaCopyWith<$Res>? get flMeta;
  $ActivityGeneralConfigurationCopyWith<$Res>? get generalConfiguration;
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
    Object? foreignKey = null,
    Object? generalConfiguration = freezed,
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
      foreignKey: null == foreignKey
          ? _value.foreignKey
          : foreignKey // ignore: cast_nullable_to_non_nullable
              as String,
      generalConfiguration: freezed == generalConfiguration
          ? _value.generalConfiguration
          : generalConfiguration // ignore: cast_nullable_to_non_nullable
              as ActivityGeneralConfiguration?,
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
abstract class _$$_ActivityCopyWith<$Res> implements $ActivityCopyWith<$Res> {
  factory _$$_ActivityCopyWith(
          _$_Activity value, $Res Function(_$_Activity) then) =
      __$$_ActivityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String foreignKey,
      ActivityGeneralConfiguration? generalConfiguration,
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
class __$$_ActivityCopyWithImpl<$Res>
    extends _$ActivityCopyWithImpl<$Res, _$_Activity>
    implements _$$_ActivityCopyWith<$Res> {
  __$$_ActivityCopyWithImpl(
      _$_Activity _value, $Res Function(_$_Activity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? foreignKey = null,
    Object? generalConfiguration = freezed,
    Object? securityConfiguration = freezed,
    Object? eventConfiguration = freezed,
    Object? pricingInformation = freezed,
    Object? publisherInformation = freezed,
    Object? enrichmentConfiguration = freezed,
    Object? media = null,
  }) {
    return _then(_$_Activity(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      foreignKey: null == foreignKey
          ? _value.foreignKey
          : foreignKey // ignore: cast_nullable_to_non_nullable
              as String,
      generalConfiguration: freezed == generalConfiguration
          ? _value.generalConfiguration
          : generalConfiguration // ignore: cast_nullable_to_non_nullable
              as ActivityGeneralConfiguration?,
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
class _$_Activity implements _Activity {
  const _$_Activity(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      this.foreignKey = '',
      this.generalConfiguration,
      this.securityConfiguration,
      this.eventConfiguration,
      this.pricingInformation,
      this.publisherInformation,
      this.enrichmentConfiguration,
      @JsonKey(fromJson: Media.fromJsonList)
      final List<Media> media = const []})
      : _media = media;

  factory _$_Activity.fromJson(Map<String, dynamic> json) =>
      _$$_ActivityFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey()
  final String foreignKey;
  @override
  final ActivityGeneralConfiguration? generalConfiguration;
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
    return 'Activity(flMeta: $flMeta, foreignKey: $foreignKey, generalConfiguration: $generalConfiguration, securityConfiguration: $securityConfiguration, eventConfiguration: $eventConfiguration, pricingInformation: $pricingInformation, publisherInformation: $publisherInformation, enrichmentConfiguration: $enrichmentConfiguration, media: $media)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Activity &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.foreignKey, foreignKey) ||
                other.foreignKey == foreignKey) &&
            (identical(other.generalConfiguration, generalConfiguration) ||
                other.generalConfiguration == generalConfiguration) &&
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
      foreignKey,
      generalConfiguration,
      securityConfiguration,
      eventConfiguration,
      pricingInformation,
      publisherInformation,
      enrichmentConfiguration,
      const DeepCollectionEquality().hash(_media));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActivityCopyWith<_$_Activity> get copyWith =>
      __$$_ActivityCopyWithImpl<_$_Activity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivityToJson(
      this,
    );
  }
}

abstract class _Activity implements Activity {
  const factory _Activity(
          {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
          final String foreignKey,
          final ActivityGeneralConfiguration? generalConfiguration,
          final ActivitySecurityConfiguration? securityConfiguration,
          final ActivityEventConfiguration? eventConfiguration,
          final ActivityPricingInformation? pricingInformation,
          final ActivityPublisherInformation? publisherInformation,
          final ActivityEnrichmentConfiguration? enrichmentConfiguration,
          @JsonKey(fromJson: Media.fromJsonList) final List<Media> media}) =
      _$_Activity;

  factory _Activity.fromJson(Map<String, dynamic> json) = _$_Activity.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  String get foreignKey;
  @override
  ActivityGeneralConfiguration? get generalConfiguration;
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
  _$$_ActivityCopyWith<_$_Activity> get copyWith =>
      throw _privateConstructorUsedError;
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
      String content});

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
abstract class _$$_ActivityGeneralConfigurationCopyWith<$Res>
    implements $ActivityGeneralConfigurationCopyWith<$Res> {
  factory _$$_ActivityGeneralConfigurationCopyWith(
          _$_ActivityGeneralConfiguration value,
          $Res Function(_$_ActivityGeneralConfiguration) then) =
      __$$_ActivityGeneralConfigurationCopyWithImpl<$Res>;
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
      String content});

  @override
  $ActivityGeneralConfigurationTypeCopyWith<$Res> get type;
  @override
  $ActivityGeneralConfigurationStyleCopyWith<$Res> get style;
}

/// @nodoc
class __$$_ActivityGeneralConfigurationCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationCopyWithImpl<$Res,
        _$_ActivityGeneralConfiguration>
    implements _$$_ActivityGeneralConfigurationCopyWith<$Res> {
  __$$_ActivityGeneralConfigurationCopyWithImpl(
      _$_ActivityGeneralConfiguration _value,
      $Res Function(_$_ActivityGeneralConfiguration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? style = null,
    Object? content = null,
  }) {
    return _then(_$_ActivityGeneralConfiguration(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ActivityGeneralConfiguration implements _ActivityGeneralConfiguration {
  const _$_ActivityGeneralConfiguration(
      {@JsonKey(
          fromJson: ActivityGeneralConfigurationType.fromJson,
          toJson: ActivityGeneralConfigurationType.toJson)
      this.type = const ActivityGeneralConfigurationType.post(),
      @JsonKey(
          fromJson: ActivityGeneralConfigurationStyle.fromJson,
          toJson: ActivityGeneralConfigurationStyle.toJson)
      this.style = const ActivityGeneralConfigurationStyle.text(),
      this.content = ''});

  factory _$_ActivityGeneralConfiguration.fromJson(Map<String, dynamic> json) =>
      _$$_ActivityGeneralConfigurationFromJson(json);

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
  String toString() {
    return 'ActivityGeneralConfiguration(type: $type, style: $style, content: $content)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityGeneralConfiguration &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, style, content);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActivityGeneralConfigurationCopyWith<_$_ActivityGeneralConfiguration>
      get copyWith => __$$_ActivityGeneralConfigurationCopyWithImpl<
          _$_ActivityGeneralConfiguration>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivityGeneralConfigurationToJson(
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
      final String content}) = _$_ActivityGeneralConfiguration;

  factory _ActivityGeneralConfiguration.fromJson(Map<String, dynamic> json) =
      _$_ActivityGeneralConfiguration.fromJson;

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
  @JsonKey(ignore: true)
  _$$_ActivityGeneralConfigurationCopyWith<_$_ActivityGeneralConfiguration>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ActivityGeneralConfigurationType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
    required TResult Function() repost,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
    TResult? Function()? repost,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    TResult Function()? repost,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityGeneralConfigurationTypePost value) post,
    required TResult Function(_ActivityGeneralConfigurationTypeEvent value)
        event,
    required TResult Function(_ActivityGeneralConfigurationTypeClip value) clip,
    required TResult Function(_ActivityGeneralConfigurationTypeRepost value)
        repost,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult? Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult? Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    TResult? Function(_ActivityGeneralConfigurationTypeRepost value)? repost,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    TResult Function(_ActivityGeneralConfigurationTypeRepost value)? repost,
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
abstract class _$$_ActivityGeneralConfigurationTypePostCopyWith<$Res> {
  factory _$$_ActivityGeneralConfigurationTypePostCopyWith(
          _$_ActivityGeneralConfigurationTypePost value,
          $Res Function(_$_ActivityGeneralConfigurationTypePost) then) =
      __$$_ActivityGeneralConfigurationTypePostCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ActivityGeneralConfigurationTypePostCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationTypeCopyWithImpl<$Res,
        _$_ActivityGeneralConfigurationTypePost>
    implements _$$_ActivityGeneralConfigurationTypePostCopyWith<$Res> {
  __$$_ActivityGeneralConfigurationTypePostCopyWithImpl(
      _$_ActivityGeneralConfigurationTypePost _value,
      $Res Function(_$_ActivityGeneralConfigurationTypePost) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ActivityGeneralConfigurationTypePost
    implements _ActivityGeneralConfigurationTypePost {
  const _$_ActivityGeneralConfigurationTypePost();

  @override
  String toString() {
    return 'ActivityGeneralConfigurationType.post()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityGeneralConfigurationTypePost);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
    required TResult Function() repost,
  }) {
    return post();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
    TResult? Function()? repost,
  }) {
    return post?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    TResult Function()? repost,
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
    required TResult Function(_ActivityGeneralConfigurationTypeRepost value)
        repost,
  }) {
    return post(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult? Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult? Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    TResult? Function(_ActivityGeneralConfigurationTypeRepost value)? repost,
  }) {
    return post?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    TResult Function(_ActivityGeneralConfigurationTypeRepost value)? repost,
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
      _$_ActivityGeneralConfigurationTypePost;
}

/// @nodoc
abstract class _$$_ActivityGeneralConfigurationTypeEventCopyWith<$Res> {
  factory _$$_ActivityGeneralConfigurationTypeEventCopyWith(
          _$_ActivityGeneralConfigurationTypeEvent value,
          $Res Function(_$_ActivityGeneralConfigurationTypeEvent) then) =
      __$$_ActivityGeneralConfigurationTypeEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ActivityGeneralConfigurationTypeEventCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationTypeCopyWithImpl<$Res,
        _$_ActivityGeneralConfigurationTypeEvent>
    implements _$$_ActivityGeneralConfigurationTypeEventCopyWith<$Res> {
  __$$_ActivityGeneralConfigurationTypeEventCopyWithImpl(
      _$_ActivityGeneralConfigurationTypeEvent _value,
      $Res Function(_$_ActivityGeneralConfigurationTypeEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ActivityGeneralConfigurationTypeEvent
    implements _ActivityGeneralConfigurationTypeEvent {
  const _$_ActivityGeneralConfigurationTypeEvent();

  @override
  String toString() {
    return 'ActivityGeneralConfigurationType.event()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityGeneralConfigurationTypeEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
    required TResult Function() repost,
  }) {
    return event();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
    TResult? Function()? repost,
  }) {
    return event?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    TResult Function()? repost,
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
    required TResult Function(_ActivityGeneralConfigurationTypeRepost value)
        repost,
  }) {
    return event(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult? Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult? Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    TResult? Function(_ActivityGeneralConfigurationTypeRepost value)? repost,
  }) {
    return event?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    TResult Function(_ActivityGeneralConfigurationTypeRepost value)? repost,
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
      _$_ActivityGeneralConfigurationTypeEvent;
}

/// @nodoc
abstract class _$$_ActivityGeneralConfigurationTypeClipCopyWith<$Res> {
  factory _$$_ActivityGeneralConfigurationTypeClipCopyWith(
          _$_ActivityGeneralConfigurationTypeClip value,
          $Res Function(_$_ActivityGeneralConfigurationTypeClip) then) =
      __$$_ActivityGeneralConfigurationTypeClipCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ActivityGeneralConfigurationTypeClipCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationTypeCopyWithImpl<$Res,
        _$_ActivityGeneralConfigurationTypeClip>
    implements _$$_ActivityGeneralConfigurationTypeClipCopyWith<$Res> {
  __$$_ActivityGeneralConfigurationTypeClipCopyWithImpl(
      _$_ActivityGeneralConfigurationTypeClip _value,
      $Res Function(_$_ActivityGeneralConfigurationTypeClip) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ActivityGeneralConfigurationTypeClip
    implements _ActivityGeneralConfigurationTypeClip {
  const _$_ActivityGeneralConfigurationTypeClip();

  @override
  String toString() {
    return 'ActivityGeneralConfigurationType.clip()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityGeneralConfigurationTypeClip);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
    required TResult Function() repost,
  }) {
    return clip();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
    TResult? Function()? repost,
  }) {
    return clip?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    TResult Function()? repost,
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
    required TResult Function(_ActivityGeneralConfigurationTypeRepost value)
        repost,
  }) {
    return clip(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult? Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult? Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    TResult? Function(_ActivityGeneralConfigurationTypeRepost value)? repost,
  }) {
    return clip?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    TResult Function(_ActivityGeneralConfigurationTypeRepost value)? repost,
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
      _$_ActivityGeneralConfigurationTypeClip;
}

/// @nodoc
abstract class _$$_ActivityGeneralConfigurationTypeRepostCopyWith<$Res> {
  factory _$$_ActivityGeneralConfigurationTypeRepostCopyWith(
          _$_ActivityGeneralConfigurationTypeRepost value,
          $Res Function(_$_ActivityGeneralConfigurationTypeRepost) then) =
      __$$_ActivityGeneralConfigurationTypeRepostCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ActivityGeneralConfigurationTypeRepostCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationTypeCopyWithImpl<$Res,
        _$_ActivityGeneralConfigurationTypeRepost>
    implements _$$_ActivityGeneralConfigurationTypeRepostCopyWith<$Res> {
  __$$_ActivityGeneralConfigurationTypeRepostCopyWithImpl(
      _$_ActivityGeneralConfigurationTypeRepost _value,
      $Res Function(_$_ActivityGeneralConfigurationTypeRepost) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ActivityGeneralConfigurationTypeRepost
    implements _ActivityGeneralConfigurationTypeRepost {
  const _$_ActivityGeneralConfigurationTypeRepost();

  @override
  String toString() {
    return 'ActivityGeneralConfigurationType.repost()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityGeneralConfigurationTypeRepost);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
    required TResult Function() repost,
  }) {
    return repost();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
    TResult? Function()? repost,
  }) {
    return repost?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    TResult Function()? repost,
    required TResult orElse(),
  }) {
    if (repost != null) {
      return repost();
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
    required TResult Function(_ActivityGeneralConfigurationTypeRepost value)
        repost,
  }) {
    return repost(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult? Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult? Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    TResult? Function(_ActivityGeneralConfigurationTypeRepost value)? repost,
  }) {
    return repost?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityGeneralConfigurationTypePost value)? post,
    TResult Function(_ActivityGeneralConfigurationTypeEvent value)? event,
    TResult Function(_ActivityGeneralConfigurationTypeClip value)? clip,
    TResult Function(_ActivityGeneralConfigurationTypeRepost value)? repost,
    required TResult orElse(),
  }) {
    if (repost != null) {
      return repost(this);
    }
    return orElse();
  }
}

abstract class _ActivityGeneralConfigurationTypeRepost
    implements ActivityGeneralConfigurationType {
  const factory _ActivityGeneralConfigurationTypeRepost() =
      _$_ActivityGeneralConfigurationTypeRepost;
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
abstract class _$$_ActivityGeneralConfigurationStyleMarkdownCopyWith<$Res> {
  factory _$$_ActivityGeneralConfigurationStyleMarkdownCopyWith(
          _$_ActivityGeneralConfigurationStyleMarkdown value,
          $Res Function(_$_ActivityGeneralConfigurationStyleMarkdown) then) =
      __$$_ActivityGeneralConfigurationStyleMarkdownCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ActivityGeneralConfigurationStyleMarkdownCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationStyleCopyWithImpl<$Res,
        _$_ActivityGeneralConfigurationStyleMarkdown>
    implements _$$_ActivityGeneralConfigurationStyleMarkdownCopyWith<$Res> {
  __$$_ActivityGeneralConfigurationStyleMarkdownCopyWithImpl(
      _$_ActivityGeneralConfigurationStyleMarkdown _value,
      $Res Function(_$_ActivityGeneralConfigurationStyleMarkdown) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ActivityGeneralConfigurationStyleMarkdown
    implements _ActivityGeneralConfigurationStyleMarkdown {
  const _$_ActivityGeneralConfigurationStyleMarkdown();

  @override
  String toString() {
    return 'ActivityGeneralConfigurationStyle.markdown()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityGeneralConfigurationStyleMarkdown);
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
      _$_ActivityGeneralConfigurationStyleMarkdown;
}

/// @nodoc
abstract class _$$_ActivityGeneralConfigurationStyleTextCopyWith<$Res> {
  factory _$$_ActivityGeneralConfigurationStyleTextCopyWith(
          _$_ActivityGeneralConfigurationStyleText value,
          $Res Function(_$_ActivityGeneralConfigurationStyleText) then) =
      __$$_ActivityGeneralConfigurationStyleTextCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ActivityGeneralConfigurationStyleTextCopyWithImpl<$Res>
    extends _$ActivityGeneralConfigurationStyleCopyWithImpl<$Res,
        _$_ActivityGeneralConfigurationStyleText>
    implements _$$_ActivityGeneralConfigurationStyleTextCopyWith<$Res> {
  __$$_ActivityGeneralConfigurationStyleTextCopyWithImpl(
      _$_ActivityGeneralConfigurationStyleText _value,
      $Res Function(_$_ActivityGeneralConfigurationStyleText) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ActivityGeneralConfigurationStyleText
    implements _ActivityGeneralConfigurationStyleText {
  const _$_ActivityGeneralConfigurationStyleText();

  @override
  String toString() {
    return 'ActivityGeneralConfigurationStyle.text()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityGeneralConfigurationStyleText);
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
      _$_ActivityGeneralConfigurationStyleText;
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
  ActivitySecurityConfigurationMode get reactionMode =>
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
      ActivitySecurityConfigurationMode reactionMode,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      ActivitySecurityConfigurationMode shareMode});

  $ActivitySecurityConfigurationModeCopyWith<$Res> get viewMode;
  $ActivitySecurityConfigurationModeCopyWith<$Res> get reactionMode;
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
    Object? reactionMode = null,
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
      reactionMode: null == reactionMode
          ? _value.reactionMode
          : reactionMode // ignore: cast_nullable_to_non_nullable
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
  $ActivitySecurityConfigurationModeCopyWith<$Res> get reactionMode {
    return $ActivitySecurityConfigurationModeCopyWith<$Res>(_value.reactionMode,
        (value) {
      return _then(_value.copyWith(reactionMode: value) as $Val);
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
abstract class _$$_ActivitySecurityConfigurationCopyWith<$Res>
    implements $ActivitySecurityConfigurationCopyWith<$Res> {
  factory _$$_ActivitySecurityConfigurationCopyWith(
          _$_ActivitySecurityConfiguration value,
          $Res Function(_$_ActivitySecurityConfiguration) then) =
      __$$_ActivitySecurityConfigurationCopyWithImpl<$Res>;
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
      ActivitySecurityConfigurationMode reactionMode,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      ActivitySecurityConfigurationMode shareMode});

  @override
  $ActivitySecurityConfigurationModeCopyWith<$Res> get viewMode;
  @override
  $ActivitySecurityConfigurationModeCopyWith<$Res> get reactionMode;
  @override
  $ActivitySecurityConfigurationModeCopyWith<$Res> get shareMode;
}

/// @nodoc
class __$$_ActivitySecurityConfigurationCopyWithImpl<$Res>
    extends _$ActivitySecurityConfigurationCopyWithImpl<$Res,
        _$_ActivitySecurityConfiguration>
    implements _$$_ActivitySecurityConfigurationCopyWith<$Res> {
  __$$_ActivitySecurityConfigurationCopyWithImpl(
      _$_ActivitySecurityConfiguration _value,
      $Res Function(_$_ActivitySecurityConfiguration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
    Object? viewMode = null,
    Object? reactionMode = null,
    Object? shareMode = null,
  }) {
    return _then(_$_ActivitySecurityConfiguration(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String,
      viewMode: null == viewMode
          ? _value.viewMode
          : viewMode // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfigurationMode,
      reactionMode: null == reactionMode
          ? _value.reactionMode
          : reactionMode // ignore: cast_nullable_to_non_nullable
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
class _$_ActivitySecurityConfiguration
    implements _ActivitySecurityConfiguration {
  const _$_ActivitySecurityConfiguration(
      {this.context = '',
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      this.viewMode = const ActivitySecurityConfigurationMode.private(),
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      this.reactionMode = const ActivitySecurityConfigurationMode.private(),
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      this.shareMode = const ActivitySecurityConfigurationMode.private()});

  factory _$_ActivitySecurityConfiguration.fromJson(
          Map<String, dynamic> json) =>
      _$$_ActivitySecurityConfigurationFromJson(json);

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
  final ActivitySecurityConfigurationMode reactionMode;
  @override
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  final ActivitySecurityConfigurationMode shareMode;

  @override
  String toString() {
    return 'ActivitySecurityConfiguration(context: $context, viewMode: $viewMode, reactionMode: $reactionMode, shareMode: $shareMode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivitySecurityConfiguration &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.viewMode, viewMode) ||
                other.viewMode == viewMode) &&
            (identical(other.reactionMode, reactionMode) ||
                other.reactionMode == reactionMode) &&
            (identical(other.shareMode, shareMode) ||
                other.shareMode == shareMode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, context, viewMode, reactionMode, shareMode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActivitySecurityConfigurationCopyWith<_$_ActivitySecurityConfiguration>
      get copyWith => __$$_ActivitySecurityConfigurationCopyWithImpl<
          _$_ActivitySecurityConfiguration>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivitySecurityConfigurationToJson(
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
          final ActivitySecurityConfigurationMode reactionMode,
          @JsonKey(
              fromJson: ActivitySecurityConfigurationMode.fromJson,
              toJson: ActivitySecurityConfigurationMode.toJson)
          final ActivitySecurityConfigurationMode shareMode}) =
      _$_ActivitySecurityConfiguration;

  factory _ActivitySecurityConfiguration.fromJson(Map<String, dynamic> json) =
      _$_ActivitySecurityConfiguration.fromJson;

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
  ActivitySecurityConfigurationMode get reactionMode;
  @override
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  ActivitySecurityConfigurationMode get shareMode;
  @override
  @JsonKey(ignore: true)
  _$$_ActivitySecurityConfigurationCopyWith<_$_ActivitySecurityConfiguration>
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
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? public,
    TResult? Function()? followersAndConnections,
    TResult? Function()? connections,
    TResult? Function()? private,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? public,
    TResult Function()? followersAndConnections,
    TResult Function()? connections,
    TResult Function()? private,
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
abstract class _$$_ActivitySecurityConfigurationModePublicCopyWith<$Res> {
  factory _$$_ActivitySecurityConfigurationModePublicCopyWith(
          _$_ActivitySecurityConfigurationModePublic value,
          $Res Function(_$_ActivitySecurityConfigurationModePublic) then) =
      __$$_ActivitySecurityConfigurationModePublicCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ActivitySecurityConfigurationModePublicCopyWithImpl<$Res>
    extends _$ActivitySecurityConfigurationModeCopyWithImpl<$Res,
        _$_ActivitySecurityConfigurationModePublic>
    implements _$$_ActivitySecurityConfigurationModePublicCopyWith<$Res> {
  __$$_ActivitySecurityConfigurationModePublicCopyWithImpl(
      _$_ActivitySecurityConfigurationModePublic _value,
      $Res Function(_$_ActivitySecurityConfigurationModePublic) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ActivitySecurityConfigurationModePublic
    implements _ActivitySecurityConfigurationModePublic {
  const _$_ActivitySecurityConfigurationModePublic();

  @override
  String toString() {
    return 'ActivitySecurityConfigurationMode.public()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivitySecurityConfigurationModePublic);
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
      _$_ActivitySecurityConfigurationModePublic;
}

/// @nodoc
abstract class _$$_ActivitySecurityConfigurationModeFollowersAndConnectionsCopyWith<
    $Res> {
  factory _$$_ActivitySecurityConfigurationModeFollowersAndConnectionsCopyWith(
          _$_ActivitySecurityConfigurationModeFollowersAndConnections value,
          $Res Function(
                  _$_ActivitySecurityConfigurationModeFollowersAndConnections)
              then) =
      __$$_ActivitySecurityConfigurationModeFollowersAndConnectionsCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$_ActivitySecurityConfigurationModeFollowersAndConnectionsCopyWithImpl<
        $Res>
    extends _$ActivitySecurityConfigurationModeCopyWithImpl<$Res,
        _$_ActivitySecurityConfigurationModeFollowersAndConnections>
    implements
        _$$_ActivitySecurityConfigurationModeFollowersAndConnectionsCopyWith<
            $Res> {
  __$$_ActivitySecurityConfigurationModeFollowersAndConnectionsCopyWithImpl(
      _$_ActivitySecurityConfigurationModeFollowersAndConnections _value,
      $Res Function(_$_ActivitySecurityConfigurationModeFollowersAndConnections)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ActivitySecurityConfigurationModeFollowersAndConnections
    implements _ActivitySecurityConfigurationModeFollowersAndConnections {
  const _$_ActivitySecurityConfigurationModeFollowersAndConnections();

  @override
  String toString() {
    return 'ActivitySecurityConfigurationMode.followersAndConnections()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$_ActivitySecurityConfigurationModeFollowersAndConnections);
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
      _$_ActivitySecurityConfigurationModeFollowersAndConnections;
}

/// @nodoc
abstract class _$$_ActivitySecurityConfigurationModeConnectionsCopyWith<$Res> {
  factory _$$_ActivitySecurityConfigurationModeConnectionsCopyWith(
          _$_ActivitySecurityConfigurationModeConnections value,
          $Res Function(_$_ActivitySecurityConfigurationModeConnections) then) =
      __$$_ActivitySecurityConfigurationModeConnectionsCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ActivitySecurityConfigurationModeConnectionsCopyWithImpl<$Res>
    extends _$ActivitySecurityConfigurationModeCopyWithImpl<$Res,
        _$_ActivitySecurityConfigurationModeConnections>
    implements _$$_ActivitySecurityConfigurationModeConnectionsCopyWith<$Res> {
  __$$_ActivitySecurityConfigurationModeConnectionsCopyWithImpl(
      _$_ActivitySecurityConfigurationModeConnections _value,
      $Res Function(_$_ActivitySecurityConfigurationModeConnections) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ActivitySecurityConfigurationModeConnections
    implements _ActivitySecurityConfigurationModeConnections {
  const _$_ActivitySecurityConfigurationModeConnections();

  @override
  String toString() {
    return 'ActivitySecurityConfigurationMode.connections()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivitySecurityConfigurationModeConnections);
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
      _$_ActivitySecurityConfigurationModeConnections;
}

/// @nodoc
abstract class _$$_ActivitySecurityConfigurationModePrivateCopyWith<$Res> {
  factory _$$_ActivitySecurityConfigurationModePrivateCopyWith(
          _$_ActivitySecurityConfigurationModePrivate value,
          $Res Function(_$_ActivitySecurityConfigurationModePrivate) then) =
      __$$_ActivitySecurityConfigurationModePrivateCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ActivitySecurityConfigurationModePrivateCopyWithImpl<$Res>
    extends _$ActivitySecurityConfigurationModeCopyWithImpl<$Res,
        _$_ActivitySecurityConfigurationModePrivate>
    implements _$$_ActivitySecurityConfigurationModePrivateCopyWith<$Res> {
  __$$_ActivitySecurityConfigurationModePrivateCopyWithImpl(
      _$_ActivitySecurityConfigurationModePrivate _value,
      $Res Function(_$_ActivitySecurityConfigurationModePrivate) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ActivitySecurityConfigurationModePrivate
    implements _ActivitySecurityConfigurationModePrivate {
  const _$_ActivitySecurityConfigurationModePrivate();

  @override
  String toString() {
    return 'ActivitySecurityConfigurationMode.private()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivitySecurityConfigurationModePrivate);
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
      _$_ActivitySecurityConfigurationModePrivate;
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
abstract class _$$_ActivityEventConfigurationCopyWith<$Res>
    implements $ActivityEventConfigurationCopyWith<$Res> {
  factory _$$_ActivityEventConfigurationCopyWith(
          _$_ActivityEventConfiguration value,
          $Res Function(_$_ActivityEventConfiguration) then) =
      __$$_ActivityEventConfigurationCopyWithImpl<$Res>;
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
class __$$_ActivityEventConfigurationCopyWithImpl<$Res>
    extends _$ActivityEventConfigurationCopyWithImpl<$Res,
        _$_ActivityEventConfiguration>
    implements _$$_ActivityEventConfigurationCopyWith<$Res> {
  __$$_ActivityEventConfigurationCopyWithImpl(
      _$_ActivityEventConfiguration _value,
      $Res Function(_$_ActivityEventConfiguration) _then)
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
    return _then(_$_ActivityEventConfiguration(
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
class _$_ActivityEventConfiguration implements _ActivityEventConfiguration {
  const _$_ActivityEventConfiguration(
      {this.venue,
      this.name = '',
      this.schedule,
      this.location = '',
      this.popularityScore = 0,
      this.isCancelled = false});

  factory _$_ActivityEventConfiguration.fromJson(Map<String, dynamic> json) =>
      _$$_ActivityEventConfigurationFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityEventConfiguration &&
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
  _$$_ActivityEventConfigurationCopyWith<_$_ActivityEventConfiguration>
      get copyWith => __$$_ActivityEventConfigurationCopyWithImpl<
          _$_ActivityEventConfiguration>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivityEventConfigurationToJson(
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
      final bool isCancelled}) = _$_ActivityEventConfiguration;

  factory _ActivityEventConfiguration.fromJson(Map<String, dynamic> json) =
      _$_ActivityEventConfiguration.fromJson;

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
  _$$_ActivityEventConfigurationCopyWith<_$_ActivityEventConfiguration>
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
abstract class _$$_ActivityScheduleCopyWith<$Res>
    implements $ActivityScheduleCopyWith<$Res> {
  factory _$$_ActivityScheduleCopyWith(
          _$_ActivitySchedule value, $Res Function(_$_ActivitySchedule) then) =
      __$$_ActivityScheduleCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String recurrenceRule, DateTime? start, DateTime? end});
}

/// @nodoc
class __$$_ActivityScheduleCopyWithImpl<$Res>
    extends _$ActivityScheduleCopyWithImpl<$Res, _$_ActivitySchedule>
    implements _$$_ActivityScheduleCopyWith<$Res> {
  __$$_ActivityScheduleCopyWithImpl(
      _$_ActivitySchedule _value, $Res Function(_$_ActivitySchedule) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recurrenceRule = null,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(_$_ActivitySchedule(
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
class _$_ActivitySchedule implements _ActivitySchedule {
  const _$_ActivitySchedule({this.recurrenceRule = '', this.start, this.end});

  factory _$_ActivitySchedule.fromJson(Map<String, dynamic> json) =>
      _$$_ActivityScheduleFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivitySchedule &&
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
  _$$_ActivityScheduleCopyWith<_$_ActivitySchedule> get copyWith =>
      __$$_ActivityScheduleCopyWithImpl<_$_ActivitySchedule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivityScheduleToJson(
      this,
    );
  }
}

abstract class _ActivitySchedule implements ActivitySchedule {
  const factory _ActivitySchedule(
      {final String recurrenceRule,
      final DateTime? start,
      final DateTime? end}) = _$_ActivitySchedule;

  factory _ActivitySchedule.fromJson(Map<String, dynamic> json) =
      _$_ActivitySchedule.fromJson;

  @override
  String get recurrenceRule;
  @override
  DateTime? get start;
  @override
  DateTime? get end;
  @override
  @JsonKey(ignore: true)
  _$$_ActivityScheduleCopyWith<_$_ActivitySchedule> get copyWith =>
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
abstract class _$$_ActivityPricingInformationCopyWith<$Res>
    implements $ActivityPricingInformationCopyWith<$Res> {
  factory _$$_ActivityPricingInformationCopyWith(
          _$_ActivityPricingInformation value,
          $Res Function(_$_ActivityPricingInformation) then) =
      __$$_ActivityPricingInformationCopyWithImpl<$Res>;
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
class __$$_ActivityPricingInformationCopyWithImpl<$Res>
    extends _$ActivityPricingInformationCopyWithImpl<$Res,
        _$_ActivityPricingInformation>
    implements _$$_ActivityPricingInformationCopyWith<$Res> {
  __$$_ActivityPricingInformationCopyWithImpl(
      _$_ActivityPricingInformation _value,
      $Res Function(_$_ActivityPricingInformation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? externalStoreInformation = freezed,
  }) {
    return _then(_$_ActivityPricingInformation(
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
class _$_ActivityPricingInformation implements _ActivityPricingInformation {
  const _$_ActivityPricingInformation(
      {this.productId = '', this.externalStoreInformation});

  factory _$_ActivityPricingInformation.fromJson(Map<String, dynamic> json) =>
      _$$_ActivityPricingInformationFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityPricingInformation &&
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
  _$$_ActivityPricingInformationCopyWith<_$_ActivityPricingInformation>
      get copyWith => __$$_ActivityPricingInformationCopyWithImpl<
          _$_ActivityPricingInformation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivityPricingInformationToJson(
      this,
    );
  }
}

abstract class _ActivityPricingInformation
    implements ActivityPricingInformation {
  const factory _ActivityPricingInformation(
      {final String productId,
      final ActivityPricingExternalStoreInformation?
          externalStoreInformation}) = _$_ActivityPricingInformation;

  factory _ActivityPricingInformation.fromJson(Map<String, dynamic> json) =
      _$_ActivityPricingInformation.fromJson;

  @override
  String get productId;
  @override
  ActivityPricingExternalStoreInformation? get externalStoreInformation;
  @override
  @JsonKey(ignore: true)
  _$$_ActivityPricingInformationCopyWith<_$_ActivityPricingInformation>
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
abstract class _$$_ActivityPricingExternalStoreInformationCopyWith<$Res>
    implements $ActivityPricingExternalStoreInformationCopyWith<$Res> {
  factory _$$_ActivityPricingExternalStoreInformationCopyWith(
          _$_ActivityPricingExternalStoreInformation value,
          $Res Function(_$_ActivityPricingExternalStoreInformation) then) =
      __$$_ActivityPricingExternalStoreInformationCopyWithImpl<$Res>;
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
class __$$_ActivityPricingExternalStoreInformationCopyWithImpl<$Res>
    extends _$ActivityPricingExternalStoreInformationCopyWithImpl<$Res,
        _$_ActivityPricingExternalStoreInformation>
    implements _$$_ActivityPricingExternalStoreInformationCopyWith<$Res> {
  __$$_ActivityPricingExternalStoreInformationCopyWithImpl(
      _$_ActivityPricingExternalStoreInformation _value,
      $Res Function(_$_ActivityPricingExternalStoreInformation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? costExact = null,
    Object? costMinimum = null,
    Object? costMaximum = null,
    Object? pricingStrategy = null,
  }) {
    return _then(_$_ActivityPricingExternalStoreInformation(
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
class _$_ActivityPricingExternalStoreInformation
    implements _ActivityPricingExternalStoreInformation {
  const _$_ActivityPricingExternalStoreInformation(
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

  factory _$_ActivityPricingExternalStoreInformation.fromJson(
          Map<String, dynamic> json) =>
      _$$_ActivityPricingExternalStoreInformationFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityPricingExternalStoreInformation &&
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
  _$$_ActivityPricingExternalStoreInformationCopyWith<
          _$_ActivityPricingExternalStoreInformation>
      get copyWith => __$$_ActivityPricingExternalStoreInformationCopyWithImpl<
          _$_ActivityPricingExternalStoreInformation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivityPricingExternalStoreInformationToJson(
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
          pricingStrategy}) = _$_ActivityPricingExternalStoreInformation;

  factory _ActivityPricingExternalStoreInformation.fromJson(
          Map<String, dynamic> json) =
      _$_ActivityPricingExternalStoreInformation.fromJson;

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
  _$$_ActivityPricingExternalStoreInformationCopyWith<
          _$_ActivityPricingExternalStoreInformation>
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
abstract class _$$_ActivityPricingExternalStoreInformationPricingStrategyOnePersonCopyWith<
    $Res> {
  factory _$$_ActivityPricingExternalStoreInformationPricingStrategyOnePersonCopyWith(
          _$_ActivityPricingExternalStoreInformationPricingStrategyOnePerson value,
          $Res Function(
                  _$_ActivityPricingExternalStoreInformationPricingStrategyOnePerson)
              then) =
      __$$_ActivityPricingExternalStoreInformationPricingStrategyOnePersonCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$_ActivityPricingExternalStoreInformationPricingStrategyOnePersonCopyWithImpl<
        $Res>
    extends _$ActivityPricingExternalStoreInformationPricingStrategyCopyWithImpl<
        $Res,
        _$_ActivityPricingExternalStoreInformationPricingStrategyOnePerson>
    implements
        _$$_ActivityPricingExternalStoreInformationPricingStrategyOnePersonCopyWith<
            $Res> {
  __$$_ActivityPricingExternalStoreInformationPricingStrategyOnePersonCopyWithImpl(
      _$_ActivityPricingExternalStoreInformationPricingStrategyOnePerson _value,
      $Res Function(
              _$_ActivityPricingExternalStoreInformationPricingStrategyOnePerson)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ActivityPricingExternalStoreInformationPricingStrategyOnePerson
    implements
        _ActivityPricingExternalStoreInformationPricingStrategyOnePerson {
  const _$_ActivityPricingExternalStoreInformationPricingStrategyOnePerson();

  @override
  String toString() {
    return 'ActivityPricingExternalStoreInformationPricingStrategy.onePerson()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$_ActivityPricingExternalStoreInformationPricingStrategyOnePerson);
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
      _$_ActivityPricingExternalStoreInformationPricingStrategyOnePerson;
}

ActivityPublisherInformation _$ActivityPublisherInformationFromJson(
    Map<String, dynamic> json) {
  return _ActivityPublisherInformation.fromJson(json);
}

/// @nodoc
mixin _$ActivityPublisherInformation {
  String get foreignKey => throw _privateConstructorUsedError;

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
  $Res call({String foreignKey});
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
    Object? foreignKey = null,
  }) {
    return _then(_value.copyWith(
      foreignKey: null == foreignKey
          ? _value.foreignKey
          : foreignKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ActivityPublisherInformationCopyWith<$Res>
    implements $ActivityPublisherInformationCopyWith<$Res> {
  factory _$$_ActivityPublisherInformationCopyWith(
          _$_ActivityPublisherInformation value,
          $Res Function(_$_ActivityPublisherInformation) then) =
      __$$_ActivityPublisherInformationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String foreignKey});
}

/// @nodoc
class __$$_ActivityPublisherInformationCopyWithImpl<$Res>
    extends _$ActivityPublisherInformationCopyWithImpl<$Res,
        _$_ActivityPublisherInformation>
    implements _$$_ActivityPublisherInformationCopyWith<$Res> {
  __$$_ActivityPublisherInformationCopyWithImpl(
      _$_ActivityPublisherInformation _value,
      $Res Function(_$_ActivityPublisherInformation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foreignKey = null,
  }) {
    return _then(_$_ActivityPublisherInformation(
      foreignKey: null == foreignKey
          ? _value.foreignKey
          : foreignKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ActivityPublisherInformation implements _ActivityPublisherInformation {
  const _$_ActivityPublisherInformation({this.foreignKey = ''});

  factory _$_ActivityPublisherInformation.fromJson(Map<String, dynamic> json) =>
      _$$_ActivityPublisherInformationFromJson(json);

  @override
  @JsonKey()
  final String foreignKey;

  @override
  String toString() {
    return 'ActivityPublisherInformation(foreignKey: $foreignKey)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityPublisherInformation &&
            (identical(other.foreignKey, foreignKey) ||
                other.foreignKey == foreignKey));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, foreignKey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActivityPublisherInformationCopyWith<_$_ActivityPublisherInformation>
      get copyWith => __$$_ActivityPublisherInformationCopyWithImpl<
          _$_ActivityPublisherInformation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivityPublisherInformationToJson(
      this,
    );
  }
}

abstract class _ActivityPublisherInformation
    implements ActivityPublisherInformation {
  const factory _ActivityPublisherInformation({final String foreignKey}) =
      _$_ActivityPublisherInformation;

  factory _ActivityPublisherInformation.fromJson(Map<String, dynamic> json) =
      _$_ActivityPublisherInformation.fromJson;

  @override
  String get foreignKey;
  @override
  @JsonKey(ignore: true)
  _$$_ActivityPublisherInformationCopyWith<_$_ActivityPublisherInformation>
      get copyWith => throw _privateConstructorUsedError;
}

ActivityEnrichmentConfiguration _$ActivityEnrichmentConfigurationFromJson(
    Map<String, dynamic> json) {
  return _ActivityEnrichmentConfiguration.fromJson(json);
}

/// @nodoc
mixin _$ActivityEnrichmentConfiguration {
  String get title => throw _privateConstructorUsedError;
  @JsonKey(fromJson: stringListFromJson)
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isSensitive => throw _privateConstructorUsedError;
  String get publishLocation => throw _privateConstructorUsedError;
  @JsonKey(fromJson: ActivityMention.fromJsonList)
  List<ActivityMention> get mentions => throw _privateConstructorUsedError;

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
      {String title,
      @JsonKey(fromJson: stringListFromJson) List<String> tags,
      bool isSensitive,
      String publishLocation,
      @JsonKey(fromJson: ActivityMention.fromJsonList)
      List<ActivityMention> mentions});
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
    Object? title = null,
    Object? tags = null,
    Object? isSensitive = null,
    Object? publishLocation = null,
    Object? mentions = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isSensitive: null == isSensitive
          ? _value.isSensitive
          : isSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
      publishLocation: null == publishLocation
          ? _value.publishLocation
          : publishLocation // ignore: cast_nullable_to_non_nullable
              as String,
      mentions: null == mentions
          ? _value.mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<ActivityMention>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ActivityEnrichmentConfigurationCopyWith<$Res>
    implements $ActivityEnrichmentConfigurationCopyWith<$Res> {
  factory _$$_ActivityEnrichmentConfigurationCopyWith(
          _$_ActivityEnrichmentConfiguration value,
          $Res Function(_$_ActivityEnrichmentConfiguration) then) =
      __$$_ActivityEnrichmentConfigurationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      @JsonKey(fromJson: stringListFromJson) List<String> tags,
      bool isSensitive,
      String publishLocation,
      @JsonKey(fromJson: ActivityMention.fromJsonList)
      List<ActivityMention> mentions});
}

/// @nodoc
class __$$_ActivityEnrichmentConfigurationCopyWithImpl<$Res>
    extends _$ActivityEnrichmentConfigurationCopyWithImpl<$Res,
        _$_ActivityEnrichmentConfiguration>
    implements _$$_ActivityEnrichmentConfigurationCopyWith<$Res> {
  __$$_ActivityEnrichmentConfigurationCopyWithImpl(
      _$_ActivityEnrichmentConfiguration _value,
      $Res Function(_$_ActivityEnrichmentConfiguration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? tags = null,
    Object? isSensitive = null,
    Object? publishLocation = null,
    Object? mentions = null,
  }) {
    return _then(_$_ActivityEnrichmentConfiguration(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isSensitive: null == isSensitive
          ? _value.isSensitive
          : isSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
      publishLocation: null == publishLocation
          ? _value.publishLocation
          : publishLocation // ignore: cast_nullable_to_non_nullable
              as String,
      mentions: null == mentions
          ? _value._mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<ActivityMention>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ActivityEnrichmentConfiguration
    implements _ActivityEnrichmentConfiguration {
  const _$_ActivityEnrichmentConfiguration(
      {this.title = '',
      @JsonKey(fromJson: stringListFromJson) final List<String> tags = const [],
      this.isSensitive = false,
      this.publishLocation = '',
      @JsonKey(fromJson: ActivityMention.fromJsonList)
      final List<ActivityMention> mentions = const []})
      : _tags = tags,
        _mentions = mentions;

  factory _$_ActivityEnrichmentConfiguration.fromJson(
          Map<String, dynamic> json) =>
      _$$_ActivityEnrichmentConfigurationFromJson(json);

  @override
  @JsonKey()
  final String title;
  final List<String> _tags;
  @override
  @JsonKey(fromJson: stringListFromJson)
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isSensitive;
  @override
  @JsonKey()
  final String publishLocation;
  final List<ActivityMention> _mentions;
  @override
  @JsonKey(fromJson: ActivityMention.fromJsonList)
  List<ActivityMention> get mentions {
    if (_mentions is EqualUnmodifiableListView) return _mentions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mentions);
  }

  @override
  String toString() {
    return 'ActivityEnrichmentConfiguration(title: $title, tags: $tags, isSensitive: $isSensitive, publishLocation: $publishLocation, mentions: $mentions)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityEnrichmentConfiguration &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isSensitive, isSensitive) ||
                other.isSensitive == isSensitive) &&
            (identical(other.publishLocation, publishLocation) ||
                other.publishLocation == publishLocation) &&
            const DeepCollectionEquality().equals(other._mentions, _mentions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      const DeepCollectionEquality().hash(_tags),
      isSensitive,
      publishLocation,
      const DeepCollectionEquality().hash(_mentions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActivityEnrichmentConfigurationCopyWith<
          _$_ActivityEnrichmentConfiguration>
      get copyWith => __$$_ActivityEnrichmentConfigurationCopyWithImpl<
          _$_ActivityEnrichmentConfiguration>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivityEnrichmentConfigurationToJson(
      this,
    );
  }
}

abstract class _ActivityEnrichmentConfiguration
    implements ActivityEnrichmentConfiguration {
  const factory _ActivityEnrichmentConfiguration(
          {final String title,
          @JsonKey(fromJson: stringListFromJson) final List<String> tags,
          final bool isSensitive,
          final String publishLocation,
          @JsonKey(fromJson: ActivityMention.fromJsonList)
          final List<ActivityMention> mentions}) =
      _$_ActivityEnrichmentConfiguration;

  factory _ActivityEnrichmentConfiguration.fromJson(Map<String, dynamic> json) =
      _$_ActivityEnrichmentConfiguration.fromJson;

  @override
  String get title;
  @override
  @JsonKey(fromJson: stringListFromJson)
  List<String> get tags;
  @override
  bool get isSensitive;
  @override
  String get publishLocation;
  @override
  @JsonKey(fromJson: ActivityMention.fromJsonList)
  List<ActivityMention> get mentions;
  @override
  @JsonKey(ignore: true)
  _$$_ActivityEnrichmentConfigurationCopyWith<
          _$_ActivityEnrichmentConfiguration>
      get copyWith => throw _privateConstructorUsedError;
}

ActivityMention _$ActivityMentionFromJson(Map<String, dynamic> json) {
  return _ActivityMention.fromJson(json);
}

/// @nodoc
mixin _$ActivityMention {
  int get startIndex => throw _privateConstructorUsedError;
  int get endIndex => throw _privateConstructorUsedError;
  String get organisation => throw _privateConstructorUsedError;
  String get user => throw _privateConstructorUsedError;
  String get activity => throw _privateConstructorUsedError;
  String get tag => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityMentionCopyWith<ActivityMention> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityMentionCopyWith<$Res> {
  factory $ActivityMentionCopyWith(
          ActivityMention value, $Res Function(ActivityMention) then) =
      _$ActivityMentionCopyWithImpl<$Res, ActivityMention>;
  @useResult
  $Res call(
      {int startIndex,
      int endIndex,
      String organisation,
      String user,
      String activity,
      String tag});
}

/// @nodoc
class _$ActivityMentionCopyWithImpl<$Res, $Val extends ActivityMention>
    implements $ActivityMentionCopyWith<$Res> {
  _$ActivityMentionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startIndex = null,
    Object? endIndex = null,
    Object? organisation = null,
    Object? user = null,
    Object? activity = null,
    Object? tag = null,
  }) {
    return _then(_value.copyWith(
      startIndex: null == startIndex
          ? _value.startIndex
          : startIndex // ignore: cast_nullable_to_non_nullable
              as int,
      endIndex: null == endIndex
          ? _value.endIndex
          : endIndex // ignore: cast_nullable_to_non_nullable
              as int,
      organisation: null == organisation
          ? _value.organisation
          : organisation // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String,
      activity: null == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ActivityMentionCopyWith<$Res>
    implements $ActivityMentionCopyWith<$Res> {
  factory _$$_ActivityMentionCopyWith(
          _$_ActivityMention value, $Res Function(_$_ActivityMention) then) =
      __$$_ActivityMentionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int startIndex,
      int endIndex,
      String organisation,
      String user,
      String activity,
      String tag});
}

/// @nodoc
class __$$_ActivityMentionCopyWithImpl<$Res>
    extends _$ActivityMentionCopyWithImpl<$Res, _$_ActivityMention>
    implements _$$_ActivityMentionCopyWith<$Res> {
  __$$_ActivityMentionCopyWithImpl(
      _$_ActivityMention _value, $Res Function(_$_ActivityMention) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startIndex = null,
    Object? endIndex = null,
    Object? organisation = null,
    Object? user = null,
    Object? activity = null,
    Object? tag = null,
  }) {
    return _then(_$_ActivityMention(
      startIndex: null == startIndex
          ? _value.startIndex
          : startIndex // ignore: cast_nullable_to_non_nullable
              as int,
      endIndex: null == endIndex
          ? _value.endIndex
          : endIndex // ignore: cast_nullable_to_non_nullable
              as int,
      organisation: null == organisation
          ? _value.organisation
          : organisation // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String,
      activity: null == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ActivityMention implements _ActivityMention {
  const _$_ActivityMention(
      {this.startIndex = -1,
      this.endIndex = -1,
      this.organisation = '',
      this.user = '',
      this.activity = '',
      this.tag = ''});

  factory _$_ActivityMention.fromJson(Map<String, dynamic> json) =>
      _$$_ActivityMentionFromJson(json);

  @override
  @JsonKey()
  final int startIndex;
  @override
  @JsonKey()
  final int endIndex;
  @override
  @JsonKey()
  final String organisation;
  @override
  @JsonKey()
  final String user;
  @override
  @JsonKey()
  final String activity;
  @override
  @JsonKey()
  final String tag;

  @override
  String toString() {
    return 'ActivityMention(startIndex: $startIndex, endIndex: $endIndex, organisation: $organisation, user: $user, activity: $activity, tag: $tag)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityMention &&
            (identical(other.startIndex, startIndex) ||
                other.startIndex == startIndex) &&
            (identical(other.endIndex, endIndex) ||
                other.endIndex == endIndex) &&
            (identical(other.organisation, organisation) ||
                other.organisation == organisation) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.activity, activity) ||
                other.activity == activity) &&
            (identical(other.tag, tag) || other.tag == tag));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, startIndex, endIndex, organisation, user, activity, tag);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActivityMentionCopyWith<_$_ActivityMention> get copyWith =>
      __$$_ActivityMentionCopyWithImpl<_$_ActivityMention>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivityMentionToJson(
      this,
    );
  }
}

abstract class _ActivityMention implements ActivityMention {
  const factory _ActivityMention(
      {final int startIndex,
      final int endIndex,
      final String organisation,
      final String user,
      final String activity,
      final String tag}) = _$_ActivityMention;

  factory _ActivityMention.fromJson(Map<String, dynamic> json) =
      _$_ActivityMention.fromJson;

  @override
  int get startIndex;
  @override
  int get endIndex;
  @override
  String get organisation;
  @override
  String get user;
  @override
  String get activity;
  @override
  String get tag;
  @override
  @JsonKey(ignore: true)
  _$$_ActivityMentionCopyWith<_$_ActivityMention> get copyWith =>
      throw _privateConstructorUsedError;
}
