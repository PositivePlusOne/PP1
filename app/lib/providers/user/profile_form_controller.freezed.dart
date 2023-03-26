// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ProfileFormState {
  String get name => throw _privateConstructorUsedError;
  Map<String, bool> get visibilityFlags => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;
  FormMode get formMode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileFormStateCopyWith<ProfileFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileFormStateCopyWith<$Res> {
  factory $ProfileFormStateCopyWith(
          ProfileFormState value, $Res Function(ProfileFormState) then) =
      _$ProfileFormStateCopyWithImpl<$Res, ProfileFormState>;
  @useResult
  $Res call(
      {String name,
      Map<String, bool> visibilityFlags,
      String displayName,
      bool isBusy,
      FormMode formMode});
}

/// @nodoc
class _$ProfileFormStateCopyWithImpl<$Res, $Val extends ProfileFormState>
    implements $ProfileFormStateCopyWith<$Res> {
  _$ProfileFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? visibilityFlags = null,
    Object? displayName = null,
    Object? isBusy = null,
    Object? formMode = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      visibilityFlags: null == visibilityFlags
          ? _value.visibilityFlags
          : visibilityFlags // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      formMode: null == formMode
          ? _value.formMode
          : formMode // ignore: cast_nullable_to_non_nullable
              as FormMode,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ProfileFormStateCopyWith<$Res>
    implements $ProfileFormStateCopyWith<$Res> {
  factory _$$_ProfileFormStateCopyWith(
          _$_ProfileFormState value, $Res Function(_$_ProfileFormState) then) =
      __$$_ProfileFormStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      Map<String, bool> visibilityFlags,
      String displayName,
      bool isBusy,
      FormMode formMode});
}

/// @nodoc
class __$$_ProfileFormStateCopyWithImpl<$Res>
    extends _$ProfileFormStateCopyWithImpl<$Res, _$_ProfileFormState>
    implements _$$_ProfileFormStateCopyWith<$Res> {
  __$$_ProfileFormStateCopyWithImpl(
      _$_ProfileFormState _value, $Res Function(_$_ProfileFormState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? visibilityFlags = null,
    Object? displayName = null,
    Object? isBusy = null,
    Object? formMode = null,
  }) {
    return _then(_$_ProfileFormState(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      visibilityFlags: null == visibilityFlags
          ? _value._visibilityFlags
          : visibilityFlags // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      formMode: null == formMode
          ? _value.formMode
          : formMode // ignore: cast_nullable_to_non_nullable
              as FormMode,
    ));
  }
}

/// @nodoc

class _$_ProfileFormState implements _ProfileFormState {
  const _$_ProfileFormState(
      {required this.name,
      required final Map<String, bool> visibilityFlags,
      required this.displayName,
      required this.isBusy,
      required this.formMode})
      : _visibilityFlags = visibilityFlags;

  @override
  final String name;
  final Map<String, bool> _visibilityFlags;
  @override
  Map<String, bool> get visibilityFlags {
    if (_visibilityFlags is EqualUnmodifiableMapView) return _visibilityFlags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_visibilityFlags);
  }

  @override
  final String displayName;
  @override
  final bool isBusy;
  @override
  final FormMode formMode;

  @override
  String toString() {
    return 'ProfileFormState(name: $name, visibilityFlags: $visibilityFlags, displayName: $displayName, isBusy: $isBusy, formMode: $formMode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileFormState &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._visibilityFlags, _visibilityFlags) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.formMode, formMode) ||
                other.formMode == formMode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      const DeepCollectionEquality().hash(_visibilityFlags),
      displayName,
      isBusy,
      formMode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileFormStateCopyWith<_$_ProfileFormState> get copyWith =>
      __$$_ProfileFormStateCopyWithImpl<_$_ProfileFormState>(this, _$identity);
}

abstract class _ProfileFormState implements ProfileFormState {
  const factory _ProfileFormState(
      {required final String name,
      required final Map<String, bool> visibilityFlags,
      required final String displayName,
      required final bool isBusy,
      required final FormMode formMode}) = _$_ProfileFormState;

  @override
  String get name;
  @override
  Map<String, bool> get visibilityFlags;
  @override
  String get displayName;
  @override
  bool get isBusy;
  @override
  FormMode get formMode;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileFormStateCopyWith<_$_ProfileFormState> get copyWith =>
      throw _privateConstructorUsedError;
}
