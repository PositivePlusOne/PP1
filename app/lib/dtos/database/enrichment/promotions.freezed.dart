// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promotions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Promotion _$PromotionFromJson(Map<String, dynamic> json) {
  return _Promotion.fromJson(json);
}

/// @nodoc
mixin _$Promotion {
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;
  String get linkText => throw _privateConstructorUsedError;
  List<PromotionOwner> get owners => throw _privateConstructorUsedError;
  List<PromotedActivity> get activities => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get totalViewsSinceLastUpdate => throw _privateConstructorUsedError;
  int get totalViewsAllotment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PromotionCopyWith<Promotion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromotionCopyWith<$Res> {
  factory $PromotionCopyWith(Promotion value, $Res Function(Promotion) then) =
      _$PromotionCopyWithImpl<$Res, Promotion>;
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String title,
      String link,
      String linkText,
      List<PromotionOwner> owners,
      List<PromotedActivity> activities,
      bool isActive,
      int totalViewsSinceLastUpdate,
      int totalViewsAllotment});

  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class _$PromotionCopyWithImpl<$Res, $Val extends Promotion>
    implements $PromotionCopyWith<$Res> {
  _$PromotionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? title = null,
    Object? link = null,
    Object? linkText = null,
    Object? owners = null,
    Object? activities = null,
    Object? isActive = null,
    Object? totalViewsSinceLastUpdate = null,
    Object? totalViewsAllotment = null,
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
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      linkText: null == linkText
          ? _value.linkText
          : linkText // ignore: cast_nullable_to_non_nullable
              as String,
      owners: null == owners
          ? _value.owners
          : owners // ignore: cast_nullable_to_non_nullable
              as List<PromotionOwner>,
      activities: null == activities
          ? _value.activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<PromotedActivity>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      totalViewsSinceLastUpdate: null == totalViewsSinceLastUpdate
          ? _value.totalViewsSinceLastUpdate
          : totalViewsSinceLastUpdate // ignore: cast_nullable_to_non_nullable
              as int,
      totalViewsAllotment: null == totalViewsAllotment
          ? _value.totalViewsAllotment
          : totalViewsAllotment // ignore: cast_nullable_to_non_nullable
              as int,
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
}

/// @nodoc
abstract class _$$PromotionImplCopyWith<$Res>
    implements $PromotionCopyWith<$Res> {
  factory _$$PromotionImplCopyWith(
          _$PromotionImpl value, $Res Function(_$PromotionImpl) then) =
      __$$PromotionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String title,
      String link,
      String linkText,
      List<PromotionOwner> owners,
      List<PromotedActivity> activities,
      bool isActive,
      int totalViewsSinceLastUpdate,
      int totalViewsAllotment});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class __$$PromotionImplCopyWithImpl<$Res>
    extends _$PromotionCopyWithImpl<$Res, _$PromotionImpl>
    implements _$$PromotionImplCopyWith<$Res> {
  __$$PromotionImplCopyWithImpl(
      _$PromotionImpl _value, $Res Function(_$PromotionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? title = null,
    Object? link = null,
    Object? linkText = null,
    Object? owners = null,
    Object? activities = null,
    Object? isActive = null,
    Object? totalViewsSinceLastUpdate = null,
    Object? totalViewsAllotment = null,
  }) {
    return _then(_$PromotionImpl(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      linkText: null == linkText
          ? _value.linkText
          : linkText // ignore: cast_nullable_to_non_nullable
              as String,
      owners: null == owners
          ? _value._owners
          : owners // ignore: cast_nullable_to_non_nullable
              as List<PromotionOwner>,
      activities: null == activities
          ? _value._activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<PromotedActivity>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      totalViewsSinceLastUpdate: null == totalViewsSinceLastUpdate
          ? _value.totalViewsSinceLastUpdate
          : totalViewsSinceLastUpdate // ignore: cast_nullable_to_non_nullable
              as int,
      totalViewsAllotment: null == totalViewsAllotment
          ? _value.totalViewsAllotment
          : totalViewsAllotment // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PromotionImpl implements _Promotion {
  const _$PromotionImpl(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      this.title = '',
      this.link = '',
      this.linkText = '',
      final List<PromotionOwner> owners = const [],
      final List<PromotedActivity> activities = const [],
      this.isActive = false,
      this.totalViewsSinceLastUpdate = 0,
      this.totalViewsAllotment = 0})
      : _owners = owners,
        _activities = activities;

  factory _$PromotionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromotionImplFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String link;
  @override
  @JsonKey()
  final String linkText;
  final List<PromotionOwner> _owners;
  @override
  @JsonKey()
  List<PromotionOwner> get owners {
    if (_owners is EqualUnmodifiableListView) return _owners;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_owners);
  }

  final List<PromotedActivity> _activities;
  @override
  @JsonKey()
  List<PromotedActivity> get activities {
    if (_activities is EqualUnmodifiableListView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activities);
  }

  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int totalViewsSinceLastUpdate;
  @override
  @JsonKey()
  final int totalViewsAllotment;

  @override
  String toString() {
    return 'Promotion(flMeta: $flMeta, title: $title, link: $link, linkText: $linkText, owners: $owners, activities: $activities, isActive: $isActive, totalViewsSinceLastUpdate: $totalViewsSinceLastUpdate, totalViewsAllotment: $totalViewsAllotment)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromotionImpl &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.linkText, linkText) ||
                other.linkText == linkText) &&
            const DeepCollectionEquality().equals(other._owners, _owners) &&
            const DeepCollectionEquality()
                .equals(other._activities, _activities) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.totalViewsSinceLastUpdate,
                    totalViewsSinceLastUpdate) ||
                other.totalViewsSinceLastUpdate == totalViewsSinceLastUpdate) &&
            (identical(other.totalViewsAllotment, totalViewsAllotment) ||
                other.totalViewsAllotment == totalViewsAllotment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      flMeta,
      title,
      link,
      linkText,
      const DeepCollectionEquality().hash(_owners),
      const DeepCollectionEquality().hash(_activities),
      isActive,
      totalViewsSinceLastUpdate,
      totalViewsAllotment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PromotionImplCopyWith<_$PromotionImpl> get copyWith =>
      __$$PromotionImplCopyWithImpl<_$PromotionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromotionImplToJson(
      this,
    );
  }
}

abstract class _Promotion implements Promotion {
  const factory _Promotion(
      {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
      final String title,
      final String link,
      final String linkText,
      final List<PromotionOwner> owners,
      final List<PromotedActivity> activities,
      final bool isActive,
      final int totalViewsSinceLastUpdate,
      final int totalViewsAllotment}) = _$PromotionImpl;

  factory _Promotion.fromJson(Map<String, dynamic> json) =
      _$PromotionImpl.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  String get title;
  @override
  String get link;
  @override
  String get linkText;
  @override
  List<PromotionOwner> get owners;
  @override
  List<PromotedActivity> get activities;
  @override
  bool get isActive;
  @override
  int get totalViewsSinceLastUpdate;
  @override
  int get totalViewsAllotment;
  @override
  @JsonKey(ignore: true)
  _$$PromotionImplCopyWith<_$PromotionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PromotionOwner _$PromotionOwnerFromJson(Map<String, dynamic> json) {
  return _PromotionOwner.fromJson(json);
}

/// @nodoc
mixin _$PromotionOwner {
  String get activityId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PromotionOwnerCopyWith<PromotionOwner> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromotionOwnerCopyWith<$Res> {
  factory $PromotionOwnerCopyWith(
          PromotionOwner value, $Res Function(PromotionOwner) then) =
      _$PromotionOwnerCopyWithImpl<$Res, PromotionOwner>;
  @useResult
  $Res call({String activityId});
}

/// @nodoc
class _$PromotionOwnerCopyWithImpl<$Res, $Val extends PromotionOwner>
    implements $PromotionOwnerCopyWith<$Res> {
  _$PromotionOwnerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
  }) {
    return _then(_value.copyWith(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PromotionOwnerImplCopyWith<$Res>
    implements $PromotionOwnerCopyWith<$Res> {
  factory _$$PromotionOwnerImplCopyWith(_$PromotionOwnerImpl value,
          $Res Function(_$PromotionOwnerImpl) then) =
      __$$PromotionOwnerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String activityId});
}

/// @nodoc
class __$$PromotionOwnerImplCopyWithImpl<$Res>
    extends _$PromotionOwnerCopyWithImpl<$Res, _$PromotionOwnerImpl>
    implements _$$PromotionOwnerImplCopyWith<$Res> {
  __$$PromotionOwnerImplCopyWithImpl(
      _$PromotionOwnerImpl _value, $Res Function(_$PromotionOwnerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
  }) {
    return _then(_$PromotionOwnerImpl(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PromotionOwnerImpl implements _PromotionOwner {
  const _$PromotionOwnerImpl({this.activityId = ''});

  factory _$PromotionOwnerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromotionOwnerImplFromJson(json);

  @override
  @JsonKey()
  final String activityId;

  @override
  String toString() {
    return 'PromotionOwner(activityId: $activityId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromotionOwnerImpl &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, activityId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PromotionOwnerImplCopyWith<_$PromotionOwnerImpl> get copyWith =>
      __$$PromotionOwnerImplCopyWithImpl<_$PromotionOwnerImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromotionOwnerImplToJson(
      this,
    );
  }
}

abstract class _PromotionOwner implements PromotionOwner {
  const factory _PromotionOwner({final String activityId}) =
      _$PromotionOwnerImpl;

  factory _PromotionOwner.fromJson(Map<String, dynamic> json) =
      _$PromotionOwnerImpl.fromJson;

  @override
  String get activityId;
  @override
  @JsonKey(ignore: true)
  _$$PromotionOwnerImplCopyWith<_$PromotionOwnerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PromotedActivity _$PromotedActivityFromJson(Map<String, dynamic> json) {
  return _PromotedActivity.fromJson(json);
}

/// @nodoc
mixin _$PromotedActivity {
  String get activityId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PromotedActivityCopyWith<PromotedActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromotedActivityCopyWith<$Res> {
  factory $PromotedActivityCopyWith(
          PromotedActivity value, $Res Function(PromotedActivity) then) =
      _$PromotedActivityCopyWithImpl<$Res, PromotedActivity>;
  @useResult
  $Res call({String activityId});
}

/// @nodoc
class _$PromotedActivityCopyWithImpl<$Res, $Val extends PromotedActivity>
    implements $PromotedActivityCopyWith<$Res> {
  _$PromotedActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
  }) {
    return _then(_value.copyWith(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PromotedActivityImplCopyWith<$Res>
    implements $PromotedActivityCopyWith<$Res> {
  factory _$$PromotedActivityImplCopyWith(_$PromotedActivityImpl value,
          $Res Function(_$PromotedActivityImpl) then) =
      __$$PromotedActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String activityId});
}

/// @nodoc
class __$$PromotedActivityImplCopyWithImpl<$Res>
    extends _$PromotedActivityCopyWithImpl<$Res, _$PromotedActivityImpl>
    implements _$$PromotedActivityImplCopyWith<$Res> {
  __$$PromotedActivityImplCopyWithImpl(_$PromotedActivityImpl _value,
      $Res Function(_$PromotedActivityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
  }) {
    return _then(_$PromotedActivityImpl(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PromotedActivityImpl implements _PromotedActivity {
  const _$PromotedActivityImpl({this.activityId = ''});

  factory _$PromotedActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromotedActivityImplFromJson(json);

  @override
  @JsonKey()
  final String activityId;

  @override
  String toString() {
    return 'PromotedActivity(activityId: $activityId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromotedActivityImpl &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, activityId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PromotedActivityImplCopyWith<_$PromotedActivityImpl> get copyWith =>
      __$$PromotedActivityImplCopyWithImpl<_$PromotedActivityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromotedActivityImplToJson(
      this,
    );
  }
}

abstract class _PromotedActivity implements PromotedActivity {
  const factory _PromotedActivity({final String activityId}) =
      _$PromotedActivityImpl;

  factory _PromotedActivity.fromJson(Map<String, dynamic> json) =
      _$PromotedActivityImpl.fromJson;

  @override
  String get activityId;
  @override
  @JsonKey(ignore: true)
  _$$PromotedActivityImplCopyWith<_$PromotedActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
