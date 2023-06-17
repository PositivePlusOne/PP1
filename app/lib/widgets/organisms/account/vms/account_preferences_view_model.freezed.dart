// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_preferences_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AccountPreferencesViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;
  Set<String> get notificationSubscribedTopics =>
      throw _privateConstructorUsedError;
  bool get isIncognitoEnabled => throw _privateConstructorUsedError;
  bool get areBiometricsEnabled => throw _privateConstructorUsedError;
  bool get areMarketingEmailsEnabled => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountPreferencesViewModelStateCopyWith<AccountPreferencesViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountPreferencesViewModelStateCopyWith<$Res> {
  factory $AccountPreferencesViewModelStateCopyWith(
          AccountPreferencesViewModelState value,
          $Res Function(AccountPreferencesViewModelState) then) =
      _$AccountPreferencesViewModelStateCopyWithImpl<$Res,
          AccountPreferencesViewModelState>;
  @useResult
  $Res call(
      {bool isBusy,
      Set<String> notificationSubscribedTopics,
      bool isIncognitoEnabled,
      bool areBiometricsEnabled,
      bool areMarketingEmailsEnabled});
}

/// @nodoc
class _$AccountPreferencesViewModelStateCopyWithImpl<$Res,
        $Val extends AccountPreferencesViewModelState>
    implements $AccountPreferencesViewModelStateCopyWith<$Res> {
  _$AccountPreferencesViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? notificationSubscribedTopics = null,
    Object? isIncognitoEnabled = null,
    Object? areBiometricsEnabled = null,
    Object? areMarketingEmailsEnabled = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationSubscribedTopics: null == notificationSubscribedTopics
          ? _value.notificationSubscribedTopics
          : notificationSubscribedTopics // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isIncognitoEnabled: null == isIncognitoEnabled
          ? _value.isIncognitoEnabled
          : isIncognitoEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      areBiometricsEnabled: null == areBiometricsEnabled
          ? _value.areBiometricsEnabled
          : areBiometricsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      areMarketingEmailsEnabled: null == areMarketingEmailsEnabled
          ? _value.areMarketingEmailsEnabled
          : areMarketingEmailsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AccountPreferencesViewModelStateCopyWith<$Res>
    implements $AccountPreferencesViewModelStateCopyWith<$Res> {
  factory _$$_AccountPreferencesViewModelStateCopyWith(
          _$_AccountPreferencesViewModelState value,
          $Res Function(_$_AccountPreferencesViewModelState) then) =
      __$$_AccountPreferencesViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isBusy,
      Set<String> notificationSubscribedTopics,
      bool isIncognitoEnabled,
      bool areBiometricsEnabled,
      bool areMarketingEmailsEnabled});
}

/// @nodoc
class __$$_AccountPreferencesViewModelStateCopyWithImpl<$Res>
    extends _$AccountPreferencesViewModelStateCopyWithImpl<$Res,
        _$_AccountPreferencesViewModelState>
    implements _$$_AccountPreferencesViewModelStateCopyWith<$Res> {
  __$$_AccountPreferencesViewModelStateCopyWithImpl(
      _$_AccountPreferencesViewModelState _value,
      $Res Function(_$_AccountPreferencesViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? notificationSubscribedTopics = null,
    Object? isIncognitoEnabled = null,
    Object? areBiometricsEnabled = null,
    Object? areMarketingEmailsEnabled = null,
  }) {
    return _then(_$_AccountPreferencesViewModelState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationSubscribedTopics: null == notificationSubscribedTopics
          ? _value._notificationSubscribedTopics
          : notificationSubscribedTopics // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isIncognitoEnabled: null == isIncognitoEnabled
          ? _value.isIncognitoEnabled
          : isIncognitoEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      areBiometricsEnabled: null == areBiometricsEnabled
          ? _value.areBiometricsEnabled
          : areBiometricsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      areMarketingEmailsEnabled: null == areMarketingEmailsEnabled
          ? _value.areMarketingEmailsEnabled
          : areMarketingEmailsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_AccountPreferencesViewModelState
    implements _AccountPreferencesViewModelState {
  const _$_AccountPreferencesViewModelState(
      {this.isBusy = false,
      final Set<String> notificationSubscribedTopics = const {},
      this.isIncognitoEnabled = false,
      this.areBiometricsEnabled = false,
      this.areMarketingEmailsEnabled = false})
      : _notificationSubscribedTopics = notificationSubscribedTopics;

  @override
  @JsonKey()
  final bool isBusy;
  final Set<String> _notificationSubscribedTopics;
  @override
  @JsonKey()
  Set<String> get notificationSubscribedTopics {
    if (_notificationSubscribedTopics is EqualUnmodifiableSetView)
      return _notificationSubscribedTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_notificationSubscribedTopics);
  }

  @override
  @JsonKey()
  final bool isIncognitoEnabled;
  @override
  @JsonKey()
  final bool areBiometricsEnabled;
  @override
  @JsonKey()
  final bool areMarketingEmailsEnabled;

  @override
  String toString() {
    return 'AccountPreferencesViewModelState(isBusy: $isBusy, notificationSubscribedTopics: $notificationSubscribedTopics, isIncognitoEnabled: $isIncognitoEnabled, areBiometricsEnabled: $areBiometricsEnabled, areMarketingEmailsEnabled: $areMarketingEmailsEnabled)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AccountPreferencesViewModelState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            const DeepCollectionEquality().equals(
                other._notificationSubscribedTopics,
                _notificationSubscribedTopics) &&
            (identical(other.isIncognitoEnabled, isIncognitoEnabled) ||
                other.isIncognitoEnabled == isIncognitoEnabled) &&
            (identical(other.areBiometricsEnabled, areBiometricsEnabled) ||
                other.areBiometricsEnabled == areBiometricsEnabled) &&
            (identical(other.areMarketingEmailsEnabled,
                    areMarketingEmailsEnabled) ||
                other.areMarketingEmailsEnabled == areMarketingEmailsEnabled));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isBusy,
      const DeepCollectionEquality().hash(_notificationSubscribedTopics),
      isIncognitoEnabled,
      areBiometricsEnabled,
      areMarketingEmailsEnabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AccountPreferencesViewModelStateCopyWith<
          _$_AccountPreferencesViewModelState>
      get copyWith => __$$_AccountPreferencesViewModelStateCopyWithImpl<
          _$_AccountPreferencesViewModelState>(this, _$identity);
}

abstract class _AccountPreferencesViewModelState
    implements AccountPreferencesViewModelState {
  const factory _AccountPreferencesViewModelState(
          {final bool isBusy,
          final Set<String> notificationSubscribedTopics,
          final bool isIncognitoEnabled,
          final bool areBiometricsEnabled,
          final bool areMarketingEmailsEnabled}) =
      _$_AccountPreferencesViewModelState;

  @override
  bool get isBusy;
  @override
  Set<String> get notificationSubscribedTopics;
  @override
  bool get isIncognitoEnabled;
  @override
  bool get areBiometricsEnabled;
  @override
  bool get areMarketingEmailsEnabled;
  @override
  @JsonKey(ignore: true)
  _$$_AccountPreferencesViewModelStateCopyWith<
          _$_AccountPreferencesViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}
