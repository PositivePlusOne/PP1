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
  String get foreignKey => throw _privateConstructorUsedError;
  List<Media> get media => throw _privateConstructorUsedError;
  PricingInformation? get pricingInformation =>
      throw _privateConstructorUsedError;
  EnrichmentConfiguration? get enrichmentConfiguration =>
      throw _privateConstructorUsedError;
  PublisherInformation? get publisherInformation =>
      throw _privateConstructorUsedError;
  GeneralConfiguration? get generalConfiguration =>
      throw _privateConstructorUsedError;
  EventConfiguration? get eventConfiguration =>
      throw _privateConstructorUsedError;
  SecurityConfiguration? get securityConfiguration =>
      throw _privateConstructorUsedError;

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
      {String foreignKey,
      List<Media> media,
      PricingInformation? pricingInformation,
      EnrichmentConfiguration? enrichmentConfiguration,
      PublisherInformation? publisherInformation,
      GeneralConfiguration? generalConfiguration,
      EventConfiguration? eventConfiguration,
      SecurityConfiguration? securityConfiguration});

  $PricingInformationCopyWith<$Res>? get pricingInformation;
  $EnrichmentConfigurationCopyWith<$Res>? get enrichmentConfiguration;
  $PublisherInformationCopyWith<$Res>? get publisherInformation;
  $GeneralConfigurationCopyWith<$Res>? get generalConfiguration;
  $EventConfigurationCopyWith<$Res>? get eventConfiguration;
  $SecurityConfigurationCopyWith<$Res>? get securityConfiguration;
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
    Object? foreignKey = null,
    Object? media = null,
    Object? pricingInformation = freezed,
    Object? enrichmentConfiguration = freezed,
    Object? publisherInformation = freezed,
    Object? generalConfiguration = freezed,
    Object? eventConfiguration = freezed,
    Object? securityConfiguration = freezed,
  }) {
    return _then(_value.copyWith(
      foreignKey: null == foreignKey
          ? _value.foreignKey
          : foreignKey // ignore: cast_nullable_to_non_nullable
              as String,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>,
      pricingInformation: freezed == pricingInformation
          ? _value.pricingInformation
          : pricingInformation // ignore: cast_nullable_to_non_nullable
              as PricingInformation?,
      enrichmentConfiguration: freezed == enrichmentConfiguration
          ? _value.enrichmentConfiguration
          : enrichmentConfiguration // ignore: cast_nullable_to_non_nullable
              as EnrichmentConfiguration?,
      publisherInformation: freezed == publisherInformation
          ? _value.publisherInformation
          : publisherInformation // ignore: cast_nullable_to_non_nullable
              as PublisherInformation?,
      generalConfiguration: freezed == generalConfiguration
          ? _value.generalConfiguration
          : generalConfiguration // ignore: cast_nullable_to_non_nullable
              as GeneralConfiguration?,
      eventConfiguration: freezed == eventConfiguration
          ? _value.eventConfiguration
          : eventConfiguration // ignore: cast_nullable_to_non_nullable
              as EventConfiguration?,
      securityConfiguration: freezed == securityConfiguration
          ? _value.securityConfiguration
          : securityConfiguration // ignore: cast_nullable_to_non_nullable
              as SecurityConfiguration?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PricingInformationCopyWith<$Res>? get pricingInformation {
    if (_value.pricingInformation == null) {
      return null;
    }

    return $PricingInformationCopyWith<$Res>(_value.pricingInformation!,
        (value) {
      return _then(_value.copyWith(pricingInformation: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EnrichmentConfigurationCopyWith<$Res>? get enrichmentConfiguration {
    if (_value.enrichmentConfiguration == null) {
      return null;
    }

    return $EnrichmentConfigurationCopyWith<$Res>(
        _value.enrichmentConfiguration!, (value) {
      return _then(_value.copyWith(enrichmentConfiguration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PublisherInformationCopyWith<$Res>? get publisherInformation {
    if (_value.publisherInformation == null) {
      return null;
    }

    return $PublisherInformationCopyWith<$Res>(_value.publisherInformation!,
        (value) {
      return _then(_value.copyWith(publisherInformation: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GeneralConfigurationCopyWith<$Res>? get generalConfiguration {
    if (_value.generalConfiguration == null) {
      return null;
    }

    return $GeneralConfigurationCopyWith<$Res>(_value.generalConfiguration!,
        (value) {
      return _then(_value.copyWith(generalConfiguration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EventConfigurationCopyWith<$Res>? get eventConfiguration {
    if (_value.eventConfiguration == null) {
      return null;
    }

    return $EventConfigurationCopyWith<$Res>(_value.eventConfiguration!,
        (value) {
      return _then(_value.copyWith(eventConfiguration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SecurityConfigurationCopyWith<$Res>? get securityConfiguration {
    if (_value.securityConfiguration == null) {
      return null;
    }

    return $SecurityConfigurationCopyWith<$Res>(_value.securityConfiguration!,
        (value) {
      return _then(_value.copyWith(securityConfiguration: value) as $Val);
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
      {String foreignKey,
      List<Media> media,
      PricingInformation? pricingInformation,
      EnrichmentConfiguration? enrichmentConfiguration,
      PublisherInformation? publisherInformation,
      GeneralConfiguration? generalConfiguration,
      EventConfiguration? eventConfiguration,
      SecurityConfiguration? securityConfiguration});

  @override
  $PricingInformationCopyWith<$Res>? get pricingInformation;
  @override
  $EnrichmentConfigurationCopyWith<$Res>? get enrichmentConfiguration;
  @override
  $PublisherInformationCopyWith<$Res>? get publisherInformation;
  @override
  $GeneralConfigurationCopyWith<$Res>? get generalConfiguration;
  @override
  $EventConfigurationCopyWith<$Res>? get eventConfiguration;
  @override
  $SecurityConfigurationCopyWith<$Res>? get securityConfiguration;
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
    Object? foreignKey = null,
    Object? media = null,
    Object? pricingInformation = freezed,
    Object? enrichmentConfiguration = freezed,
    Object? publisherInformation = freezed,
    Object? generalConfiguration = freezed,
    Object? eventConfiguration = freezed,
    Object? securityConfiguration = freezed,
  }) {
    return _then(_$_Activity(
      foreignKey: null == foreignKey
          ? _value.foreignKey
          : foreignKey // ignore: cast_nullable_to_non_nullable
              as String,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>,
      pricingInformation: freezed == pricingInformation
          ? _value.pricingInformation
          : pricingInformation // ignore: cast_nullable_to_non_nullable
              as PricingInformation?,
      enrichmentConfiguration: freezed == enrichmentConfiguration
          ? _value.enrichmentConfiguration
          : enrichmentConfiguration // ignore: cast_nullable_to_non_nullable
              as EnrichmentConfiguration?,
      publisherInformation: freezed == publisherInformation
          ? _value.publisherInformation
          : publisherInformation // ignore: cast_nullable_to_non_nullable
              as PublisherInformation?,
      generalConfiguration: freezed == generalConfiguration
          ? _value.generalConfiguration
          : generalConfiguration // ignore: cast_nullable_to_non_nullable
              as GeneralConfiguration?,
      eventConfiguration: freezed == eventConfiguration
          ? _value.eventConfiguration
          : eventConfiguration // ignore: cast_nullable_to_non_nullable
              as EventConfiguration?,
      securityConfiguration: freezed == securityConfiguration
          ? _value.securityConfiguration
          : securityConfiguration // ignore: cast_nullable_to_non_nullable
              as SecurityConfiguration?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Activity implements _Activity {
  _$_Activity(
      {this.foreignKey = '',
      final List<Media> media = const [],
      this.pricingInformation,
      this.enrichmentConfiguration,
      this.publisherInformation,
      this.generalConfiguration,
      this.eventConfiguration,
      this.securityConfiguration})
      : _media = media;

  factory _$_Activity.fromJson(Map<String, dynamic> json) =>
      _$$_ActivityFromJson(json);

  @override
  @JsonKey()
  final String foreignKey;
  final List<Media> _media;
  @override
  @JsonKey()
  List<Media> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  @override
  final PricingInformation? pricingInformation;
  @override
  final EnrichmentConfiguration? enrichmentConfiguration;
  @override
  final PublisherInformation? publisherInformation;
  @override
  final GeneralConfiguration? generalConfiguration;
  @override
  final EventConfiguration? eventConfiguration;
  @override
  final SecurityConfiguration? securityConfiguration;

  @override
  String toString() {
    return 'Activity(foreignKey: $foreignKey, media: $media, pricingInformation: $pricingInformation, enrichmentConfiguration: $enrichmentConfiguration, publisherInformation: $publisherInformation, generalConfiguration: $generalConfiguration, eventConfiguration: $eventConfiguration, securityConfiguration: $securityConfiguration)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Activity &&
            (identical(other.foreignKey, foreignKey) ||
                other.foreignKey == foreignKey) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            (identical(other.pricingInformation, pricingInformation) ||
                other.pricingInformation == pricingInformation) &&
            (identical(
                    other.enrichmentConfiguration, enrichmentConfiguration) ||
                other.enrichmentConfiguration == enrichmentConfiguration) &&
            (identical(other.publisherInformation, publisherInformation) ||
                other.publisherInformation == publisherInformation) &&
            (identical(other.generalConfiguration, generalConfiguration) ||
                other.generalConfiguration == generalConfiguration) &&
            (identical(other.eventConfiguration, eventConfiguration) ||
                other.eventConfiguration == eventConfiguration) &&
            (identical(other.securityConfiguration, securityConfiguration) ||
                other.securityConfiguration == securityConfiguration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      foreignKey,
      const DeepCollectionEquality().hash(_media),
      pricingInformation,
      enrichmentConfiguration,
      publisherInformation,
      generalConfiguration,
      eventConfiguration,
      securityConfiguration);

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
  factory _Activity(
      {final String foreignKey,
      final List<Media> media,
      final PricingInformation? pricingInformation,
      final EnrichmentConfiguration? enrichmentConfiguration,
      final PublisherInformation? publisherInformation,
      final GeneralConfiguration? generalConfiguration,
      final EventConfiguration? eventConfiguration,
      final SecurityConfiguration? securityConfiguration}) = _$_Activity;

  factory _Activity.fromJson(Map<String, dynamic> json) = _$_Activity.fromJson;

  @override
  String get foreignKey;
  @override
  List<Media> get media;
  @override
  PricingInformation? get pricingInformation;
  @override
  EnrichmentConfiguration? get enrichmentConfiguration;
  @override
  PublisherInformation? get publisherInformation;
  @override
  GeneralConfiguration? get generalConfiguration;
  @override
  EventConfiguration? get eventConfiguration;
  @override
  SecurityConfiguration? get securityConfiguration;
  @override
  @JsonKey(ignore: true)
  _$$_ActivityCopyWith<_$_Activity> get copyWith =>
      throw _privateConstructorUsedError;
}

PricingInformation _$PricingInformationFromJson(Map<String, dynamic> json) {
  return _PricingInformation.fromJson(json);
}

/// @nodoc
mixin _$PricingInformation {
  ExternalStoreInformation? get externalStoreInformation =>
      throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PricingInformationCopyWith<PricingInformation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PricingInformationCopyWith<$Res> {
  factory $PricingInformationCopyWith(
          PricingInformation value, $Res Function(PricingInformation) then) =
      _$PricingInformationCopyWithImpl<$Res, PricingInformation>;
  @useResult
  $Res call(
      {ExternalStoreInformation? externalStoreInformation, String productId});

  $ExternalStoreInformationCopyWith<$Res>? get externalStoreInformation;
}

/// @nodoc
class _$PricingInformationCopyWithImpl<$Res, $Val extends PricingInformation>
    implements $PricingInformationCopyWith<$Res> {
  _$PricingInformationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? externalStoreInformation = freezed,
    Object? productId = null,
  }) {
    return _then(_value.copyWith(
      externalStoreInformation: freezed == externalStoreInformation
          ? _value.externalStoreInformation
          : externalStoreInformation // ignore: cast_nullable_to_non_nullable
              as ExternalStoreInformation?,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ExternalStoreInformationCopyWith<$Res>? get externalStoreInformation {
    if (_value.externalStoreInformation == null) {
      return null;
    }

    return $ExternalStoreInformationCopyWith<$Res>(
        _value.externalStoreInformation!, (value) {
      return _then(_value.copyWith(externalStoreInformation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PricingInformationCopyWith<$Res>
    implements $PricingInformationCopyWith<$Res> {
  factory _$$_PricingInformationCopyWith(_$_PricingInformation value,
          $Res Function(_$_PricingInformation) then) =
      __$$_PricingInformationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ExternalStoreInformation? externalStoreInformation, String productId});

  @override
  $ExternalStoreInformationCopyWith<$Res>? get externalStoreInformation;
}

/// @nodoc
class __$$_PricingInformationCopyWithImpl<$Res>
    extends _$PricingInformationCopyWithImpl<$Res, _$_PricingInformation>
    implements _$$_PricingInformationCopyWith<$Res> {
  __$$_PricingInformationCopyWithImpl(
      _$_PricingInformation _value, $Res Function(_$_PricingInformation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? externalStoreInformation = freezed,
    Object? productId = null,
  }) {
    return _then(_$_PricingInformation(
      externalStoreInformation: freezed == externalStoreInformation
          ? _value.externalStoreInformation
          : externalStoreInformation // ignore: cast_nullable_to_non_nullable
              as ExternalStoreInformation?,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PricingInformation implements _PricingInformation {
  _$_PricingInformation({this.externalStoreInformation, this.productId = ''});

  factory _$_PricingInformation.fromJson(Map<String, dynamic> json) =>
      _$$_PricingInformationFromJson(json);

  @override
  final ExternalStoreInformation? externalStoreInformation;
  @override
  @JsonKey()
  final String productId;

  @override
  String toString() {
    return 'PricingInformation(externalStoreInformation: $externalStoreInformation, productId: $productId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PricingInformation &&
            (identical(
                    other.externalStoreInformation, externalStoreInformation) ||
                other.externalStoreInformation == externalStoreInformation) &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, externalStoreInformation, productId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PricingInformationCopyWith<_$_PricingInformation> get copyWith =>
      __$$_PricingInformationCopyWithImpl<_$_PricingInformation>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PricingInformationToJson(
      this,
    );
  }
}

abstract class _PricingInformation implements PricingInformation {
  factory _PricingInformation(
      {final ExternalStoreInformation? externalStoreInformation,
      final String productId}) = _$_PricingInformation;

  factory _PricingInformation.fromJson(Map<String, dynamic> json) =
      _$_PricingInformation.fromJson;

  @override
  ExternalStoreInformation? get externalStoreInformation;
  @override
  String get productId;
  @override
  @JsonKey(ignore: true)
  _$$_PricingInformationCopyWith<_$_PricingInformation> get copyWith =>
      throw _privateConstructorUsedError;
}

ExternalStoreInformation _$ExternalStoreInformationFromJson(
    Map<String, dynamic> json) {
  return _ExternalStoreInformation.fromJson(json);
}

/// @nodoc
mixin _$ExternalStoreInformation {
  String get costMaximum => throw _privateConstructorUsedError;
  String get pricingStrategy => throw _privateConstructorUsedError;
  String get costMinimum => throw _privateConstructorUsedError;
  String get costExact => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExternalStoreInformationCopyWith<ExternalStoreInformation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExternalStoreInformationCopyWith<$Res> {
  factory $ExternalStoreInformationCopyWith(ExternalStoreInformation value,
          $Res Function(ExternalStoreInformation) then) =
      _$ExternalStoreInformationCopyWithImpl<$Res, ExternalStoreInformation>;
  @useResult
  $Res call(
      {String costMaximum,
      String pricingStrategy,
      String costMinimum,
      String costExact});
}

/// @nodoc
class _$ExternalStoreInformationCopyWithImpl<$Res,
        $Val extends ExternalStoreInformation>
    implements $ExternalStoreInformationCopyWith<$Res> {
  _$ExternalStoreInformationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? costMaximum = null,
    Object? pricingStrategy = null,
    Object? costMinimum = null,
    Object? costExact = null,
  }) {
    return _then(_value.copyWith(
      costMaximum: null == costMaximum
          ? _value.costMaximum
          : costMaximum // ignore: cast_nullable_to_non_nullable
              as String,
      pricingStrategy: null == pricingStrategy
          ? _value.pricingStrategy
          : pricingStrategy // ignore: cast_nullable_to_non_nullable
              as String,
      costMinimum: null == costMinimum
          ? _value.costMinimum
          : costMinimum // ignore: cast_nullable_to_non_nullable
              as String,
      costExact: null == costExact
          ? _value.costExact
          : costExact // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ExternalStoreInformationCopyWith<$Res>
    implements $ExternalStoreInformationCopyWith<$Res> {
  factory _$$_ExternalStoreInformationCopyWith(
          _$_ExternalStoreInformation value,
          $Res Function(_$_ExternalStoreInformation) then) =
      __$$_ExternalStoreInformationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String costMaximum,
      String pricingStrategy,
      String costMinimum,
      String costExact});
}

/// @nodoc
class __$$_ExternalStoreInformationCopyWithImpl<$Res>
    extends _$ExternalStoreInformationCopyWithImpl<$Res,
        _$_ExternalStoreInformation>
    implements _$$_ExternalStoreInformationCopyWith<$Res> {
  __$$_ExternalStoreInformationCopyWithImpl(_$_ExternalStoreInformation _value,
      $Res Function(_$_ExternalStoreInformation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? costMaximum = null,
    Object? pricingStrategy = null,
    Object? costMinimum = null,
    Object? costExact = null,
  }) {
    return _then(_$_ExternalStoreInformation(
      costMaximum: null == costMaximum
          ? _value.costMaximum
          : costMaximum // ignore: cast_nullable_to_non_nullable
              as String,
      pricingStrategy: null == pricingStrategy
          ? _value.pricingStrategy
          : pricingStrategy // ignore: cast_nullable_to_non_nullable
              as String,
      costMinimum: null == costMinimum
          ? _value.costMinimum
          : costMinimum // ignore: cast_nullable_to_non_nullable
              as String,
      costExact: null == costExact
          ? _value.costExact
          : costExact // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ExternalStoreInformation implements _ExternalStoreInformation {
  _$_ExternalStoreInformation(
      {this.costMaximum = '',
      this.pricingStrategy = '',
      this.costMinimum = '',
      this.costExact = ''});

  factory _$_ExternalStoreInformation.fromJson(Map<String, dynamic> json) =>
      _$$_ExternalStoreInformationFromJson(json);

  @override
  @JsonKey()
  final String costMaximum;
  @override
  @JsonKey()
  final String pricingStrategy;
  @override
  @JsonKey()
  final String costMinimum;
  @override
  @JsonKey()
  final String costExact;

  @override
  String toString() {
    return 'ExternalStoreInformation(costMaximum: $costMaximum, pricingStrategy: $pricingStrategy, costMinimum: $costMinimum, costExact: $costExact)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ExternalStoreInformation &&
            (identical(other.costMaximum, costMaximum) ||
                other.costMaximum == costMaximum) &&
            (identical(other.pricingStrategy, pricingStrategy) ||
                other.pricingStrategy == pricingStrategy) &&
            (identical(other.costMinimum, costMinimum) ||
                other.costMinimum == costMinimum) &&
            (identical(other.costExact, costExact) ||
                other.costExact == costExact));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, costMaximum, pricingStrategy, costMinimum, costExact);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ExternalStoreInformationCopyWith<_$_ExternalStoreInformation>
      get copyWith => __$$_ExternalStoreInformationCopyWithImpl<
          _$_ExternalStoreInformation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ExternalStoreInformationToJson(
      this,
    );
  }
}

abstract class _ExternalStoreInformation implements ExternalStoreInformation {
  factory _ExternalStoreInformation(
      {final String costMaximum,
      final String pricingStrategy,
      final String costMinimum,
      final String costExact}) = _$_ExternalStoreInformation;

  factory _ExternalStoreInformation.fromJson(Map<String, dynamic> json) =
      _$_ExternalStoreInformation.fromJson;

  @override
  String get costMaximum;
  @override
  String get pricingStrategy;
  @override
  String get costMinimum;
  @override
  String get costExact;
  @override
  @JsonKey(ignore: true)
  _$$_ExternalStoreInformationCopyWith<_$_ExternalStoreInformation>
      get copyWith => throw _privateConstructorUsedError;
}

EnrichmentConfiguration _$EnrichmentConfigurationFromJson(
    Map<String, dynamic> json) {
  return _EnrichmentConfiguration.fromJson(json);
}

/// @nodoc
mixin _$EnrichmentConfiguration {
  bool get isSensitive => throw _privateConstructorUsedError;
  List<dynamic> get mentions => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EnrichmentConfigurationCopyWith<EnrichmentConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnrichmentConfigurationCopyWith<$Res> {
  factory $EnrichmentConfigurationCopyWith(EnrichmentConfiguration value,
          $Res Function(EnrichmentConfiguration) then) =
      _$EnrichmentConfigurationCopyWithImpl<$Res, EnrichmentConfiguration>;
  @useResult
  $Res call({bool isSensitive, List<dynamic> mentions, List<String> tags});
}

/// @nodoc
class _$EnrichmentConfigurationCopyWithImpl<$Res,
        $Val extends EnrichmentConfiguration>
    implements $EnrichmentConfigurationCopyWith<$Res> {
  _$EnrichmentConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSensitive = null,
    Object? mentions = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      isSensitive: null == isSensitive
          ? _value.isSensitive
          : isSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
      mentions: null == mentions
          ? _value.mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_EnrichmentConfigurationCopyWith<$Res>
    implements $EnrichmentConfigurationCopyWith<$Res> {
  factory _$$_EnrichmentConfigurationCopyWith(_$_EnrichmentConfiguration value,
          $Res Function(_$_EnrichmentConfiguration) then) =
      __$$_EnrichmentConfigurationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isSensitive, List<dynamic> mentions, List<String> tags});
}

/// @nodoc
class __$$_EnrichmentConfigurationCopyWithImpl<$Res>
    extends _$EnrichmentConfigurationCopyWithImpl<$Res,
        _$_EnrichmentConfiguration>
    implements _$$_EnrichmentConfigurationCopyWith<$Res> {
  __$$_EnrichmentConfigurationCopyWithImpl(_$_EnrichmentConfiguration _value,
      $Res Function(_$_EnrichmentConfiguration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSensitive = null,
    Object? mentions = null,
    Object? tags = null,
  }) {
    return _then(_$_EnrichmentConfiguration(
      isSensitive: null == isSensitive
          ? _value.isSensitive
          : isSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
      mentions: null == mentions
          ? _value._mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_EnrichmentConfiguration implements _EnrichmentConfiguration {
  _$_EnrichmentConfiguration(
      {this.isSensitive = false,
      final List<dynamic> mentions = const [],
      final List<String> tags = const []})
      : _mentions = mentions,
        _tags = tags;

  factory _$_EnrichmentConfiguration.fromJson(Map<String, dynamic> json) =>
      _$$_EnrichmentConfigurationFromJson(json);

  @override
  @JsonKey()
  final bool isSensitive;
  final List<dynamic> _mentions;
  @override
  @JsonKey()
  List<dynamic> get mentions {
    if (_mentions is EqualUnmodifiableListView) return _mentions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mentions);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'EnrichmentConfiguration(isSensitive: $isSensitive, mentions: $mentions, tags: $tags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EnrichmentConfiguration &&
            (identical(other.isSensitive, isSensitive) ||
                other.isSensitive == isSensitive) &&
            const DeepCollectionEquality().equals(other._mentions, _mentions) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isSensitive,
      const DeepCollectionEquality().hash(_mentions),
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EnrichmentConfigurationCopyWith<_$_EnrichmentConfiguration>
      get copyWith =>
          __$$_EnrichmentConfigurationCopyWithImpl<_$_EnrichmentConfiguration>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EnrichmentConfigurationToJson(
      this,
    );
  }
}

abstract class _EnrichmentConfiguration implements EnrichmentConfiguration {
  factory _EnrichmentConfiguration(
      {final bool isSensitive,
      final List<dynamic> mentions,
      final List<String> tags}) = _$_EnrichmentConfiguration;

  factory _EnrichmentConfiguration.fromJson(Map<String, dynamic> json) =
      _$_EnrichmentConfiguration.fromJson;

  @override
  bool get isSensitive;
  @override
  List<dynamic> get mentions;
  @override
  List<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$_EnrichmentConfigurationCopyWith<_$_EnrichmentConfiguration>
      get copyWith => throw _privateConstructorUsedError;
}

PublisherInformation _$PublisherInformationFromJson(Map<String, dynamic> json) {
  return _PublisherInformation.fromJson(json);
}

/// @nodoc
mixin _$PublisherInformation {
  bool get published => throw _privateConstructorUsedError;
  String get foreignKey => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PublisherInformationCopyWith<PublisherInformation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublisherInformationCopyWith<$Res> {
  factory $PublisherInformationCopyWith(PublisherInformation value,
          $Res Function(PublisherInformation) then) =
      _$PublisherInformationCopyWithImpl<$Res, PublisherInformation>;
  @useResult
  $Res call({bool published, String foreignKey});
}

/// @nodoc
class _$PublisherInformationCopyWithImpl<$Res,
        $Val extends PublisherInformation>
    implements $PublisherInformationCopyWith<$Res> {
  _$PublisherInformationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? published = null,
    Object? foreignKey = null,
  }) {
    return _then(_value.copyWith(
      published: null == published
          ? _value.published
          : published // ignore: cast_nullable_to_non_nullable
              as bool,
      foreignKey: null == foreignKey
          ? _value.foreignKey
          : foreignKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PublisherInformationCopyWith<$Res>
    implements $PublisherInformationCopyWith<$Res> {
  factory _$$_PublisherInformationCopyWith(_$_PublisherInformation value,
          $Res Function(_$_PublisherInformation) then) =
      __$$_PublisherInformationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool published, String foreignKey});
}

/// @nodoc
class __$$_PublisherInformationCopyWithImpl<$Res>
    extends _$PublisherInformationCopyWithImpl<$Res, _$_PublisherInformation>
    implements _$$_PublisherInformationCopyWith<$Res> {
  __$$_PublisherInformationCopyWithImpl(_$_PublisherInformation _value,
      $Res Function(_$_PublisherInformation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? published = null,
    Object? foreignKey = null,
  }) {
    return _then(_$_PublisherInformation(
      published: null == published
          ? _value.published
          : published // ignore: cast_nullable_to_non_nullable
              as bool,
      foreignKey: null == foreignKey
          ? _value.foreignKey
          : foreignKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PublisherInformation implements _PublisherInformation {
  _$_PublisherInformation({this.published = true, this.foreignKey = ''});

  factory _$_PublisherInformation.fromJson(Map<String, dynamic> json) =>
      _$$_PublisherInformationFromJson(json);

  @override
  @JsonKey()
  final bool published;
  @override
  @JsonKey()
  final String foreignKey;

  @override
  String toString() {
    return 'PublisherInformation(published: $published, foreignKey: $foreignKey)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PublisherInformation &&
            (identical(other.published, published) ||
                other.published == published) &&
            (identical(other.foreignKey, foreignKey) ||
                other.foreignKey == foreignKey));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, published, foreignKey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PublisherInformationCopyWith<_$_PublisherInformation> get copyWith =>
      __$$_PublisherInformationCopyWithImpl<_$_PublisherInformation>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PublisherInformationToJson(
      this,
    );
  }
}

abstract class _PublisherInformation implements PublisherInformation {
  factory _PublisherInformation(
      {final bool published,
      final String foreignKey}) = _$_PublisherInformation;

  factory _PublisherInformation.fromJson(Map<String, dynamic> json) =
      _$_PublisherInformation.fromJson;

  @override
  bool get published;
  @override
  String get foreignKey;
  @override
  @JsonKey(ignore: true)
  _$$_PublisherInformationCopyWith<_$_PublisherInformation> get copyWith =>
      throw _privateConstructorUsedError;
}

GeneralConfiguration _$GeneralConfigurationFromJson(Map<String, dynamic> json) {
  return _GeneralConfiguration.fromJson(json);
}

/// @nodoc
mixin _$GeneralConfiguration {
  String get style => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GeneralConfigurationCopyWith<GeneralConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneralConfigurationCopyWith<$Res> {
  factory $GeneralConfigurationCopyWith(GeneralConfiguration value,
          $Res Function(GeneralConfiguration) then) =
      _$GeneralConfigurationCopyWithImpl<$Res, GeneralConfiguration>;
  @useResult
  $Res call({String style, String type, String content});
}

/// @nodoc
class _$GeneralConfigurationCopyWithImpl<$Res,
        $Val extends GeneralConfiguration>
    implements $GeneralConfigurationCopyWith<$Res> {
  _$GeneralConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? style = null,
    Object? type = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GeneralConfigurationCopyWith<$Res>
    implements $GeneralConfigurationCopyWith<$Res> {
  factory _$$_GeneralConfigurationCopyWith(_$_GeneralConfiguration value,
          $Res Function(_$_GeneralConfiguration) then) =
      __$$_GeneralConfigurationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String style, String type, String content});
}

/// @nodoc
class __$$_GeneralConfigurationCopyWithImpl<$Res>
    extends _$GeneralConfigurationCopyWithImpl<$Res, _$_GeneralConfiguration>
    implements _$$_GeneralConfigurationCopyWith<$Res> {
  __$$_GeneralConfigurationCopyWithImpl(_$_GeneralConfiguration _value,
      $Res Function(_$_GeneralConfiguration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? style = null,
    Object? type = null,
    Object? content = null,
  }) {
    return _then(_$_GeneralConfiguration(
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GeneralConfiguration implements _GeneralConfiguration {
  _$_GeneralConfiguration({this.style = '', this.type = '', this.content = ''});

  factory _$_GeneralConfiguration.fromJson(Map<String, dynamic> json) =>
      _$$_GeneralConfigurationFromJson(json);

  @override
  @JsonKey()
  final String style;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String content;

  @override
  String toString() {
    return 'GeneralConfiguration(style: $style, type: $type, content: $content)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GeneralConfiguration &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, style, type, content);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GeneralConfigurationCopyWith<_$_GeneralConfiguration> get copyWith =>
      __$$_GeneralConfigurationCopyWithImpl<_$_GeneralConfiguration>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GeneralConfigurationToJson(
      this,
    );
  }
}

abstract class _GeneralConfiguration implements GeneralConfiguration {
  factory _GeneralConfiguration(
      {final String style,
      final String type,
      final String content}) = _$_GeneralConfiguration;

  factory _GeneralConfiguration.fromJson(Map<String, dynamic> json) =
      _$_GeneralConfiguration.fromJson;

  @override
  String get style;
  @override
  String get type;
  @override
  String get content;
  @override
  @JsonKey(ignore: true)
  _$$_GeneralConfigurationCopyWith<_$_GeneralConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

Media _$MediaFromJson(Map<String, dynamic> json) {
  return _Media.fromJson(json);
}

/// @nodoc
mixin _$Media {
  String get type => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MediaCopyWith<Media> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaCopyWith<$Res> {
  factory $MediaCopyWith(Media value, $Res Function(Media) then) =
      _$MediaCopyWithImpl<$Res, Media>;
  @useResult
  $Res call({String type, int priority, String url});
}

/// @nodoc
class _$MediaCopyWithImpl<$Res, $Val extends Media>
    implements $MediaCopyWith<$Res> {
  _$MediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? priority = null,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MediaCopyWith<$Res> implements $MediaCopyWith<$Res> {
  factory _$$_MediaCopyWith(_$_Media value, $Res Function(_$_Media) then) =
      __$$_MediaCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, int priority, String url});
}

/// @nodoc
class __$$_MediaCopyWithImpl<$Res> extends _$MediaCopyWithImpl<$Res, _$_Media>
    implements _$$_MediaCopyWith<$Res> {
  __$$_MediaCopyWithImpl(_$_Media _value, $Res Function(_$_Media) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? priority = null,
    Object? url = null,
  }) {
    return _then(_$_Media(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Media implements _Media {
  _$_Media({this.type = '', this.priority = 1000, this.url = ''});

  factory _$_Media.fromJson(Map<String, dynamic> json) =>
      _$$_MediaFromJson(json);

  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final int priority;
  @override
  @JsonKey()
  final String url;

  @override
  String toString() {
    return 'Media(type: $type, priority: $priority, url: $url)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Media &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, priority, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MediaCopyWith<_$_Media> get copyWith =>
      __$$_MediaCopyWithImpl<_$_Media>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MediaToJson(
      this,
    );
  }
}

abstract class _Media implements Media {
  factory _Media({final String type, final int priority, final String url}) =
      _$_Media;

  factory _Media.fromJson(Map<String, dynamic> json) = _$_Media.fromJson;

  @override
  String get type;
  @override
  int get priority;
  @override
  String get url;
  @override
  @JsonKey(ignore: true)
  _$$_MediaCopyWith<_$_Media> get copyWith =>
      throw _privateConstructorUsedError;
}

EventConfiguration _$EventConfigurationFromJson(Map<String, dynamic> json) {
  return _EventConfiguration.fromJson(json);
}

/// @nodoc
mixin _$EventConfiguration {
  int get popularityScore => throw _privateConstructorUsedError;
  String get venue => throw _privateConstructorUsedError;
  Schedule? get schedule => throw _privateConstructorUsedError;
  bool get isCancelled => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventConfigurationCopyWith<EventConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventConfigurationCopyWith<$Res> {
  factory $EventConfigurationCopyWith(
          EventConfiguration value, $Res Function(EventConfiguration) then) =
      _$EventConfigurationCopyWithImpl<$Res, EventConfiguration>;
  @useResult
  $Res call(
      {int popularityScore,
      String venue,
      Schedule? schedule,
      bool isCancelled,
      String name,
      String location});

  $ScheduleCopyWith<$Res>? get schedule;
}

/// @nodoc
class _$EventConfigurationCopyWithImpl<$Res, $Val extends EventConfiguration>
    implements $EventConfigurationCopyWith<$Res> {
  _$EventConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? popularityScore = null,
    Object? venue = null,
    Object? schedule = freezed,
    Object? isCancelled = null,
    Object? name = null,
    Object? location = null,
  }) {
    return _then(_value.copyWith(
      popularityScore: null == popularityScore
          ? _value.popularityScore
          : popularityScore // ignore: cast_nullable_to_non_nullable
              as int,
      venue: null == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String,
      schedule: freezed == schedule
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as Schedule?,
      isCancelled: null == isCancelled
          ? _value.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ScheduleCopyWith<$Res>? get schedule {
    if (_value.schedule == null) {
      return null;
    }

    return $ScheduleCopyWith<$Res>(_value.schedule!, (value) {
      return _then(_value.copyWith(schedule: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_EventConfigurationCopyWith<$Res>
    implements $EventConfigurationCopyWith<$Res> {
  factory _$$_EventConfigurationCopyWith(_$_EventConfiguration value,
          $Res Function(_$_EventConfiguration) then) =
      __$$_EventConfigurationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int popularityScore,
      String venue,
      Schedule? schedule,
      bool isCancelled,
      String name,
      String location});

  @override
  $ScheduleCopyWith<$Res>? get schedule;
}

/// @nodoc
class __$$_EventConfigurationCopyWithImpl<$Res>
    extends _$EventConfigurationCopyWithImpl<$Res, _$_EventConfiguration>
    implements _$$_EventConfigurationCopyWith<$Res> {
  __$$_EventConfigurationCopyWithImpl(
      _$_EventConfiguration _value, $Res Function(_$_EventConfiguration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? popularityScore = null,
    Object? venue = null,
    Object? schedule = freezed,
    Object? isCancelled = null,
    Object? name = null,
    Object? location = null,
  }) {
    return _then(_$_EventConfiguration(
      popularityScore: null == popularityScore
          ? _value.popularityScore
          : popularityScore // ignore: cast_nullable_to_non_nullable
              as int,
      venue: null == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String,
      schedule: freezed == schedule
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as Schedule?,
      isCancelled: null == isCancelled
          ? _value.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_EventConfiguration implements _EventConfiguration {
  _$_EventConfiguration(
      {this.popularityScore = 0,
      this.venue = '',
      this.schedule,
      this.isCancelled = false,
      this.name = '',
      this.location = ''});

  factory _$_EventConfiguration.fromJson(Map<String, dynamic> json) =>
      _$$_EventConfigurationFromJson(json);

  @override
  @JsonKey()
  final int popularityScore;
  @override
  @JsonKey()
  final String venue;
  @override
  final Schedule? schedule;
  @override
  @JsonKey()
  final bool isCancelled;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String location;

  @override
  String toString() {
    return 'EventConfiguration(popularityScore: $popularityScore, venue: $venue, schedule: $schedule, isCancelled: $isCancelled, name: $name, location: $location)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EventConfiguration &&
            (identical(other.popularityScore, popularityScore) ||
                other.popularityScore == popularityScore) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            (identical(other.isCancelled, isCancelled) ||
                other.isCancelled == isCancelled) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, popularityScore, venue, schedule,
      isCancelled, name, location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EventConfigurationCopyWith<_$_EventConfiguration> get copyWith =>
      __$$_EventConfigurationCopyWithImpl<_$_EventConfiguration>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EventConfigurationToJson(
      this,
    );
  }
}

abstract class _EventConfiguration implements EventConfiguration {
  factory _EventConfiguration(
      {final int popularityScore,
      final String venue,
      final Schedule? schedule,
      final bool isCancelled,
      final String name,
      final String location}) = _$_EventConfiguration;

  factory _EventConfiguration.fromJson(Map<String, dynamic> json) =
      _$_EventConfiguration.fromJson;

  @override
  int get popularityScore;
  @override
  String get venue;
  @override
  Schedule? get schedule;
  @override
  bool get isCancelled;
  @override
  String get name;
  @override
  String get location;
  @override
  @JsonKey(ignore: true)
  _$$_EventConfigurationCopyWith<_$_EventConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

Schedule _$ScheduleFromJson(Map<String, dynamic> json) {
  return _Schedule.fromJson(json);
}

/// @nodoc
mixin _$Schedule {
  String get reoccuranceRule => throw _privateConstructorUsedError;
  Map<String, dynamic> get endDate => throw _privateConstructorUsedError;
  Map<String, dynamic> get startDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScheduleCopyWith<Schedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleCopyWith<$Res> {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) then) =
      _$ScheduleCopyWithImpl<$Res, Schedule>;
  @useResult
  $Res call(
      {String reoccuranceRule,
      Map<String, dynamic> endDate,
      Map<String, dynamic> startDate});
}

/// @nodoc
class _$ScheduleCopyWithImpl<$Res, $Val extends Schedule>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reoccuranceRule = null,
    Object? endDate = null,
    Object? startDate = null,
  }) {
    return _then(_value.copyWith(
      reoccuranceRule: null == reoccuranceRule
          ? _value.reoccuranceRule
          : reoccuranceRule // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ScheduleCopyWith<$Res> implements $ScheduleCopyWith<$Res> {
  factory _$$_ScheduleCopyWith(
          _$_Schedule value, $Res Function(_$_Schedule) then) =
      __$$_ScheduleCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String reoccuranceRule,
      Map<String, dynamic> endDate,
      Map<String, dynamic> startDate});
}

/// @nodoc
class __$$_ScheduleCopyWithImpl<$Res>
    extends _$ScheduleCopyWithImpl<$Res, _$_Schedule>
    implements _$$_ScheduleCopyWith<$Res> {
  __$$_ScheduleCopyWithImpl(
      _$_Schedule _value, $Res Function(_$_Schedule) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reoccuranceRule = null,
    Object? endDate = null,
    Object? startDate = null,
  }) {
    return _then(_$_Schedule(
      reoccuranceRule: null == reoccuranceRule
          ? _value.reoccuranceRule
          : reoccuranceRule // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value._endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      startDate: null == startDate
          ? _value._startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Schedule implements _Schedule {
  _$_Schedule(
      {this.reoccuranceRule = '',
      final Map<String, dynamic> endDate = const {},
      final Map<String, dynamic> startDate = const {}})
      : _endDate = endDate,
        _startDate = startDate;

  factory _$_Schedule.fromJson(Map<String, dynamic> json) =>
      _$$_ScheduleFromJson(json);

  @override
  @JsonKey()
  final String reoccuranceRule;
  final Map<String, dynamic> _endDate;
  @override
  @JsonKey()
  Map<String, dynamic> get endDate {
    if (_endDate is EqualUnmodifiableMapView) return _endDate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_endDate);
  }

  final Map<String, dynamic> _startDate;
  @override
  @JsonKey()
  Map<String, dynamic> get startDate {
    if (_startDate is EqualUnmodifiableMapView) return _startDate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_startDate);
  }

  @override
  String toString() {
    return 'Schedule(reoccuranceRule: $reoccuranceRule, endDate: $endDate, startDate: $startDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Schedule &&
            (identical(other.reoccuranceRule, reoccuranceRule) ||
                other.reoccuranceRule == reoccuranceRule) &&
            const DeepCollectionEquality().equals(other._endDate, _endDate) &&
            const DeepCollectionEquality()
                .equals(other._startDate, _startDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      reoccuranceRule,
      const DeepCollectionEquality().hash(_endDate),
      const DeepCollectionEquality().hash(_startDate));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ScheduleCopyWith<_$_Schedule> get copyWith =>
      __$$_ScheduleCopyWithImpl<_$_Schedule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ScheduleToJson(
      this,
    );
  }
}

abstract class _Schedule implements Schedule {
  factory _Schedule(
      {final String reoccuranceRule,
      final Map<String, dynamic> endDate,
      final Map<String, dynamic> startDate}) = _$_Schedule;

  factory _Schedule.fromJson(Map<String, dynamic> json) = _$_Schedule.fromJson;

  @override
  String get reoccuranceRule;
  @override
  Map<String, dynamic> get endDate;
  @override
  Map<String, dynamic> get startDate;
  @override
  @JsonKey(ignore: true)
  _$$_ScheduleCopyWith<_$_Schedule> get copyWith =>
      throw _privateConstructorUsedError;
}

SecurityConfiguration _$SecurityConfigurationFromJson(
    Map<String, dynamic> json) {
  return _SecurityConfiguration.fromJson(json);
}

/// @nodoc
mixin _$SecurityConfiguration {
  String get reactionMode => throw _privateConstructorUsedError;
  String get visibilityMode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SecurityConfigurationCopyWith<SecurityConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecurityConfigurationCopyWith<$Res> {
  factory $SecurityConfigurationCopyWith(SecurityConfiguration value,
          $Res Function(SecurityConfiguration) then) =
      _$SecurityConfigurationCopyWithImpl<$Res, SecurityConfiguration>;
  @useResult
  $Res call({String reactionMode, String visibilityMode});
}

/// @nodoc
class _$SecurityConfigurationCopyWithImpl<$Res,
        $Val extends SecurityConfiguration>
    implements $SecurityConfigurationCopyWith<$Res> {
  _$SecurityConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reactionMode = null,
    Object? visibilityMode = null,
  }) {
    return _then(_value.copyWith(
      reactionMode: null == reactionMode
          ? _value.reactionMode
          : reactionMode // ignore: cast_nullable_to_non_nullable
              as String,
      visibilityMode: null == visibilityMode
          ? _value.visibilityMode
          : visibilityMode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SecurityConfigurationCopyWith<$Res>
    implements $SecurityConfigurationCopyWith<$Res> {
  factory _$$_SecurityConfigurationCopyWith(_$_SecurityConfiguration value,
          $Res Function(_$_SecurityConfiguration) then) =
      __$$_SecurityConfigurationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reactionMode, String visibilityMode});
}

/// @nodoc
class __$$_SecurityConfigurationCopyWithImpl<$Res>
    extends _$SecurityConfigurationCopyWithImpl<$Res, _$_SecurityConfiguration>
    implements _$$_SecurityConfigurationCopyWith<$Res> {
  __$$_SecurityConfigurationCopyWithImpl(_$_SecurityConfiguration _value,
      $Res Function(_$_SecurityConfiguration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reactionMode = null,
    Object? visibilityMode = null,
  }) {
    return _then(_$_SecurityConfiguration(
      reactionMode: null == reactionMode
          ? _value.reactionMode
          : reactionMode // ignore: cast_nullable_to_non_nullable
              as String,
      visibilityMode: null == visibilityMode
          ? _value.visibilityMode
          : visibilityMode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SecurityConfiguration implements _SecurityConfiguration {
  _$_SecurityConfiguration({this.reactionMode = '', this.visibilityMode = ''});

  factory _$_SecurityConfiguration.fromJson(Map<String, dynamic> json) =>
      _$$_SecurityConfigurationFromJson(json);

  @override
  @JsonKey()
  final String reactionMode;
  @override
  @JsonKey()
  final String visibilityMode;

  @override
  String toString() {
    return 'SecurityConfiguration(reactionMode: $reactionMode, visibilityMode: $visibilityMode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SecurityConfiguration &&
            (identical(other.reactionMode, reactionMode) ||
                other.reactionMode == reactionMode) &&
            (identical(other.visibilityMode, visibilityMode) ||
                other.visibilityMode == visibilityMode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, reactionMode, visibilityMode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SecurityConfigurationCopyWith<_$_SecurityConfiguration> get copyWith =>
      __$$_SecurityConfigurationCopyWithImpl<_$_SecurityConfiguration>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SecurityConfigurationToJson(
      this,
    );
  }
}

abstract class _SecurityConfiguration implements SecurityConfiguration {
  factory _SecurityConfiguration(
      {final String reactionMode,
      final String visibilityMode}) = _$_SecurityConfiguration;

  factory _SecurityConfiguration.fromJson(Map<String, dynamic> json) =
      _$_SecurityConfiguration.fromJson;

  @override
  String get reactionMode;
  @override
  String get visibilityMode;
  @override
  @JsonKey(ignore: true)
  _$$_SecurityConfigurationCopyWith<_$_SecurityConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}
