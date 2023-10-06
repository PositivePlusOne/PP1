// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_post_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CreatePostViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;
  PostType get currentPostType => throw _privateConstructorUsedError;
  CreatePostCurrentPage get currentCreatePostPage =>
      throw _privateConstructorUsedError;
  bool get isEditing => throw _privateConstructorUsedError;
  String get currentActivityID => throw _privateConstructorUsedError;
  List<GalleryEntry> get galleryEntries => throw _privateConstructorUsedError;
  GalleryEntry? get editingGalleryEntry => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get allowSharing => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  ActivitySecurityConfigurationMode get visibleTo =>
      throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  ActivitySecurityConfigurationMode get allowComments =>
      throw _privateConstructorUsedError;
  String get activeButtonFlexText => throw _privateConstructorUsedError;
  bool get saveToGallery => throw _privateConstructorUsedError;
  AwesomeFilter get currentFilter => throw _privateConstructorUsedError;
  ActivityData get previousActivity => throw _privateConstructorUsedError;
  PositivePostNavigationActiveButton get activeButton =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CreatePostViewModelStateCopyWith<CreatePostViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePostViewModelStateCopyWith<$Res> {
  factory $CreatePostViewModelStateCopyWith(CreatePostViewModelState value,
          $Res Function(CreatePostViewModelState) then) =
      _$CreatePostViewModelStateCopyWithImpl<$Res, CreatePostViewModelState>;
  @useResult
  $Res call(
      {bool isBusy,
      PostType currentPostType,
      CreatePostCurrentPage currentCreatePostPage,
      bool isEditing,
      String currentActivityID,
      List<GalleryEntry> galleryEntries,
      GalleryEntry? editingGalleryEntry,
      List<String> tags,
      bool allowSharing,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      ActivitySecurityConfigurationMode visibleTo,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      ActivitySecurityConfigurationMode allowComments,
      String activeButtonFlexText,
      bool saveToGallery,
      AwesomeFilter currentFilter,
      ActivityData previousActivity,
      PositivePostNavigationActiveButton activeButton});

  $ActivitySecurityConfigurationModeCopyWith<$Res> get visibleTo;
  $ActivitySecurityConfigurationModeCopyWith<$Res> get allowComments;
}

/// @nodoc
class _$CreatePostViewModelStateCopyWithImpl<$Res,
        $Val extends CreatePostViewModelState>
    implements $CreatePostViewModelStateCopyWith<$Res> {
  _$CreatePostViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? currentPostType = null,
    Object? currentCreatePostPage = null,
    Object? isEditing = null,
    Object? currentActivityID = null,
    Object? galleryEntries = null,
    Object? editingGalleryEntry = freezed,
    Object? tags = null,
    Object? allowSharing = null,
    Object? visibleTo = null,
    Object? allowComments = null,
    Object? activeButtonFlexText = null,
    Object? saveToGallery = null,
    Object? currentFilter = freezed,
    Object? previousActivity = null,
    Object? activeButton = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPostType: null == currentPostType
          ? _value.currentPostType
          : currentPostType // ignore: cast_nullable_to_non_nullable
              as PostType,
      currentCreatePostPage: null == currentCreatePostPage
          ? _value.currentCreatePostPage
          : currentCreatePostPage // ignore: cast_nullable_to_non_nullable
              as CreatePostCurrentPage,
      isEditing: null == isEditing
          ? _value.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
      currentActivityID: null == currentActivityID
          ? _value.currentActivityID
          : currentActivityID // ignore: cast_nullable_to_non_nullable
              as String,
      galleryEntries: null == galleryEntries
          ? _value.galleryEntries
          : galleryEntries // ignore: cast_nullable_to_non_nullable
              as List<GalleryEntry>,
      editingGalleryEntry: freezed == editingGalleryEntry
          ? _value.editingGalleryEntry
          : editingGalleryEntry // ignore: cast_nullable_to_non_nullable
              as GalleryEntry?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allowSharing: null == allowSharing
          ? _value.allowSharing
          : allowSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      visibleTo: null == visibleTo
          ? _value.visibleTo
          : visibleTo // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfigurationMode,
      allowComments: null == allowComments
          ? _value.allowComments
          : allowComments // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfigurationMode,
      activeButtonFlexText: null == activeButtonFlexText
          ? _value.activeButtonFlexText
          : activeButtonFlexText // ignore: cast_nullable_to_non_nullable
              as String,
      saveToGallery: null == saveToGallery
          ? _value.saveToGallery
          : saveToGallery // ignore: cast_nullable_to_non_nullable
              as bool,
      currentFilter: freezed == currentFilter
          ? _value.currentFilter
          : currentFilter // ignore: cast_nullable_to_non_nullable
              as AwesomeFilter,
      previousActivity: null == previousActivity
          ? _value.previousActivity
          : previousActivity // ignore: cast_nullable_to_non_nullable
              as ActivityData,
      activeButton: null == activeButton
          ? _value.activeButton
          : activeButton // ignore: cast_nullable_to_non_nullable
              as PositivePostNavigationActiveButton,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivitySecurityConfigurationModeCopyWith<$Res> get visibleTo {
    return $ActivitySecurityConfigurationModeCopyWith<$Res>(_value.visibleTo,
        (value) {
      return _then(_value.copyWith(visibleTo: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActivitySecurityConfigurationModeCopyWith<$Res> get allowComments {
    return $ActivitySecurityConfigurationModeCopyWith<$Res>(
        _value.allowComments, (value) {
      return _then(_value.copyWith(allowComments: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreatePostViewModelStateImplCopyWith<$Res>
    implements $CreatePostViewModelStateCopyWith<$Res> {
  factory _$$CreatePostViewModelStateImplCopyWith(
          _$CreatePostViewModelStateImpl value,
          $Res Function(_$CreatePostViewModelStateImpl) then) =
      __$$CreatePostViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isBusy,
      PostType currentPostType,
      CreatePostCurrentPage currentCreatePostPage,
      bool isEditing,
      String currentActivityID,
      List<GalleryEntry> galleryEntries,
      GalleryEntry? editingGalleryEntry,
      List<String> tags,
      bool allowSharing,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      ActivitySecurityConfigurationMode visibleTo,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      ActivitySecurityConfigurationMode allowComments,
      String activeButtonFlexText,
      bool saveToGallery,
      AwesomeFilter currentFilter,
      ActivityData previousActivity,
      PositivePostNavigationActiveButton activeButton});

  @override
  $ActivitySecurityConfigurationModeCopyWith<$Res> get visibleTo;
  @override
  $ActivitySecurityConfigurationModeCopyWith<$Res> get allowComments;
}

/// @nodoc
class __$$CreatePostViewModelStateImplCopyWithImpl<$Res>
    extends _$CreatePostViewModelStateCopyWithImpl<$Res,
        _$CreatePostViewModelStateImpl>
    implements _$$CreatePostViewModelStateImplCopyWith<$Res> {
  __$$CreatePostViewModelStateImplCopyWithImpl(
      _$CreatePostViewModelStateImpl _value,
      $Res Function(_$CreatePostViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? currentPostType = null,
    Object? currentCreatePostPage = null,
    Object? isEditing = null,
    Object? currentActivityID = null,
    Object? galleryEntries = null,
    Object? editingGalleryEntry = freezed,
    Object? tags = null,
    Object? allowSharing = null,
    Object? visibleTo = null,
    Object? allowComments = null,
    Object? activeButtonFlexText = null,
    Object? saveToGallery = null,
    Object? currentFilter = freezed,
    Object? previousActivity = null,
    Object? activeButton = null,
  }) {
    return _then(_$CreatePostViewModelStateImpl(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPostType: null == currentPostType
          ? _value.currentPostType
          : currentPostType // ignore: cast_nullable_to_non_nullable
              as PostType,
      currentCreatePostPage: null == currentCreatePostPage
          ? _value.currentCreatePostPage
          : currentCreatePostPage // ignore: cast_nullable_to_non_nullable
              as CreatePostCurrentPage,
      isEditing: null == isEditing
          ? _value.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
      currentActivityID: null == currentActivityID
          ? _value.currentActivityID
          : currentActivityID // ignore: cast_nullable_to_non_nullable
              as String,
      galleryEntries: null == galleryEntries
          ? _value._galleryEntries
          : galleryEntries // ignore: cast_nullable_to_non_nullable
              as List<GalleryEntry>,
      editingGalleryEntry: freezed == editingGalleryEntry
          ? _value.editingGalleryEntry
          : editingGalleryEntry // ignore: cast_nullable_to_non_nullable
              as GalleryEntry?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allowSharing: null == allowSharing
          ? _value.allowSharing
          : allowSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      visibleTo: null == visibleTo
          ? _value.visibleTo
          : visibleTo // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfigurationMode,
      allowComments: null == allowComments
          ? _value.allowComments
          : allowComments // ignore: cast_nullable_to_non_nullable
              as ActivitySecurityConfigurationMode,
      activeButtonFlexText: null == activeButtonFlexText
          ? _value.activeButtonFlexText
          : activeButtonFlexText // ignore: cast_nullable_to_non_nullable
              as String,
      saveToGallery: null == saveToGallery
          ? _value.saveToGallery
          : saveToGallery // ignore: cast_nullable_to_non_nullable
              as bool,
      currentFilter: freezed == currentFilter
          ? _value.currentFilter
          : currentFilter // ignore: cast_nullable_to_non_nullable
              as AwesomeFilter,
      previousActivity: null == previousActivity
          ? _value.previousActivity
          : previousActivity // ignore: cast_nullable_to_non_nullable
              as ActivityData,
      activeButton: null == activeButton
          ? _value.activeButton
          : activeButton // ignore: cast_nullable_to_non_nullable
              as PositivePostNavigationActiveButton,
    ));
  }
}

/// @nodoc

class _$CreatePostViewModelStateImpl
    with DiagnosticableTreeMixin
    implements _CreatePostViewModelState {
  const _$CreatePostViewModelStateImpl(
      {this.isBusy = false,
      this.currentPostType = PostType.image,
      this.currentCreatePostPage = CreatePostCurrentPage.entry,
      this.isEditing = false,
      this.currentActivityID = '',
      final List<GalleryEntry> galleryEntries = const [],
      this.editingGalleryEntry,
      final List<String> tags = const [],
      this.allowSharing = false,
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      this.visibleTo = const ActivitySecurityConfigurationMode.public(),
      @JsonKey(
          fromJson: ActivitySecurityConfigurationMode.fromJson,
          toJson: ActivitySecurityConfigurationMode.toJson)
      this.allowComments = const ActivitySecurityConfigurationMode.signedIn(),
      this.activeButtonFlexText = "",
      this.saveToGallery = false,
      required this.currentFilter,
      required this.previousActivity,
      this.activeButton = PositivePostNavigationActiveButton.post})
      : _galleryEntries = galleryEntries,
        _tags = tags;

  @override
  @JsonKey()
  final bool isBusy;
  @override
  @JsonKey()
  final PostType currentPostType;
  @override
  @JsonKey()
  final CreatePostCurrentPage currentCreatePostPage;
  @override
  @JsonKey()
  final bool isEditing;
  @override
  @JsonKey()
  final String currentActivityID;
  final List<GalleryEntry> _galleryEntries;
  @override
  @JsonKey()
  List<GalleryEntry> get galleryEntries {
    if (_galleryEntries is EqualUnmodifiableListView) return _galleryEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_galleryEntries);
  }

  @override
  final GalleryEntry? editingGalleryEntry;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool allowSharing;
  @override
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  final ActivitySecurityConfigurationMode visibleTo;
  @override
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  final ActivitySecurityConfigurationMode allowComments;
  @override
  @JsonKey()
  final String activeButtonFlexText;
  @override
  @JsonKey()
  final bool saveToGallery;
  @override
  final AwesomeFilter currentFilter;
  @override
  final ActivityData previousActivity;
  @override
  @JsonKey()
  final PositivePostNavigationActiveButton activeButton;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CreatePostViewModelState(isBusy: $isBusy, currentPostType: $currentPostType, currentCreatePostPage: $currentCreatePostPage, isEditing: $isEditing, currentActivityID: $currentActivityID, galleryEntries: $galleryEntries, editingGalleryEntry: $editingGalleryEntry, tags: $tags, allowSharing: $allowSharing, visibleTo: $visibleTo, allowComments: $allowComments, activeButtonFlexText: $activeButtonFlexText, saveToGallery: $saveToGallery, currentFilter: $currentFilter, previousActivity: $previousActivity, activeButton: $activeButton)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CreatePostViewModelState'))
      ..add(DiagnosticsProperty('isBusy', isBusy))
      ..add(DiagnosticsProperty('currentPostType', currentPostType))
      ..add(DiagnosticsProperty('currentCreatePostPage', currentCreatePostPage))
      ..add(DiagnosticsProperty('isEditing', isEditing))
      ..add(DiagnosticsProperty('currentActivityID', currentActivityID))
      ..add(DiagnosticsProperty('galleryEntries', galleryEntries))
      ..add(DiagnosticsProperty('editingGalleryEntry', editingGalleryEntry))
      ..add(DiagnosticsProperty('tags', tags))
      ..add(DiagnosticsProperty('allowSharing', allowSharing))
      ..add(DiagnosticsProperty('visibleTo', visibleTo))
      ..add(DiagnosticsProperty('allowComments', allowComments))
      ..add(DiagnosticsProperty('activeButtonFlexText', activeButtonFlexText))
      ..add(DiagnosticsProperty('saveToGallery', saveToGallery))
      ..add(DiagnosticsProperty('currentFilter', currentFilter))
      ..add(DiagnosticsProperty('previousActivity', previousActivity))
      ..add(DiagnosticsProperty('activeButton', activeButton));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostViewModelStateImpl &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.currentPostType, currentPostType) ||
                other.currentPostType == currentPostType) &&
            (identical(other.currentCreatePostPage, currentCreatePostPage) ||
                other.currentCreatePostPage == currentCreatePostPage) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing) &&
            (identical(other.currentActivityID, currentActivityID) ||
                other.currentActivityID == currentActivityID) &&
            const DeepCollectionEquality()
                .equals(other._galleryEntries, _galleryEntries) &&
            (identical(other.editingGalleryEntry, editingGalleryEntry) ||
                other.editingGalleryEntry == editingGalleryEntry) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.allowSharing, allowSharing) ||
                other.allowSharing == allowSharing) &&
            (identical(other.visibleTo, visibleTo) ||
                other.visibleTo == visibleTo) &&
            (identical(other.allowComments, allowComments) ||
                other.allowComments == allowComments) &&
            (identical(other.activeButtonFlexText, activeButtonFlexText) ||
                other.activeButtonFlexText == activeButtonFlexText) &&
            (identical(other.saveToGallery, saveToGallery) ||
                other.saveToGallery == saveToGallery) &&
            const DeepCollectionEquality()
                .equals(other.currentFilter, currentFilter) &&
            (identical(other.previousActivity, previousActivity) ||
                other.previousActivity == previousActivity) &&
            (identical(other.activeButton, activeButton) ||
                other.activeButton == activeButton));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isBusy,
      currentPostType,
      currentCreatePostPage,
      isEditing,
      currentActivityID,
      const DeepCollectionEquality().hash(_galleryEntries),
      editingGalleryEntry,
      const DeepCollectionEquality().hash(_tags),
      allowSharing,
      visibleTo,
      allowComments,
      activeButtonFlexText,
      saveToGallery,
      const DeepCollectionEquality().hash(currentFilter),
      previousActivity,
      activeButton);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePostViewModelStateImplCopyWith<_$CreatePostViewModelStateImpl>
      get copyWith => __$$CreatePostViewModelStateImplCopyWithImpl<
          _$CreatePostViewModelStateImpl>(this, _$identity);
}

abstract class _CreatePostViewModelState implements CreatePostViewModelState {
  const factory _CreatePostViewModelState(
          {final bool isBusy,
          final PostType currentPostType,
          final CreatePostCurrentPage currentCreatePostPage,
          final bool isEditing,
          final String currentActivityID,
          final List<GalleryEntry> galleryEntries,
          final GalleryEntry? editingGalleryEntry,
          final List<String> tags,
          final bool allowSharing,
          @JsonKey(
              fromJson: ActivitySecurityConfigurationMode.fromJson,
              toJson: ActivitySecurityConfigurationMode.toJson)
          final ActivitySecurityConfigurationMode visibleTo,
          @JsonKey(
              fromJson: ActivitySecurityConfigurationMode.fromJson,
              toJson: ActivitySecurityConfigurationMode.toJson)
          final ActivitySecurityConfigurationMode allowComments,
          final String activeButtonFlexText,
          final bool saveToGallery,
          required final AwesomeFilter currentFilter,
          required final ActivityData previousActivity,
          final PositivePostNavigationActiveButton activeButton}) =
      _$CreatePostViewModelStateImpl;

  @override
  bool get isBusy;
  @override
  PostType get currentPostType;
  @override
  CreatePostCurrentPage get currentCreatePostPage;
  @override
  bool get isEditing;
  @override
  String get currentActivityID;
  @override
  List<GalleryEntry> get galleryEntries;
  @override
  GalleryEntry? get editingGalleryEntry;
  @override
  List<String> get tags;
  @override
  bool get allowSharing;
  @override
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  ActivitySecurityConfigurationMode get visibleTo;
  @override
  @JsonKey(
      fromJson: ActivitySecurityConfigurationMode.fromJson,
      toJson: ActivitySecurityConfigurationMode.toJson)
  ActivitySecurityConfigurationMode get allowComments;
  @override
  String get activeButtonFlexText;
  @override
  bool get saveToGallery;
  @override
  AwesomeFilter get currentFilter;
  @override
  ActivityData get previousActivity;
  @override
  PositivePostNavigationActiveButton get activeButton;
  @override
  @JsonKey(ignore: true)
  _$$CreatePostViewModelStateImplCopyWith<_$CreatePostViewModelStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
