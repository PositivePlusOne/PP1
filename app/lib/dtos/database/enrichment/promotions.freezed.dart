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
  String get descriptionMarkdown => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;
  String get linkText => throw _privateConstructorUsedError;
  List<PromotionOwner> get owners => throw _privateConstructorUsedError;
  List<PromotedActivity> get activities => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  String? get startTime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  String? get endTime => throw _privateConstructorUsedError;

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
      String descriptionMarkdown,
      String link,
      String linkText,
      List<PromotionOwner> owners,
      List<PromotedActivity> activities,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      String? startTime,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      String? endTime});

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
    Object? descriptionMarkdown = null,
    Object? link = null,
    Object? linkText = null,
    Object? owners = null,
    Object? activities = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
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
      descriptionMarkdown: null == descriptionMarkdown
          ? _value.descriptionMarkdown
          : descriptionMarkdown // ignore: cast_nullable_to_non_nullable
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
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$_PromotionCopyWith<$Res> implements $PromotionCopyWith<$Res> {
  factory _$$_PromotionCopyWith(
          _$_Promotion value, $Res Function(_$_Promotion) then) =
      __$$_PromotionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String title,
      String descriptionMarkdown,
      String link,
      String linkText,
      List<PromotionOwner> owners,
      List<PromotedActivity> activities,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      String? startTime,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      String? endTime});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class __$$_PromotionCopyWithImpl<$Res>
    extends _$PromotionCopyWithImpl<$Res, _$_Promotion>
    implements _$$_PromotionCopyWith<$Res> {
  __$$_PromotionCopyWithImpl(
      _$_Promotion _value, $Res Function(_$_Promotion) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? title = null,
    Object? descriptionMarkdown = null,
    Object? link = null,
    Object? linkText = null,
    Object? owners = null,
    Object? activities = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(_$_Promotion(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionMarkdown: null == descriptionMarkdown
          ? _value.descriptionMarkdown
          : descriptionMarkdown // ignore: cast_nullable_to_non_nullable
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
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Promotion implements _Promotion {
  const _$_Promotion(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      this.title = '',
      this.descriptionMarkdown = '',
      this.link = '',
      this.linkText = '',
      final List<PromotionOwner> owners = const [],
      final List<PromotedActivity> activities = const [],
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown) this.startTime,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown) this.endTime})
      : _owners = owners,
        _activities = activities;

  factory _$_Promotion.fromJson(Map<String, dynamic> json) =>
      _$$_PromotionFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String descriptionMarkdown;
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
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  final String? startTime;
  @override
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  final String? endTime;

  @override
  String toString() {
    return 'Promotion(flMeta: $flMeta, title: $title, descriptionMarkdown: $descriptionMarkdown, link: $link, linkText: $linkText, owners: $owners, activities: $activities, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Promotion &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.descriptionMarkdown, descriptionMarkdown) ||
                other.descriptionMarkdown == descriptionMarkdown) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.linkText, linkText) ||
                other.linkText == linkText) &&
            const DeepCollectionEquality().equals(other._owners, _owners) &&
            const DeepCollectionEquality()
                .equals(other._activities, _activities) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      flMeta,
      title,
      descriptionMarkdown,
      link,
      linkText,
      const DeepCollectionEquality().hash(_owners),
      const DeepCollectionEquality().hash(_activities),
      startTime,
      endTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PromotionCopyWith<_$_Promotion> get copyWith =>
      __$$_PromotionCopyWithImpl<_$_Promotion>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PromotionToJson(
      this,
    );
  }
}

abstract class _Promotion implements Promotion {
  const factory _Promotion(
      {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
      final String title,
      final String descriptionMarkdown,
      final String link,
      final String linkText,
      final List<PromotionOwner> owners,
      final List<PromotedActivity> activities,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      final String? startTime,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      final String? endTime}) = _$_Promotion;

  factory _Promotion.fromJson(Map<String, dynamic> json) =
      _$_Promotion.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  String get title;
  @override
  String get descriptionMarkdown;
  @override
  String get link;
  @override
  String get linkText;
  @override
  List<PromotionOwner> get owners;
  @override
  List<PromotedActivity> get activities;
  @override
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  String? get startTime;
  @override
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  String? get endTime;
  @override
  @JsonKey(ignore: true)
  _$$_PromotionCopyWith<_$_Promotion> get copyWith =>
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
abstract class _$$_PromotionOwnerCopyWith<$Res>
    implements $PromotionOwnerCopyWith<$Res> {
  factory _$$_PromotionOwnerCopyWith(
          _$_PromotionOwner value, $Res Function(_$_PromotionOwner) then) =
      __$$_PromotionOwnerCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String activityId});
}

/// @nodoc
class __$$_PromotionOwnerCopyWithImpl<$Res>
    extends _$PromotionOwnerCopyWithImpl<$Res, _$_PromotionOwner>
    implements _$$_PromotionOwnerCopyWith<$Res> {
  __$$_PromotionOwnerCopyWithImpl(
      _$_PromotionOwner _value, $Res Function(_$_PromotionOwner) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
  }) {
    return _then(_$_PromotionOwner(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PromotionOwner implements _PromotionOwner {
  const _$_PromotionOwner({this.activityId = ''});

  factory _$_PromotionOwner.fromJson(Map<String, dynamic> json) =>
      _$$_PromotionOwnerFromJson(json);

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
            other is _$_PromotionOwner &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, activityId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PromotionOwnerCopyWith<_$_PromotionOwner> get copyWith =>
      __$$_PromotionOwnerCopyWithImpl<_$_PromotionOwner>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PromotionOwnerToJson(
      this,
    );
  }
}

abstract class _PromotionOwner implements PromotionOwner {
  const factory _PromotionOwner({final String activityId}) = _$_PromotionOwner;

  factory _PromotionOwner.fromJson(Map<String, dynamic> json) =
      _$_PromotionOwner.fromJson;

  @override
  String get activityId;
  @override
  @JsonKey(ignore: true)
  _$$_PromotionOwnerCopyWith<_$_PromotionOwner> get copyWith =>
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
abstract class _$$_PromotedActivityCopyWith<$Res>
    implements $PromotedActivityCopyWith<$Res> {
  factory _$$_PromotedActivityCopyWith(
          _$_PromotedActivity value, $Res Function(_$_PromotedActivity) then) =
      __$$_PromotedActivityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String activityId});
}

/// @nodoc
class __$$_PromotedActivityCopyWithImpl<$Res>
    extends _$PromotedActivityCopyWithImpl<$Res, _$_PromotedActivity>
    implements _$$_PromotedActivityCopyWith<$Res> {
  __$$_PromotedActivityCopyWithImpl(
      _$_PromotedActivity _value, $Res Function(_$_PromotedActivity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
  }) {
    return _then(_$_PromotedActivity(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PromotedActivity implements _PromotedActivity {
  const _$_PromotedActivity({this.activityId = ''});

  factory _$_PromotedActivity.fromJson(Map<String, dynamic> json) =>
      _$$_PromotedActivityFromJson(json);

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
            other is _$_PromotedActivity &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, activityId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PromotedActivityCopyWith<_$_PromotedActivity> get copyWith =>
      __$$_PromotedActivityCopyWithImpl<_$_PromotedActivity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PromotedActivityToJson(
      this,
    );
  }
}

abstract class _PromotedActivity implements PromotedActivity {
  const factory _PromotedActivity({final String activityId}) =
      _$_PromotedActivity;

  factory _PromotedActivity.fromJson(Map<String, dynamic> json) =
      _$_PromotedActivity.fromJson;

  @override
  String get activityId;
  @override
  @JsonKey(ignore: true)
  _$$_PromotedActivityCopyWith<_$_PromotedActivity> get copyWith =>
      throw _privateConstructorUsedError;
}
