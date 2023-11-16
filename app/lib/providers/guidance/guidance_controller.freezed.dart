// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guidance_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GuidanceControllerState {
  bool get isBusy => throw _privateConstructorUsedError;
  GuidanceSection? get guidanceSection => throw _privateConstructorUsedError;
  dynamic get guidanceDirectorySearchTerm => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GuidanceControllerStateCopyWith<GuidanceControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuidanceControllerStateCopyWith<$Res> {
  factory $GuidanceControllerStateCopyWith(GuidanceControllerState value,
          $Res Function(GuidanceControllerState) then) =
      _$GuidanceControllerStateCopyWithImpl<$Res, GuidanceControllerState>;
  @useResult
  $Res call(
      {bool isBusy,
      GuidanceSection? guidanceSection,
      dynamic guidanceDirectorySearchTerm});
}

/// @nodoc
class _$GuidanceControllerStateCopyWithImpl<$Res,
        $Val extends GuidanceControllerState>
    implements $GuidanceControllerStateCopyWith<$Res> {
  _$GuidanceControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? guidanceSection = freezed,
    Object? guidanceDirectorySearchTerm = freezed,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      guidanceSection: freezed == guidanceSection
          ? _value.guidanceSection
          : guidanceSection // ignore: cast_nullable_to_non_nullable
              as GuidanceSection?,
      guidanceDirectorySearchTerm: freezed == guidanceDirectorySearchTerm
          ? _value.guidanceDirectorySearchTerm
          : guidanceDirectorySearchTerm // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GuidanceControllerStateImplCopyWith<$Res>
    implements $GuidanceControllerStateCopyWith<$Res> {
  factory _$$GuidanceControllerStateImplCopyWith(
          _$GuidanceControllerStateImpl value,
          $Res Function(_$GuidanceControllerStateImpl) then) =
      __$$GuidanceControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isBusy,
      GuidanceSection? guidanceSection,
      dynamic guidanceDirectorySearchTerm});
}

/// @nodoc
class __$$GuidanceControllerStateImplCopyWithImpl<$Res>
    extends _$GuidanceControllerStateCopyWithImpl<$Res,
        _$GuidanceControllerStateImpl>
    implements _$$GuidanceControllerStateImplCopyWith<$Res> {
  __$$GuidanceControllerStateImplCopyWithImpl(
      _$GuidanceControllerStateImpl _value,
      $Res Function(_$GuidanceControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? guidanceSection = freezed,
    Object? guidanceDirectorySearchTerm = freezed,
  }) {
    return _then(_$GuidanceControllerStateImpl(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      guidanceSection: freezed == guidanceSection
          ? _value.guidanceSection
          : guidanceSection // ignore: cast_nullable_to_non_nullable
              as GuidanceSection?,
      guidanceDirectorySearchTerm: freezed == guidanceDirectorySearchTerm
          ? _value.guidanceDirectorySearchTerm!
          : guidanceDirectorySearchTerm,
    ));
  }
}

/// @nodoc

class _$GuidanceControllerStateImpl implements _GuidanceControllerState {
  const _$GuidanceControllerStateImpl(
      {this.isBusy = false,
      this.guidanceSection = null,
      this.guidanceDirectorySearchTerm = ''});

  @override
  @JsonKey()
  final bool isBusy;
  @override
  @JsonKey()
  final GuidanceSection? guidanceSection;
  @override
  @JsonKey()
  final dynamic guidanceDirectorySearchTerm;

  @override
  String toString() {
    return 'GuidanceControllerState(isBusy: $isBusy, guidanceSection: $guidanceSection, guidanceDirectorySearchTerm: $guidanceDirectorySearchTerm)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuidanceControllerStateImpl &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.guidanceSection, guidanceSection) ||
                other.guidanceSection == guidanceSection) &&
            const DeepCollectionEquality().equals(
                other.guidanceDirectorySearchTerm,
                guidanceDirectorySearchTerm));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy, guidanceSection,
      const DeepCollectionEquality().hash(guidanceDirectorySearchTerm));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GuidanceControllerStateImplCopyWith<_$GuidanceControllerStateImpl>
      get copyWith => __$$GuidanceControllerStateImplCopyWithImpl<
          _$GuidanceControllerStateImpl>(this, _$identity);
}

abstract class _GuidanceControllerState implements GuidanceControllerState {
  const factory _GuidanceControllerState(
          {final bool isBusy,
          final GuidanceSection? guidanceSection,
          final dynamic guidanceDirectorySearchTerm}) =
      _$GuidanceControllerStateImpl;

  @override
  bool get isBusy;
  @override
  GuidanceSection? get guidanceSection;
  @override
  dynamic get guidanceDirectorySearchTerm;
  @override
  @JsonKey(ignore: true)
  _$$GuidanceControllerStateImplCopyWith<_$GuidanceControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
