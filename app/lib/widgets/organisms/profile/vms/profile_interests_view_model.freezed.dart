// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_interests_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Interest {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InterestCopyWith<Interest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterestCopyWith<$Res> {
  factory $InterestCopyWith(Interest value, $Res Function(Interest) then) =
      _$InterestCopyWithImpl<$Res, Interest>;
  @useResult
  $Res call({String id, String label});
}

/// @nodoc
class _$InterestCopyWithImpl<$Res, $Val extends Interest>
    implements $InterestCopyWith<$Res> {
  _$InterestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InterestCopyWith<$Res> implements $InterestCopyWith<$Res> {
  factory _$$_InterestCopyWith(
          _$_Interest value, $Res Function(_$_Interest) then) =
      __$$_InterestCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String label});
}

/// @nodoc
class __$$_InterestCopyWithImpl<$Res>
    extends _$InterestCopyWithImpl<$Res, _$_Interest>
    implements _$$_InterestCopyWith<$Res> {
  __$$_InterestCopyWithImpl(
      _$_Interest _value, $Res Function(_$_Interest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
  }) {
    return _then(_$_Interest(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Interest implements _Interest {
  const _$_Interest({required this.id, required this.label});

  @override
  final String id;
  @override
  final String label;

  @override
  String toString() {
    return 'Interest(id: $id, label: $label)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Interest &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, label);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InterestCopyWith<_$_Interest> get copyWith =>
      __$$_InterestCopyWithImpl<_$_Interest>(this, _$identity);
}

abstract class _Interest implements Interest {
  const factory _Interest(
      {required final String id, required final String label}) = _$_Interest;

  @override
  String get id;
  @override
  String get label;
  @override
  @JsonKey(ignore: true)
  _$$_InterestCopyWith<_$_Interest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProfileInterestState {
  List<Interest> get options => throw _privateConstructorUsedError;
  List<Interest> get selectedInterests => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileInterestStateCopyWith<ProfileInterestState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileInterestStateCopyWith<$Res> {
  factory $ProfileInterestStateCopyWith(ProfileInterestState value,
          $Res Function(ProfileInterestState) then) =
      _$ProfileInterestStateCopyWithImpl<$Res, ProfileInterestState>;
  @useResult
  $Res call({List<Interest> options, List<Interest> selectedInterests});
}

/// @nodoc
class _$ProfileInterestStateCopyWithImpl<$Res,
        $Val extends ProfileInterestState>
    implements $ProfileInterestStateCopyWith<$Res> {
  _$ProfileInterestStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? options = null,
    Object? selectedInterests = null,
  }) {
    return _then(_value.copyWith(
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<Interest>,
      selectedInterests: null == selectedInterests
          ? _value.selectedInterests
          : selectedInterests // ignore: cast_nullable_to_non_nullable
              as List<Interest>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ProfileInterestStateCopyWith<$Res>
    implements $ProfileInterestStateCopyWith<$Res> {
  factory _$$_ProfileInterestStateCopyWith(_$_ProfileInterestState value,
          $Res Function(_$_ProfileInterestState) then) =
      __$$_ProfileInterestStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Interest> options, List<Interest> selectedInterests});
}

/// @nodoc
class __$$_ProfileInterestStateCopyWithImpl<$Res>
    extends _$ProfileInterestStateCopyWithImpl<$Res, _$_ProfileInterestState>
    implements _$$_ProfileInterestStateCopyWith<$Res> {
  __$$_ProfileInterestStateCopyWithImpl(_$_ProfileInterestState _value,
      $Res Function(_$_ProfileInterestState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? options = null,
    Object? selectedInterests = null,
  }) {
    return _then(_$_ProfileInterestState(
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<Interest>,
      selectedInterests: null == selectedInterests
          ? _value._selectedInterests
          : selectedInterests // ignore: cast_nullable_to_non_nullable
              as List<Interest>,
    ));
  }
}

/// @nodoc

class _$_ProfileInterestState implements _ProfileInterestState {
  const _$_ProfileInterestState(
      {final List<Interest> options = const <Interest>[],
      final List<Interest> selectedInterests = const <Interest>[]})
      : _options = options,
        _selectedInterests = selectedInterests;

  final List<Interest> _options;
  @override
  @JsonKey()
  List<Interest> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  final List<Interest> _selectedInterests;
  @override
  @JsonKey()
  List<Interest> get selectedInterests {
    if (_selectedInterests is EqualUnmodifiableListView)
      return _selectedInterests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedInterests);
  }

  @override
  String toString() {
    return 'ProfileInterestState(options: $options, selectedInterests: $selectedInterests)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileInterestState &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            const DeepCollectionEquality()
                .equals(other._selectedInterests, _selectedInterests));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_options),
      const DeepCollectionEquality().hash(_selectedInterests));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileInterestStateCopyWith<_$_ProfileInterestState> get copyWith =>
      __$$_ProfileInterestStateCopyWithImpl<_$_ProfileInterestState>(
          this, _$identity);
}

abstract class _ProfileInterestState implements ProfileInterestState {
  const factory _ProfileInterestState(
      {final List<Interest> options,
      final List<Interest> selectedInterests}) = _$_ProfileInterestState;

  @override
  List<Interest> get options;
  @override
  List<Interest> get selectedInterests;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileInterestStateCopyWith<_$_ProfileInterestState> get copyWith =>
      throw _privateConstructorUsedError;
}
