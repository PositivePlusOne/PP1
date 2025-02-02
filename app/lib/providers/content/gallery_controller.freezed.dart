// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gallery_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GalleryControllerState {
  String? get currentProfileId => throw _privateConstructorUsedError;
  DateTime? get galleryLastUpdated => throw _privateConstructorUsedError;
  List<GalleryEntry> get galleryEntries => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GalleryControllerStateCopyWith<GalleryControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GalleryControllerStateCopyWith<$Res> {
  factory $GalleryControllerStateCopyWith(GalleryControllerState value,
          $Res Function(GalleryControllerState) then) =
      _$GalleryControllerStateCopyWithImpl<$Res, GalleryControllerState>;
  @useResult
  $Res call(
      {String? currentProfileId,
      DateTime? galleryLastUpdated,
      List<GalleryEntry> galleryEntries});
}

/// @nodoc
class _$GalleryControllerStateCopyWithImpl<$Res,
        $Val extends GalleryControllerState>
    implements $GalleryControllerStateCopyWith<$Res> {
  _$GalleryControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentProfileId = freezed,
    Object? galleryLastUpdated = freezed,
    Object? galleryEntries = null,
  }) {
    return _then(_value.copyWith(
      currentProfileId: freezed == currentProfileId
          ? _value.currentProfileId
          : currentProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      galleryLastUpdated: freezed == galleryLastUpdated
          ? _value.galleryLastUpdated
          : galleryLastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      galleryEntries: null == galleryEntries
          ? _value.galleryEntries
          : galleryEntries // ignore: cast_nullable_to_non_nullable
              as List<GalleryEntry>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GalleryControllerStateImplCopyWith<$Res>
    implements $GalleryControllerStateCopyWith<$Res> {
  factory _$$GalleryControllerStateImplCopyWith(
          _$GalleryControllerStateImpl value,
          $Res Function(_$GalleryControllerStateImpl) then) =
      __$$GalleryControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? currentProfileId,
      DateTime? galleryLastUpdated,
      List<GalleryEntry> galleryEntries});
}

/// @nodoc
class __$$GalleryControllerStateImplCopyWithImpl<$Res>
    extends _$GalleryControllerStateCopyWithImpl<$Res,
        _$GalleryControllerStateImpl>
    implements _$$GalleryControllerStateImplCopyWith<$Res> {
  __$$GalleryControllerStateImplCopyWithImpl(
      _$GalleryControllerStateImpl _value,
      $Res Function(_$GalleryControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentProfileId = freezed,
    Object? galleryLastUpdated = freezed,
    Object? galleryEntries = null,
  }) {
    return _then(_$GalleryControllerStateImpl(
      currentProfileId: freezed == currentProfileId
          ? _value.currentProfileId
          : currentProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      galleryLastUpdated: freezed == galleryLastUpdated
          ? _value.galleryLastUpdated
          : galleryLastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      galleryEntries: null == galleryEntries
          ? _value._galleryEntries
          : galleryEntries // ignore: cast_nullable_to_non_nullable
              as List<GalleryEntry>,
    ));
  }
}

/// @nodoc

class _$GalleryControllerStateImpl implements _GalleryControllerState {
  const _$GalleryControllerStateImpl(
      {this.currentProfileId,
      this.galleryLastUpdated,
      final List<GalleryEntry> galleryEntries = const []})
      : _galleryEntries = galleryEntries;

  @override
  final String? currentProfileId;
  @override
  final DateTime? galleryLastUpdated;
  final List<GalleryEntry> _galleryEntries;
  @override
  @JsonKey()
  List<GalleryEntry> get galleryEntries {
    if (_galleryEntries is EqualUnmodifiableListView) return _galleryEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_galleryEntries);
  }

  @override
  String toString() {
    return 'GalleryControllerState(currentProfileId: $currentProfileId, galleryLastUpdated: $galleryLastUpdated, galleryEntries: $galleryEntries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GalleryControllerStateImpl &&
            (identical(other.currentProfileId, currentProfileId) ||
                other.currentProfileId == currentProfileId) &&
            (identical(other.galleryLastUpdated, galleryLastUpdated) ||
                other.galleryLastUpdated == galleryLastUpdated) &&
            const DeepCollectionEquality()
                .equals(other._galleryEntries, _galleryEntries));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentProfileId,
      galleryLastUpdated, const DeepCollectionEquality().hash(_galleryEntries));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GalleryControllerStateImplCopyWith<_$GalleryControllerStateImpl>
      get copyWith => __$$GalleryControllerStateImplCopyWithImpl<
          _$GalleryControllerStateImpl>(this, _$identity);
}

abstract class _GalleryControllerState implements GalleryControllerState {
  const factory _GalleryControllerState(
      {final String? currentProfileId,
      final DateTime? galleryLastUpdated,
      final List<GalleryEntry> galleryEntries}) = _$GalleryControllerStateImpl;

  @override
  String? get currentProfileId;
  @override
  DateTime? get galleryLastUpdated;
  @override
  List<GalleryEntry> get galleryEntries;
  @override
  @JsonKey(ignore: true)
  _$$GalleryControllerStateImplCopyWith<_$GalleryControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
