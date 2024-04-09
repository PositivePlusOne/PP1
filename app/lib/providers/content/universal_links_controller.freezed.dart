// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'universal_links_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UniversalLinksState {
  String get expectedUniversalLinkScheme => throw _privateConstructorUsedError;
  Uri? get latestUniversalLink => throw _privateConstructorUsedError;
  bool get isUniversalLinkHandled => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UniversalLinksStateCopyWith<UniversalLinksState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UniversalLinksStateCopyWith<$Res> {
  factory $UniversalLinksStateCopyWith(
          UniversalLinksState value, $Res Function(UniversalLinksState) then) =
      _$UniversalLinksStateCopyWithImpl<$Res, UniversalLinksState>;
  @useResult
  $Res call(
      {String expectedUniversalLinkScheme,
      Uri? latestUniversalLink,
      bool isUniversalLinkHandled});
}

/// @nodoc
class _$UniversalLinksStateCopyWithImpl<$Res, $Val extends UniversalLinksState>
    implements $UniversalLinksStateCopyWith<$Res> {
  _$UniversalLinksStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expectedUniversalLinkScheme = null,
    Object? latestUniversalLink = freezed,
    Object? isUniversalLinkHandled = null,
  }) {
    return _then(_value.copyWith(
      expectedUniversalLinkScheme: null == expectedUniversalLinkScheme
          ? _value.expectedUniversalLinkScheme
          : expectedUniversalLinkScheme // ignore: cast_nullable_to_non_nullable
              as String,
      latestUniversalLink: freezed == latestUniversalLink
          ? _value.latestUniversalLink
          : latestUniversalLink // ignore: cast_nullable_to_non_nullable
              as Uri?,
      isUniversalLinkHandled: null == isUniversalLinkHandled
          ? _value.isUniversalLinkHandled
          : isUniversalLinkHandled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UniversalLinksStateImplCopyWith<$Res>
    implements $UniversalLinksStateCopyWith<$Res> {
  factory _$$UniversalLinksStateImplCopyWith(_$UniversalLinksStateImpl value,
          $Res Function(_$UniversalLinksStateImpl) then) =
      __$$UniversalLinksStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String expectedUniversalLinkScheme,
      Uri? latestUniversalLink,
      bool isUniversalLinkHandled});
}

/// @nodoc
class __$$UniversalLinksStateImplCopyWithImpl<$Res>
    extends _$UniversalLinksStateCopyWithImpl<$Res, _$UniversalLinksStateImpl>
    implements _$$UniversalLinksStateImplCopyWith<$Res> {
  __$$UniversalLinksStateImplCopyWithImpl(_$UniversalLinksStateImpl _value,
      $Res Function(_$UniversalLinksStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expectedUniversalLinkScheme = null,
    Object? latestUniversalLink = freezed,
    Object? isUniversalLinkHandled = null,
  }) {
    return _then(_$UniversalLinksStateImpl(
      expectedUniversalLinkScheme: null == expectedUniversalLinkScheme
          ? _value.expectedUniversalLinkScheme
          : expectedUniversalLinkScheme // ignore: cast_nullable_to_non_nullable
              as String,
      latestUniversalLink: freezed == latestUniversalLink
          ? _value.latestUniversalLink
          : latestUniversalLink // ignore: cast_nullable_to_non_nullable
              as Uri?,
      isUniversalLinkHandled: null == isUniversalLinkHandled
          ? _value.isUniversalLinkHandled
          : isUniversalLinkHandled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UniversalLinksStateImpl implements _UniversalLinksState {
  const _$UniversalLinksStateImpl(
      {this.expectedUniversalLinkScheme = 'pp1',
      this.latestUniversalLink,
      this.isUniversalLinkHandled = false});

  @override
  @JsonKey()
  final String expectedUniversalLinkScheme;
  @override
  final Uri? latestUniversalLink;
  @override
  @JsonKey()
  final bool isUniversalLinkHandled;

  @override
  String toString() {
    return 'UniversalLinksState(expectedUniversalLinkScheme: $expectedUniversalLinkScheme, latestUniversalLink: $latestUniversalLink, isUniversalLinkHandled: $isUniversalLinkHandled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UniversalLinksStateImpl &&
            (identical(other.expectedUniversalLinkScheme,
                    expectedUniversalLinkScheme) ||
                other.expectedUniversalLinkScheme ==
                    expectedUniversalLinkScheme) &&
            (identical(other.latestUniversalLink, latestUniversalLink) ||
                other.latestUniversalLink == latestUniversalLink) &&
            (identical(other.isUniversalLinkHandled, isUniversalLinkHandled) ||
                other.isUniversalLinkHandled == isUniversalLinkHandled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, expectedUniversalLinkScheme,
      latestUniversalLink, isUniversalLinkHandled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UniversalLinksStateImplCopyWith<_$UniversalLinksStateImpl> get copyWith =>
      __$$UniversalLinksStateImplCopyWithImpl<_$UniversalLinksStateImpl>(
          this, _$identity);
}

abstract class _UniversalLinksState implements UniversalLinksState {
  const factory _UniversalLinksState(
      {final String expectedUniversalLinkScheme,
      final Uri? latestUniversalLink,
      final bool isUniversalLinkHandled}) = _$UniversalLinksStateImpl;

  @override
  String get expectedUniversalLinkScheme;
  @override
  Uri? get latestUniversalLink;
  @override
  bool get isUniversalLinkHandled;
  @override
  @JsonKey(ignore: true)
  _$$UniversalLinksStateImplCopyWith<_$UniversalLinksStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
