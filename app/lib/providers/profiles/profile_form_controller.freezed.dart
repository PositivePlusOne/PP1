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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileFormState {
  String get name => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get birthday => throw _privateConstructorUsedError;
  Set<String> get interests => throw _privateConstructorUsedError;
  Set<String> get genders => throw _privateConstructorUsedError;
  Set<String> get companySectors => throw _privateConstructorUsedError;
  String? get hivStatus => throw _privateConstructorUsedError;
  String? get hivStatusCategory => throw _privateConstructorUsedError;
  String get biography => throw _privateConstructorUsedError;
  String get accentColor => throw _privateConstructorUsedError;
  bool get isFocused => throw _privateConstructorUsedError;
  String get locationSearchQuery => throw _privateConstructorUsedError;
  bool get hasFailedLocationSearch => throw _privateConstructorUsedError;
  PositivePlace? get place => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;
  FormMode get formMode => throw _privateConstructorUsedError;
  Map<String, bool> get visibilityFlags => throw _privateConstructorUsedError;
  XFile? get newProfileImage => throw _privateConstructorUsedError;

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
      String displayName,
      String birthday,
      Set<String> interests,
      Set<String> genders,
      Set<String> companySectors,
      String? hivStatus,
      String? hivStatusCategory,
      String biography,
      String accentColor,
      bool isFocused,
      String locationSearchQuery,
      bool hasFailedLocationSearch,
      PositivePlace? place,
      bool isBusy,
      FormMode formMode,
      Map<String, bool> visibilityFlags,
      XFile? newProfileImage});

  $PositivePlaceCopyWith<$Res>? get place;
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
    Object? displayName = null,
    Object? birthday = null,
    Object? interests = null,
    Object? genders = null,
    Object? companySectors = null,
    Object? hivStatus = freezed,
    Object? hivStatusCategory = freezed,
    Object? biography = null,
    Object? accentColor = null,
    Object? isFocused = null,
    Object? locationSearchQuery = null,
    Object? hasFailedLocationSearch = null,
    Object? place = freezed,
    Object? isBusy = null,
    Object? formMode = null,
    Object? visibilityFlags = null,
    Object? newProfileImage = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      birthday: null == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as String,
      interests: null == interests
          ? _value.interests
          : interests // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      genders: null == genders
          ? _value.genders
          : genders // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      companySectors: null == companySectors
          ? _value.companySectors
          : companySectors // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      hivStatus: freezed == hivStatus
          ? _value.hivStatus
          : hivStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      hivStatusCategory: freezed == hivStatusCategory
          ? _value.hivStatusCategory
          : hivStatusCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      biography: null == biography
          ? _value.biography
          : biography // ignore: cast_nullable_to_non_nullable
              as String,
      accentColor: null == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as String,
      isFocused: null == isFocused
          ? _value.isFocused
          : isFocused // ignore: cast_nullable_to_non_nullable
              as bool,
      locationSearchQuery: null == locationSearchQuery
          ? _value.locationSearchQuery
          : locationSearchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      hasFailedLocationSearch: null == hasFailedLocationSearch
          ? _value.hasFailedLocationSearch
          : hasFailedLocationSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      place: freezed == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as PositivePlace?,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      formMode: null == formMode
          ? _value.formMode
          : formMode // ignore: cast_nullable_to_non_nullable
              as FormMode,
      visibilityFlags: null == visibilityFlags
          ? _value.visibilityFlags
          : visibilityFlags // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      newProfileImage: freezed == newProfileImage
          ? _value.newProfileImage
          : newProfileImage // ignore: cast_nullable_to_non_nullable
              as XFile?,
    ) as $Val);
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
abstract class _$$ProfileFormStateImplCopyWith<$Res>
    implements $ProfileFormStateCopyWith<$Res> {
  factory _$$ProfileFormStateImplCopyWith(_$ProfileFormStateImpl value,
          $Res Function(_$ProfileFormStateImpl) then) =
      __$$ProfileFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String displayName,
      String birthday,
      Set<String> interests,
      Set<String> genders,
      Set<String> companySectors,
      String? hivStatus,
      String? hivStatusCategory,
      String biography,
      String accentColor,
      bool isFocused,
      String locationSearchQuery,
      bool hasFailedLocationSearch,
      PositivePlace? place,
      bool isBusy,
      FormMode formMode,
      Map<String, bool> visibilityFlags,
      XFile? newProfileImage});

  @override
  $PositivePlaceCopyWith<$Res>? get place;
}

/// @nodoc
class __$$ProfileFormStateImplCopyWithImpl<$Res>
    extends _$ProfileFormStateCopyWithImpl<$Res, _$ProfileFormStateImpl>
    implements _$$ProfileFormStateImplCopyWith<$Res> {
  __$$ProfileFormStateImplCopyWithImpl(_$ProfileFormStateImpl _value,
      $Res Function(_$ProfileFormStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? displayName = null,
    Object? birthday = null,
    Object? interests = null,
    Object? genders = null,
    Object? companySectors = null,
    Object? hivStatus = freezed,
    Object? hivStatusCategory = freezed,
    Object? biography = null,
    Object? accentColor = null,
    Object? isFocused = null,
    Object? locationSearchQuery = null,
    Object? hasFailedLocationSearch = null,
    Object? place = freezed,
    Object? isBusy = null,
    Object? formMode = null,
    Object? visibilityFlags = null,
    Object? newProfileImage = freezed,
  }) {
    return _then(_$ProfileFormStateImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      birthday: null == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as String,
      interests: null == interests
          ? _value._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      genders: null == genders
          ? _value._genders
          : genders // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      companySectors: null == companySectors
          ? _value._companySectors
          : companySectors // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      hivStatus: freezed == hivStatus
          ? _value.hivStatus
          : hivStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      hivStatusCategory: freezed == hivStatusCategory
          ? _value.hivStatusCategory
          : hivStatusCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      biography: null == biography
          ? _value.biography
          : biography // ignore: cast_nullable_to_non_nullable
              as String,
      accentColor: null == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as String,
      isFocused: null == isFocused
          ? _value.isFocused
          : isFocused // ignore: cast_nullable_to_non_nullable
              as bool,
      locationSearchQuery: null == locationSearchQuery
          ? _value.locationSearchQuery
          : locationSearchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      hasFailedLocationSearch: null == hasFailedLocationSearch
          ? _value.hasFailedLocationSearch
          : hasFailedLocationSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      place: freezed == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as PositivePlace?,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      formMode: null == formMode
          ? _value.formMode
          : formMode // ignore: cast_nullable_to_non_nullable
              as FormMode,
      visibilityFlags: null == visibilityFlags
          ? _value._visibilityFlags
          : visibilityFlags // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      newProfileImage: freezed == newProfileImage
          ? _value.newProfileImage
          : newProfileImage // ignore: cast_nullable_to_non_nullable
              as XFile?,
    ));
  }
}

/// @nodoc

class _$ProfileFormStateImpl implements _ProfileFormState {
  const _$ProfileFormStateImpl(
      {required this.name,
      required this.displayName,
      required this.birthday,
      required final Set<String> interests,
      required final Set<String> genders,
      required final Set<String> companySectors,
      this.hivStatus,
      this.hivStatusCategory,
      required this.biography,
      required this.accentColor,
      this.isFocused = false,
      this.locationSearchQuery = '',
      this.hasFailedLocationSearch = false,
      this.place,
      required this.isBusy,
      required this.formMode,
      required final Map<String, bool> visibilityFlags,
      required this.newProfileImage})
      : _interests = interests,
        _genders = genders,
        _companySectors = companySectors,
        _visibilityFlags = visibilityFlags;

  @override
  final String name;
  @override
  final String displayName;
  @override
  final String birthday;
  final Set<String> _interests;
  @override
  Set<String> get interests {
    if (_interests is EqualUnmodifiableSetView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_interests);
  }

  final Set<String> _genders;
  @override
  Set<String> get genders {
    if (_genders is EqualUnmodifiableSetView) return _genders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_genders);
  }

  final Set<String> _companySectors;
  @override
  Set<String> get companySectors {
    if (_companySectors is EqualUnmodifiableSetView) return _companySectors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_companySectors);
  }

  @override
  final String? hivStatus;
  @override
  final String? hivStatusCategory;
  @override
  final String biography;
  @override
  final String accentColor;
  @override
  @JsonKey()
  final bool isFocused;
  @override
  @JsonKey()
  final String locationSearchQuery;
  @override
  @JsonKey()
  final bool hasFailedLocationSearch;
  @override
  final PositivePlace? place;
  @override
  final bool isBusy;
  @override
  final FormMode formMode;
  final Map<String, bool> _visibilityFlags;
  @override
  Map<String, bool> get visibilityFlags {
    if (_visibilityFlags is EqualUnmodifiableMapView) return _visibilityFlags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_visibilityFlags);
  }

  @override
  final XFile? newProfileImage;

  @override
  String toString() {
    return 'ProfileFormState(name: $name, displayName: $displayName, birthday: $birthday, interests: $interests, genders: $genders, companySectors: $companySectors, hivStatus: $hivStatus, hivStatusCategory: $hivStatusCategory, biography: $biography, accentColor: $accentColor, isFocused: $isFocused, locationSearchQuery: $locationSearchQuery, hasFailedLocationSearch: $hasFailedLocationSearch, place: $place, isBusy: $isBusy, formMode: $formMode, visibilityFlags: $visibilityFlags, newProfileImage: $newProfileImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileFormStateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.birthday, birthday) ||
                other.birthday == birthday) &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests) &&
            const DeepCollectionEquality().equals(other._genders, _genders) &&
            const DeepCollectionEquality()
                .equals(other._companySectors, _companySectors) &&
            (identical(other.hivStatus, hivStatus) ||
                other.hivStatus == hivStatus) &&
            (identical(other.hivStatusCategory, hivStatusCategory) ||
                other.hivStatusCategory == hivStatusCategory) &&
            (identical(other.biography, biography) ||
                other.biography == biography) &&
            (identical(other.accentColor, accentColor) ||
                other.accentColor == accentColor) &&
            (identical(other.isFocused, isFocused) ||
                other.isFocused == isFocused) &&
            (identical(other.locationSearchQuery, locationSearchQuery) ||
                other.locationSearchQuery == locationSearchQuery) &&
            (identical(
                    other.hasFailedLocationSearch, hasFailedLocationSearch) ||
                other.hasFailedLocationSearch == hasFailedLocationSearch) &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.formMode, formMode) ||
                other.formMode == formMode) &&
            const DeepCollectionEquality()
                .equals(other._visibilityFlags, _visibilityFlags) &&
            (identical(other.newProfileImage, newProfileImage) ||
                other.newProfileImage == newProfileImage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      displayName,
      birthday,
      const DeepCollectionEquality().hash(_interests),
      const DeepCollectionEquality().hash(_genders),
      const DeepCollectionEquality().hash(_companySectors),
      hivStatus,
      hivStatusCategory,
      biography,
      accentColor,
      isFocused,
      locationSearchQuery,
      hasFailedLocationSearch,
      place,
      isBusy,
      formMode,
      const DeepCollectionEquality().hash(_visibilityFlags),
      newProfileImage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileFormStateImplCopyWith<_$ProfileFormStateImpl> get copyWith =>
      __$$ProfileFormStateImplCopyWithImpl<_$ProfileFormStateImpl>(
          this, _$identity);
}

abstract class _ProfileFormState implements ProfileFormState {
  const factory _ProfileFormState(
      {required final String name,
      required final String displayName,
      required final String birthday,
      required final Set<String> interests,
      required final Set<String> genders,
      required final Set<String> companySectors,
      final String? hivStatus,
      final String? hivStatusCategory,
      required final String biography,
      required final String accentColor,
      final bool isFocused,
      final String locationSearchQuery,
      final bool hasFailedLocationSearch,
      final PositivePlace? place,
      required final bool isBusy,
      required final FormMode formMode,
      required final Map<String, bool> visibilityFlags,
      required final XFile? newProfileImage}) = _$ProfileFormStateImpl;

  @override
  String get name;
  @override
  String get displayName;
  @override
  String get birthday;
  @override
  Set<String> get interests;
  @override
  Set<String> get genders;
  @override
  Set<String> get companySectors;
  @override
  String? get hivStatus;
  @override
  String? get hivStatusCategory;
  @override
  String get biography;
  @override
  String get accentColor;
  @override
  bool get isFocused;
  @override
  String get locationSearchQuery;
  @override
  bool get hasFailedLocationSearch;
  @override
  PositivePlace? get place;
  @override
  bool get isBusy;
  @override
  FormMode get formMode;
  @override
  Map<String, bool> get visibilityFlags;
  @override
  XFile? get newProfileImage;
  @override
  @JsonKey(ignore: true)
  _$$ProfileFormStateImplCopyWith<_$ProfileFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
