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
  Map<String, ContentBuilder> get guidancePageBuilders =>
      throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;
  GuidanceSection? get guidanceSection => throw _privateConstructorUsedError;
  bool get isSearching => throw _privateConstructorUsedError;
  String get previousSearchTerm => throw _privateConstructorUsedError;
  TextEditingController? get searchController =>
      throw _privateConstructorUsedError;
  Timer? get searchTimer => throw _privateConstructorUsedError;

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
      {Map<String, ContentBuilder> guidancePageBuilders,
      bool isBusy,
      GuidanceSection? guidanceSection,
      bool isSearching,
      String previousSearchTerm,
      TextEditingController? searchController,
      Timer? searchTimer});
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
    Object? guidancePageBuilders = null,
    Object? isBusy = null,
    Object? guidanceSection = freezed,
    Object? isSearching = null,
    Object? previousSearchTerm = null,
    Object? searchController = freezed,
    Object? searchTimer = freezed,
  }) {
    return _then(_value.copyWith(
      guidancePageBuilders: null == guidancePageBuilders
          ? _value.guidancePageBuilders
          : guidancePageBuilders // ignore: cast_nullable_to_non_nullable
              as Map<String, ContentBuilder>,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      guidanceSection: freezed == guidanceSection
          ? _value.guidanceSection
          : guidanceSection // ignore: cast_nullable_to_non_nullable
              as GuidanceSection?,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      previousSearchTerm: null == previousSearchTerm
          ? _value.previousSearchTerm
          : previousSearchTerm // ignore: cast_nullable_to_non_nullable
              as String,
      searchController: freezed == searchController
          ? _value.searchController
          : searchController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      searchTimer: freezed == searchTimer
          ? _value.searchTimer
          : searchTimer // ignore: cast_nullable_to_non_nullable
              as Timer?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GuidanceControllerStateCopyWith<$Res>
    implements $GuidanceControllerStateCopyWith<$Res> {
  factory _$$_GuidanceControllerStateCopyWith(_$_GuidanceControllerState value,
          $Res Function(_$_GuidanceControllerState) then) =
      __$$_GuidanceControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, ContentBuilder> guidancePageBuilders,
      bool isBusy,
      GuidanceSection? guidanceSection,
      bool isSearching,
      String previousSearchTerm,
      TextEditingController? searchController,
      Timer? searchTimer});
}

/// @nodoc
class __$$_GuidanceControllerStateCopyWithImpl<$Res>
    extends _$GuidanceControllerStateCopyWithImpl<$Res,
        _$_GuidanceControllerState>
    implements _$$_GuidanceControllerStateCopyWith<$Res> {
  __$$_GuidanceControllerStateCopyWithImpl(_$_GuidanceControllerState _value,
      $Res Function(_$_GuidanceControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? guidancePageBuilders = null,
    Object? isBusy = null,
    Object? guidanceSection = freezed,
    Object? isSearching = null,
    Object? previousSearchTerm = null,
    Object? searchController = freezed,
    Object? searchTimer = freezed,
  }) {
    return _then(_$_GuidanceControllerState(
      guidancePageBuilders: null == guidancePageBuilders
          ? _value._guidancePageBuilders
          : guidancePageBuilders // ignore: cast_nullable_to_non_nullable
              as Map<String, ContentBuilder>,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      guidanceSection: freezed == guidanceSection
          ? _value.guidanceSection
          : guidanceSection // ignore: cast_nullable_to_non_nullable
              as GuidanceSection?,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      previousSearchTerm: null == previousSearchTerm
          ? _value.previousSearchTerm
          : previousSearchTerm // ignore: cast_nullable_to_non_nullable
              as String,
      searchController: freezed == searchController
          ? _value.searchController
          : searchController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      searchTimer: freezed == searchTimer
          ? _value.searchTimer
          : searchTimer // ignore: cast_nullable_to_non_nullable
              as Timer?,
    ));
  }
}

/// @nodoc

class _$_GuidanceControllerState implements _GuidanceControllerState {
  const _$_GuidanceControllerState(
      {final Map<String, ContentBuilder> guidancePageBuilders = const {},
      this.isBusy = false,
      this.guidanceSection = null,
      this.isSearching = false,
      this.previousSearchTerm = "",
      this.searchController = null,
      this.searchTimer = null})
      : _guidancePageBuilders = guidancePageBuilders;

  final Map<String, ContentBuilder> _guidancePageBuilders;
  @override
  @JsonKey()
  Map<String, ContentBuilder> get guidancePageBuilders {
    if (_guidancePageBuilders is EqualUnmodifiableMapView)
      return _guidancePageBuilders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_guidancePageBuilders);
  }

  @override
  @JsonKey()
  final bool isBusy;
  @override
  @JsonKey()
  final GuidanceSection? guidanceSection;
  @override
  @JsonKey()
  final bool isSearching;
  @override
  @JsonKey()
  final String previousSearchTerm;
  @override
  @JsonKey()
  final TextEditingController? searchController;
  @override
  @JsonKey()
  final Timer? searchTimer;

  @override
  String toString() {
    return 'GuidanceControllerState(guidancePageBuilders: $guidancePageBuilders, isBusy: $isBusy, guidanceSection: $guidanceSection, isSearching: $isSearching, previousSearchTerm: $previousSearchTerm, searchController: $searchController, searchTimer: $searchTimer)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuidanceControllerState &&
            const DeepCollectionEquality()
                .equals(other._guidancePageBuilders, _guidancePageBuilders) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.guidanceSection, guidanceSection) ||
                other.guidanceSection == guidanceSection) &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            (identical(other.previousSearchTerm, previousSearchTerm) ||
                other.previousSearchTerm == previousSearchTerm) &&
            (identical(other.searchController, searchController) ||
                other.searchController == searchController) &&
            (identical(other.searchTimer, searchTimer) ||
                other.searchTimer == searchTimer));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_guidancePageBuilders),
      isBusy,
      guidanceSection,
      isSearching,
      previousSearchTerm,
      searchController,
      searchTimer);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GuidanceControllerStateCopyWith<_$_GuidanceControllerState>
      get copyWith =>
          __$$_GuidanceControllerStateCopyWithImpl<_$_GuidanceControllerState>(
              this, _$identity);
}

abstract class _GuidanceControllerState implements GuidanceControllerState {
  const factory _GuidanceControllerState(
      {final Map<String, ContentBuilder> guidancePageBuilders,
      final bool isBusy,
      final GuidanceSection? guidanceSection,
      final bool isSearching,
      final String previousSearchTerm,
      final TextEditingController? searchController,
      final Timer? searchTimer}) = _$_GuidanceControllerState;

  @override
  Map<String, ContentBuilder> get guidancePageBuilders;
  @override
  bool get isBusy;
  @override
  GuidanceSection? get guidanceSection;
  @override
  bool get isSearching;
  @override
  String get previousSearchTerm;
  @override
  TextEditingController? get searchController;
  @override
  Timer? get searchTimer;
  @override
  @JsonKey(ignore: true)
  _$$_GuidanceControllerStateCopyWith<_$_GuidanceControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
