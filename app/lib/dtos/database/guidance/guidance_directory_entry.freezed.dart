// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guidance_directory_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GuidanceDirectoryEntry _$GuidanceDirectoryEntryFromJson(
    Map<String, dynamic> json) {
  return _GuidanceDirectoryEntry.fromJson(json);
}

/// @nodoc
mixin _$GuidanceDirectoryEntry {
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get markdown => throw _privateConstructorUsedError;
  PositivePlace? get place => throw _privateConstructorUsedError;
  String get websiteUrl => throw _privateConstructorUsedError;
  String get logoUrl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
  DocumentReference<Object?>? get profile => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: GuidanceDirectoryEntryService.listFromJson,
      toJson: GuidanceDirectoryEntryService.listToJson)
  List<GuidanceDirectoryEntryService> get services =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GuidanceDirectoryEntryCopyWith<GuidanceDirectoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuidanceDirectoryEntryCopyWith<$Res> {
  factory $GuidanceDirectoryEntryCopyWith(GuidanceDirectoryEntry value,
          $Res Function(GuidanceDirectoryEntry) then) =
      _$GuidanceDirectoryEntryCopyWithImpl<$Res, GuidanceDirectoryEntry>;
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String title,
      String description,
      String markdown,
      PositivePlace? place,
      String websiteUrl,
      String logoUrl,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      DocumentReference<Object?>? profile,
      @JsonKey(
          fromJson: GuidanceDirectoryEntryService.listFromJson,
          toJson: GuidanceDirectoryEntryService.listToJson)
      List<GuidanceDirectoryEntryService> services});

  $FlMetaCopyWith<$Res>? get flMeta;
  $PositivePlaceCopyWith<$Res>? get place;
}

/// @nodoc
class _$GuidanceDirectoryEntryCopyWithImpl<$Res,
        $Val extends GuidanceDirectoryEntry>
    implements $GuidanceDirectoryEntryCopyWith<$Res> {
  _$GuidanceDirectoryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? title = null,
    Object? description = null,
    Object? markdown = null,
    Object? place = freezed,
    Object? websiteUrl = null,
    Object? logoUrl = null,
    Object? profile = freezed,
    Object? services = null,
  }) {
    return _then(_value.copyWith(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      markdown: null == markdown
          ? _value.markdown
          : markdown // ignore: cast_nullable_to_non_nullable
              as String,
      place: freezed == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as PositivePlace?,
      websiteUrl: null == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: null == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
      services: null == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<GuidanceDirectoryEntryService>,
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
  $PositivePlaceCopyWith<$Res>? get place {
    if (_value.place == null) {
      return null;
    }

    return $PositivePlaceCopyWith<$Res>(_value.place!, (value) {
      return _then(_value.copyWith(place: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_GuidanceDirectoryEntryCopyWith<$Res>
    implements $GuidanceDirectoryEntryCopyWith<$Res> {
  factory _$$_GuidanceDirectoryEntryCopyWith(_$_GuidanceDirectoryEntry value,
          $Res Function(_$_GuidanceDirectoryEntry) then) =
      __$$_GuidanceDirectoryEntryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String title,
      String description,
      String markdown,
      PositivePlace? place,
      String websiteUrl,
      String logoUrl,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      DocumentReference<Object?>? profile,
      @JsonKey(
          fromJson: GuidanceDirectoryEntryService.listFromJson,
          toJson: GuidanceDirectoryEntryService.listToJson)
      List<GuidanceDirectoryEntryService> services});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
  @override
  $PositivePlaceCopyWith<$Res>? get place;
}

/// @nodoc
class __$$_GuidanceDirectoryEntryCopyWithImpl<$Res>
    extends _$GuidanceDirectoryEntryCopyWithImpl<$Res,
        _$_GuidanceDirectoryEntry>
    implements _$$_GuidanceDirectoryEntryCopyWith<$Res> {
  __$$_GuidanceDirectoryEntryCopyWithImpl(_$_GuidanceDirectoryEntry _value,
      $Res Function(_$_GuidanceDirectoryEntry) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? title = null,
    Object? description = null,
    Object? markdown = null,
    Object? place = freezed,
    Object? websiteUrl = null,
    Object? logoUrl = null,
    Object? profile = freezed,
    Object? services = null,
  }) {
    return _then(_$_GuidanceDirectoryEntry(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      markdown: null == markdown
          ? _value.markdown
          : markdown // ignore: cast_nullable_to_non_nullable
              as String,
      place: freezed == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as PositivePlace?,
      websiteUrl: null == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: null == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
      services: null == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<GuidanceDirectoryEntryService>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GuidanceDirectoryEntry implements _GuidanceDirectoryEntry {
  const _$_GuidanceDirectoryEntry(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      this.title = '',
      this.description = '',
      this.markdown = '',
      this.place,
      this.websiteUrl = '',
      this.logoUrl = '',
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      this.profile,
      @JsonKey(
          fromJson: GuidanceDirectoryEntryService.listFromJson,
          toJson: GuidanceDirectoryEntryService.listToJson)
      final List<GuidanceDirectoryEntryService> services = const []})
      : _services = services;

  factory _$_GuidanceDirectoryEntry.fromJson(Map<String, dynamic> json) =>
      _$$_GuidanceDirectoryEntryFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String markdown;
  @override
  final PositivePlace? place;
  @override
  @JsonKey()
  final String websiteUrl;
  @override
  @JsonKey()
  final String logoUrl;
  @override
  @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
  final DocumentReference<Object?>? profile;
  final List<GuidanceDirectoryEntryService> _services;
  @override
  @JsonKey(
      fromJson: GuidanceDirectoryEntryService.listFromJson,
      toJson: GuidanceDirectoryEntryService.listToJson)
  List<GuidanceDirectoryEntryService> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  @override
  String toString() {
    return 'GuidanceDirectoryEntry(flMeta: $flMeta, title: $title, description: $description, markdown: $markdown, place: $place, websiteUrl: $websiteUrl, logoUrl: $logoUrl, profile: $profile, services: $services)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuidanceDirectoryEntry &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.markdown, markdown) ||
                other.markdown == markdown) &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.websiteUrl, websiteUrl) ||
                other.websiteUrl == websiteUrl) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            const DeepCollectionEquality().equals(other._services, _services));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      flMeta,
      title,
      description,
      markdown,
      place,
      websiteUrl,
      logoUrl,
      profile,
      const DeepCollectionEquality().hash(_services));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GuidanceDirectoryEntryCopyWith<_$_GuidanceDirectoryEntry> get copyWith =>
      __$$_GuidanceDirectoryEntryCopyWithImpl<_$_GuidanceDirectoryEntry>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GuidanceDirectoryEntryToJson(
      this,
    );
  }
}

abstract class _GuidanceDirectoryEntry implements GuidanceDirectoryEntry {
  const factory _GuidanceDirectoryEntry(
          {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
          final String title,
          final String description,
          final String markdown,
          final PositivePlace? place,
          final String websiteUrl,
          final String logoUrl,
          @JsonKey(
              fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
          final DocumentReference<Object?>? profile,
          @JsonKey(
              fromJson: GuidanceDirectoryEntryService.listFromJson,
              toJson: GuidanceDirectoryEntryService.listToJson)
          final List<GuidanceDirectoryEntryService> services}) =
      _$_GuidanceDirectoryEntry;

  factory _GuidanceDirectoryEntry.fromJson(Map<String, dynamic> json) =
      _$_GuidanceDirectoryEntry.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  String get title;
  @override
  String get description;
  @override
  String get markdown;
  @override
  PositivePlace? get place;
  @override
  String get websiteUrl;
  @override
  String get logoUrl;
  @override
  @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
  DocumentReference<Object?>? get profile;
  @override
  @JsonKey(
      fromJson: GuidanceDirectoryEntryService.listFromJson,
      toJson: GuidanceDirectoryEntryService.listToJson)
  List<GuidanceDirectoryEntryService> get services;
  @override
  @JsonKey(ignore: true)
  _$$_GuidanceDirectoryEntryCopyWith<_$_GuidanceDirectoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GuidanceDirectoryEntryService {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() hivSupport,
    required TResult Function() counselling,
    required TResult Function() financialAdvice,
    required TResult Function() testing,
    required TResult Function() sexualHealth,
    required TResult Function() unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? hivSupport,
    TResult? Function()? counselling,
    TResult? Function()? financialAdvice,
    TResult? Function()? testing,
    TResult? Function()? sexualHealth,
    TResult? Function()? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? hivSupport,
    TResult Function()? counselling,
    TResult Function()? financialAdvice,
    TResult Function()? testing,
    TResult Function()? sexualHealth,
    TResult Function()? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)
        hivSupport,
    required TResult Function(_GuidanceDirectoryEntryServiceCounselling value)
        counselling,
    required TResult Function(
            _GuidanceDirectoryEntryServiceFinancialAdvice value)
        financialAdvice,
    required TResult Function(_GuidanceDirectoryEntryServiceTesting value)
        testing,
    required TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)
        sexualHealth,
    required TResult Function(_GuidanceDirectoryEntryServiceUnknown value)
        unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult? Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult? Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult? Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult? Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult? Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuidanceDirectoryEntryServiceCopyWith<$Res> {
  factory $GuidanceDirectoryEntryServiceCopyWith(
          GuidanceDirectoryEntryService value,
          $Res Function(GuidanceDirectoryEntryService) then) =
      _$GuidanceDirectoryEntryServiceCopyWithImpl<$Res,
          GuidanceDirectoryEntryService>;
}

/// @nodoc
class _$GuidanceDirectoryEntryServiceCopyWithImpl<$Res,
        $Val extends GuidanceDirectoryEntryService>
    implements $GuidanceDirectoryEntryServiceCopyWith<$Res> {
  _$GuidanceDirectoryEntryServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_GuidanceDirectoryEntryServiceHivSupportCopyWith<$Res> {
  factory _$$_GuidanceDirectoryEntryServiceHivSupportCopyWith(
          _$_GuidanceDirectoryEntryServiceHivSupport value,
          $Res Function(_$_GuidanceDirectoryEntryServiceHivSupport) then) =
      __$$_GuidanceDirectoryEntryServiceHivSupportCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_GuidanceDirectoryEntryServiceHivSupportCopyWithImpl<$Res>
    extends _$GuidanceDirectoryEntryServiceCopyWithImpl<$Res,
        _$_GuidanceDirectoryEntryServiceHivSupport>
    implements _$$_GuidanceDirectoryEntryServiceHivSupportCopyWith<$Res> {
  __$$_GuidanceDirectoryEntryServiceHivSupportCopyWithImpl(
      _$_GuidanceDirectoryEntryServiceHivSupport _value,
      $Res Function(_$_GuidanceDirectoryEntryServiceHivSupport) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_GuidanceDirectoryEntryServiceHivSupport
    implements _GuidanceDirectoryEntryServiceHivSupport {
  const _$_GuidanceDirectoryEntryServiceHivSupport();

  @override
  String toString() {
    return 'GuidanceDirectoryEntryService.hivSupport()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuidanceDirectoryEntryServiceHivSupport);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() hivSupport,
    required TResult Function() counselling,
    required TResult Function() financialAdvice,
    required TResult Function() testing,
    required TResult Function() sexualHealth,
    required TResult Function() unknown,
  }) {
    return hivSupport();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? hivSupport,
    TResult? Function()? counselling,
    TResult? Function()? financialAdvice,
    TResult? Function()? testing,
    TResult? Function()? sexualHealth,
    TResult? Function()? unknown,
  }) {
    return hivSupport?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? hivSupport,
    TResult Function()? counselling,
    TResult Function()? financialAdvice,
    TResult Function()? testing,
    TResult Function()? sexualHealth,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (hivSupport != null) {
      return hivSupport();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)
        hivSupport,
    required TResult Function(_GuidanceDirectoryEntryServiceCounselling value)
        counselling,
    required TResult Function(
            _GuidanceDirectoryEntryServiceFinancialAdvice value)
        financialAdvice,
    required TResult Function(_GuidanceDirectoryEntryServiceTesting value)
        testing,
    required TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)
        sexualHealth,
    required TResult Function(_GuidanceDirectoryEntryServiceUnknown value)
        unknown,
  }) {
    return hivSupport(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult? Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult? Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult? Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult? Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult? Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
  }) {
    return hivSupport?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (hivSupport != null) {
      return hivSupport(this);
    }
    return orElse();
  }
}

abstract class _GuidanceDirectoryEntryServiceHivSupport
    implements GuidanceDirectoryEntryService {
  const factory _GuidanceDirectoryEntryServiceHivSupport() =
      _$_GuidanceDirectoryEntryServiceHivSupport;
}

/// @nodoc
abstract class _$$_GuidanceDirectoryEntryServiceCounsellingCopyWith<$Res> {
  factory _$$_GuidanceDirectoryEntryServiceCounsellingCopyWith(
          _$_GuidanceDirectoryEntryServiceCounselling value,
          $Res Function(_$_GuidanceDirectoryEntryServiceCounselling) then) =
      __$$_GuidanceDirectoryEntryServiceCounsellingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_GuidanceDirectoryEntryServiceCounsellingCopyWithImpl<$Res>
    extends _$GuidanceDirectoryEntryServiceCopyWithImpl<$Res,
        _$_GuidanceDirectoryEntryServiceCounselling>
    implements _$$_GuidanceDirectoryEntryServiceCounsellingCopyWith<$Res> {
  __$$_GuidanceDirectoryEntryServiceCounsellingCopyWithImpl(
      _$_GuidanceDirectoryEntryServiceCounselling _value,
      $Res Function(_$_GuidanceDirectoryEntryServiceCounselling) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_GuidanceDirectoryEntryServiceCounselling
    implements _GuidanceDirectoryEntryServiceCounselling {
  const _$_GuidanceDirectoryEntryServiceCounselling();

  @override
  String toString() {
    return 'GuidanceDirectoryEntryService.counselling()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuidanceDirectoryEntryServiceCounselling);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() hivSupport,
    required TResult Function() counselling,
    required TResult Function() financialAdvice,
    required TResult Function() testing,
    required TResult Function() sexualHealth,
    required TResult Function() unknown,
  }) {
    return counselling();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? hivSupport,
    TResult? Function()? counselling,
    TResult? Function()? financialAdvice,
    TResult? Function()? testing,
    TResult? Function()? sexualHealth,
    TResult? Function()? unknown,
  }) {
    return counselling?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? hivSupport,
    TResult Function()? counselling,
    TResult Function()? financialAdvice,
    TResult Function()? testing,
    TResult Function()? sexualHealth,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (counselling != null) {
      return counselling();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)
        hivSupport,
    required TResult Function(_GuidanceDirectoryEntryServiceCounselling value)
        counselling,
    required TResult Function(
            _GuidanceDirectoryEntryServiceFinancialAdvice value)
        financialAdvice,
    required TResult Function(_GuidanceDirectoryEntryServiceTesting value)
        testing,
    required TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)
        sexualHealth,
    required TResult Function(_GuidanceDirectoryEntryServiceUnknown value)
        unknown,
  }) {
    return counselling(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult? Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult? Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult? Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult? Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult? Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
  }) {
    return counselling?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (counselling != null) {
      return counselling(this);
    }
    return orElse();
  }
}

abstract class _GuidanceDirectoryEntryServiceCounselling
    implements GuidanceDirectoryEntryService {
  const factory _GuidanceDirectoryEntryServiceCounselling() =
      _$_GuidanceDirectoryEntryServiceCounselling;
}

/// @nodoc
abstract class _$$_GuidanceDirectoryEntryServiceFinancialAdviceCopyWith<$Res> {
  factory _$$_GuidanceDirectoryEntryServiceFinancialAdviceCopyWith(
          _$_GuidanceDirectoryEntryServiceFinancialAdvice value,
          $Res Function(_$_GuidanceDirectoryEntryServiceFinancialAdvice) then) =
      __$$_GuidanceDirectoryEntryServiceFinancialAdviceCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_GuidanceDirectoryEntryServiceFinancialAdviceCopyWithImpl<$Res>
    extends _$GuidanceDirectoryEntryServiceCopyWithImpl<$Res,
        _$_GuidanceDirectoryEntryServiceFinancialAdvice>
    implements _$$_GuidanceDirectoryEntryServiceFinancialAdviceCopyWith<$Res> {
  __$$_GuidanceDirectoryEntryServiceFinancialAdviceCopyWithImpl(
      _$_GuidanceDirectoryEntryServiceFinancialAdvice _value,
      $Res Function(_$_GuidanceDirectoryEntryServiceFinancialAdvice) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_GuidanceDirectoryEntryServiceFinancialAdvice
    implements _GuidanceDirectoryEntryServiceFinancialAdvice {
  const _$_GuidanceDirectoryEntryServiceFinancialAdvice();

  @override
  String toString() {
    return 'GuidanceDirectoryEntryService.financialAdvice()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuidanceDirectoryEntryServiceFinancialAdvice);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() hivSupport,
    required TResult Function() counselling,
    required TResult Function() financialAdvice,
    required TResult Function() testing,
    required TResult Function() sexualHealth,
    required TResult Function() unknown,
  }) {
    return financialAdvice();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? hivSupport,
    TResult? Function()? counselling,
    TResult? Function()? financialAdvice,
    TResult? Function()? testing,
    TResult? Function()? sexualHealth,
    TResult? Function()? unknown,
  }) {
    return financialAdvice?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? hivSupport,
    TResult Function()? counselling,
    TResult Function()? financialAdvice,
    TResult Function()? testing,
    TResult Function()? sexualHealth,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (financialAdvice != null) {
      return financialAdvice();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)
        hivSupport,
    required TResult Function(_GuidanceDirectoryEntryServiceCounselling value)
        counselling,
    required TResult Function(
            _GuidanceDirectoryEntryServiceFinancialAdvice value)
        financialAdvice,
    required TResult Function(_GuidanceDirectoryEntryServiceTesting value)
        testing,
    required TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)
        sexualHealth,
    required TResult Function(_GuidanceDirectoryEntryServiceUnknown value)
        unknown,
  }) {
    return financialAdvice(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult? Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult? Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult? Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult? Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult? Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
  }) {
    return financialAdvice?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (financialAdvice != null) {
      return financialAdvice(this);
    }
    return orElse();
  }
}

abstract class _GuidanceDirectoryEntryServiceFinancialAdvice
    implements GuidanceDirectoryEntryService {
  const factory _GuidanceDirectoryEntryServiceFinancialAdvice() =
      _$_GuidanceDirectoryEntryServiceFinancialAdvice;
}

/// @nodoc
abstract class _$$_GuidanceDirectoryEntryServiceTestingCopyWith<$Res> {
  factory _$$_GuidanceDirectoryEntryServiceTestingCopyWith(
          _$_GuidanceDirectoryEntryServiceTesting value,
          $Res Function(_$_GuidanceDirectoryEntryServiceTesting) then) =
      __$$_GuidanceDirectoryEntryServiceTestingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_GuidanceDirectoryEntryServiceTestingCopyWithImpl<$Res>
    extends _$GuidanceDirectoryEntryServiceCopyWithImpl<$Res,
        _$_GuidanceDirectoryEntryServiceTesting>
    implements _$$_GuidanceDirectoryEntryServiceTestingCopyWith<$Res> {
  __$$_GuidanceDirectoryEntryServiceTestingCopyWithImpl(
      _$_GuidanceDirectoryEntryServiceTesting _value,
      $Res Function(_$_GuidanceDirectoryEntryServiceTesting) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_GuidanceDirectoryEntryServiceTesting
    implements _GuidanceDirectoryEntryServiceTesting {
  const _$_GuidanceDirectoryEntryServiceTesting();

  @override
  String toString() {
    return 'GuidanceDirectoryEntryService.testing()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuidanceDirectoryEntryServiceTesting);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() hivSupport,
    required TResult Function() counselling,
    required TResult Function() financialAdvice,
    required TResult Function() testing,
    required TResult Function() sexualHealth,
    required TResult Function() unknown,
  }) {
    return testing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? hivSupport,
    TResult? Function()? counselling,
    TResult? Function()? financialAdvice,
    TResult? Function()? testing,
    TResult? Function()? sexualHealth,
    TResult? Function()? unknown,
  }) {
    return testing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? hivSupport,
    TResult Function()? counselling,
    TResult Function()? financialAdvice,
    TResult Function()? testing,
    TResult Function()? sexualHealth,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (testing != null) {
      return testing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)
        hivSupport,
    required TResult Function(_GuidanceDirectoryEntryServiceCounselling value)
        counselling,
    required TResult Function(
            _GuidanceDirectoryEntryServiceFinancialAdvice value)
        financialAdvice,
    required TResult Function(_GuidanceDirectoryEntryServiceTesting value)
        testing,
    required TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)
        sexualHealth,
    required TResult Function(_GuidanceDirectoryEntryServiceUnknown value)
        unknown,
  }) {
    return testing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult? Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult? Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult? Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult? Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult? Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
  }) {
    return testing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (testing != null) {
      return testing(this);
    }
    return orElse();
  }
}

abstract class _GuidanceDirectoryEntryServiceTesting
    implements GuidanceDirectoryEntryService {
  const factory _GuidanceDirectoryEntryServiceTesting() =
      _$_GuidanceDirectoryEntryServiceTesting;
}

/// @nodoc
abstract class _$$_GuidanceDirectoryEntryServiceSexualHealthCopyWith<$Res> {
  factory _$$_GuidanceDirectoryEntryServiceSexualHealthCopyWith(
          _$_GuidanceDirectoryEntryServiceSexualHealth value,
          $Res Function(_$_GuidanceDirectoryEntryServiceSexualHealth) then) =
      __$$_GuidanceDirectoryEntryServiceSexualHealthCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_GuidanceDirectoryEntryServiceSexualHealthCopyWithImpl<$Res>
    extends _$GuidanceDirectoryEntryServiceCopyWithImpl<$Res,
        _$_GuidanceDirectoryEntryServiceSexualHealth>
    implements _$$_GuidanceDirectoryEntryServiceSexualHealthCopyWith<$Res> {
  __$$_GuidanceDirectoryEntryServiceSexualHealthCopyWithImpl(
      _$_GuidanceDirectoryEntryServiceSexualHealth _value,
      $Res Function(_$_GuidanceDirectoryEntryServiceSexualHealth) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_GuidanceDirectoryEntryServiceSexualHealth
    implements _GuidanceDirectoryEntryServiceSexualHealth {
  const _$_GuidanceDirectoryEntryServiceSexualHealth();

  @override
  String toString() {
    return 'GuidanceDirectoryEntryService.sexualHealth()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuidanceDirectoryEntryServiceSexualHealth);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() hivSupport,
    required TResult Function() counselling,
    required TResult Function() financialAdvice,
    required TResult Function() testing,
    required TResult Function() sexualHealth,
    required TResult Function() unknown,
  }) {
    return sexualHealth();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? hivSupport,
    TResult? Function()? counselling,
    TResult? Function()? financialAdvice,
    TResult? Function()? testing,
    TResult? Function()? sexualHealth,
    TResult? Function()? unknown,
  }) {
    return sexualHealth?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? hivSupport,
    TResult Function()? counselling,
    TResult Function()? financialAdvice,
    TResult Function()? testing,
    TResult Function()? sexualHealth,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (sexualHealth != null) {
      return sexualHealth();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)
        hivSupport,
    required TResult Function(_GuidanceDirectoryEntryServiceCounselling value)
        counselling,
    required TResult Function(
            _GuidanceDirectoryEntryServiceFinancialAdvice value)
        financialAdvice,
    required TResult Function(_GuidanceDirectoryEntryServiceTesting value)
        testing,
    required TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)
        sexualHealth,
    required TResult Function(_GuidanceDirectoryEntryServiceUnknown value)
        unknown,
  }) {
    return sexualHealth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult? Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult? Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult? Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult? Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult? Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
  }) {
    return sexualHealth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (sexualHealth != null) {
      return sexualHealth(this);
    }
    return orElse();
  }
}

abstract class _GuidanceDirectoryEntryServiceSexualHealth
    implements GuidanceDirectoryEntryService {
  const factory _GuidanceDirectoryEntryServiceSexualHealth() =
      _$_GuidanceDirectoryEntryServiceSexualHealth;
}

/// @nodoc
abstract class _$$_GuidanceDirectoryEntryServiceUnknownCopyWith<$Res> {
  factory _$$_GuidanceDirectoryEntryServiceUnknownCopyWith(
          _$_GuidanceDirectoryEntryServiceUnknown value,
          $Res Function(_$_GuidanceDirectoryEntryServiceUnknown) then) =
      __$$_GuidanceDirectoryEntryServiceUnknownCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_GuidanceDirectoryEntryServiceUnknownCopyWithImpl<$Res>
    extends _$GuidanceDirectoryEntryServiceCopyWithImpl<$Res,
        _$_GuidanceDirectoryEntryServiceUnknown>
    implements _$$_GuidanceDirectoryEntryServiceUnknownCopyWith<$Res> {
  __$$_GuidanceDirectoryEntryServiceUnknownCopyWithImpl(
      _$_GuidanceDirectoryEntryServiceUnknown _value,
      $Res Function(_$_GuidanceDirectoryEntryServiceUnknown) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_GuidanceDirectoryEntryServiceUnknown
    implements _GuidanceDirectoryEntryServiceUnknown {
  const _$_GuidanceDirectoryEntryServiceUnknown();

  @override
  String toString() {
    return 'GuidanceDirectoryEntryService.unknown()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuidanceDirectoryEntryServiceUnknown);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() hivSupport,
    required TResult Function() counselling,
    required TResult Function() financialAdvice,
    required TResult Function() testing,
    required TResult Function() sexualHealth,
    required TResult Function() unknown,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? hivSupport,
    TResult? Function()? counselling,
    TResult? Function()? financialAdvice,
    TResult? Function()? testing,
    TResult? Function()? sexualHealth,
    TResult? Function()? unknown,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? hivSupport,
    TResult Function()? counselling,
    TResult Function()? financialAdvice,
    TResult Function()? testing,
    TResult Function()? sexualHealth,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)
        hivSupport,
    required TResult Function(_GuidanceDirectoryEntryServiceCounselling value)
        counselling,
    required TResult Function(
            _GuidanceDirectoryEntryServiceFinancialAdvice value)
        financialAdvice,
    required TResult Function(_GuidanceDirectoryEntryServiceTesting value)
        testing,
    required TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)
        sexualHealth,
    required TResult Function(_GuidanceDirectoryEntryServiceUnknown value)
        unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult? Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult? Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult? Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult? Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult? Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GuidanceDirectoryEntryServiceHivSupport value)?
        hivSupport,
    TResult Function(_GuidanceDirectoryEntryServiceCounselling value)?
        counselling,
    TResult Function(_GuidanceDirectoryEntryServiceFinancialAdvice value)?
        financialAdvice,
    TResult Function(_GuidanceDirectoryEntryServiceTesting value)? testing,
    TResult Function(_GuidanceDirectoryEntryServiceSexualHealth value)?
        sexualHealth,
    TResult Function(_GuidanceDirectoryEntryServiceUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class _GuidanceDirectoryEntryServiceUnknown
    implements GuidanceDirectoryEntryService {
  const factory _GuidanceDirectoryEntryServiceUnknown() =
      _$_GuidanceDirectoryEntryServiceUnknown;
}
