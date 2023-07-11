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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GalleryControllerState {
  List<GalleryEntry> get galleryEntries => throw _privateConstructorUsedError;
  DateTime? get galleryLastUpdated => throw _privateConstructorUsedError;

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
  $Res call({List<GalleryEntry> galleryEntries, DateTime? galleryLastUpdated});
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
    Object? galleryEntries = null,
    Object? galleryLastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      galleryEntries: null == galleryEntries
          ? _value.galleryEntries
          : galleryEntries // ignore: cast_nullable_to_non_nullable
              as List<GalleryEntry>,
      galleryLastUpdated: freezed == galleryLastUpdated
          ? _value.galleryLastUpdated
          : galleryLastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GalleryControllerStateCopyWith<$Res>
    implements $GalleryControllerStateCopyWith<$Res> {
  factory _$$_GalleryControllerStateCopyWith(_$_GalleryControllerState value,
          $Res Function(_$_GalleryControllerState) then) =
      __$$_GalleryControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<GalleryEntry> galleryEntries, DateTime? galleryLastUpdated});
}

/// @nodoc
class __$$_GalleryControllerStateCopyWithImpl<$Res>
    extends _$GalleryControllerStateCopyWithImpl<$Res,
        _$_GalleryControllerState>
    implements _$$_GalleryControllerStateCopyWith<$Res> {
  __$$_GalleryControllerStateCopyWithImpl(_$_GalleryControllerState _value,
      $Res Function(_$_GalleryControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? galleryEntries = null,
    Object? galleryLastUpdated = freezed,
  }) {
    return _then(_$_GalleryControllerState(
      galleryEntries: null == galleryEntries
          ? _value._galleryEntries
          : galleryEntries // ignore: cast_nullable_to_non_nullable
              as List<GalleryEntry>,
      galleryLastUpdated: freezed == galleryLastUpdated
          ? _value.galleryLastUpdated
          : galleryLastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$_GalleryControllerState implements _GalleryControllerState {
  const _$_GalleryControllerState(
      {final List<GalleryEntry> galleryEntries = const [],
      this.galleryLastUpdated})
      : _galleryEntries = galleryEntries;

  final List<GalleryEntry> _galleryEntries;
  @override
  @JsonKey()
  List<GalleryEntry> get galleryEntries {
    if (_galleryEntries is EqualUnmodifiableListView) return _galleryEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_galleryEntries);
  }

  @override
  final DateTime? galleryLastUpdated;

  @override
  String toString() {
    return 'GalleryControllerState(galleryEntries: $galleryEntries, galleryLastUpdated: $galleryLastUpdated)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GalleryControllerState &&
            const DeepCollectionEquality()
                .equals(other._galleryEntries, _galleryEntries) &&
            (identical(other.galleryLastUpdated, galleryLastUpdated) ||
                other.galleryLastUpdated == galleryLastUpdated));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_galleryEntries), galleryLastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GalleryControllerStateCopyWith<_$_GalleryControllerState> get copyWith =>
      __$$_GalleryControllerStateCopyWithImpl<_$_GalleryControllerState>(
          this, _$identity);
}

abstract class _GalleryControllerState implements GalleryControllerState {
  const factory _GalleryControllerState(
      {final List<GalleryEntry> galleryEntries,
      final DateTime? galleryLastUpdated}) = _$_GalleryControllerState;

  @override
  List<GalleryEntry> get galleryEntries;
  @override
  DateTime? get galleryLastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$_GalleryControllerStateCopyWith<_$_GalleryControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
