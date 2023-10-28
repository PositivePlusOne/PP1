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
  bool get isProcessingMedia => throw _privateConstructorUsedError;
  bool get isUploadingMedia => throw _privateConstructorUsedError;
  PostType get currentPostType => throw _privateConstructorUsedError;
  CreatePostCurrentPage get currentCreatePostPage =>
      throw _privateConstructorUsedError;
  bool get isEditing => throw _privateConstructorUsedError;
  String get currentActivityID => throw _privateConstructorUsedError;
  List<GalleryEntry> get galleryEntries => throw _privateConstructorUsedError;
  GalleryEntry? get editingGalleryEntry => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String get promotionKey => throw _privateConstructorUsedError;
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
  AwesomeFilter get currentFilter =>
      throw _privateConstructorUsedError; //? Repost
  String? get reposterActivityID =>
      throw _privateConstructorUsedError; //? Editing
  ActivityData get previousActivity =>
      throw _privateConstructorUsedError; //? Clip delay and clip length options
  int get delayTimerCurrentSelection => throw _privateConstructorUsedError;
  bool get isDelayTimerEnabled => throw _privateConstructorUsedError;
  int get maximumClipDurationSelection => throw _privateConstructorUsedError;
  bool get isMaximumClipDurationEnabled => throw _privateConstructorUsedError;
  bool get isBottomNavigationEnabled => throw _privateConstructorUsedError;
  bool get isCreatingClip => throw _privateConstructorUsedError;
  GlobalKey<PositiveCameraState> get cameraWidgetKey =>
      throw _privateConstructorUsedError;
  PositivePostNavigationActiveButton get activeButton =>
      throw _privateConstructorUsedError;
  PositivePostNavigationActiveButton get lastActiveButton =>
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
      bool isProcessingMedia,
      bool isUploadingMedia,
      PostType currentPostType,
      CreatePostCurrentPage currentCreatePostPage,
      bool isEditing,
      String currentActivityID,
      List<GalleryEntry> galleryEntries,
      GalleryEntry? editingGalleryEntry,
      List<String> tags,
      String promotionKey,
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
      String? reposterActivityID,
      ActivityData previousActivity,
      int delayTimerCurrentSelection,
      bool isDelayTimerEnabled,
      int maximumClipDurationSelection,
      bool isMaximumClipDurationEnabled,
      bool isBottomNavigationEnabled,
      bool isCreatingClip,
      GlobalKey<PositiveCameraState> cameraWidgetKey,
      PositivePostNavigationActiveButton activeButton,
      PositivePostNavigationActiveButton lastActiveButton});

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
    Object? isProcessingMedia = null,
    Object? isUploadingMedia = null,
    Object? currentPostType = null,
    Object? currentCreatePostPage = null,
    Object? isEditing = null,
    Object? currentActivityID = null,
    Object? galleryEntries = null,
    Object? editingGalleryEntry = freezed,
    Object? tags = null,
    Object? promotionKey = null,
    Object? allowSharing = null,
    Object? visibleTo = null,
    Object? allowComments = null,
    Object? activeButtonFlexText = null,
    Object? saveToGallery = null,
    Object? currentFilter = null,
    Object? reposterActivityID = freezed,
    Object? previousActivity = null,
    Object? delayTimerCurrentSelection = null,
    Object? isDelayTimerEnabled = null,
    Object? maximumClipDurationSelection = null,
    Object? isMaximumClipDurationEnabled = null,
    Object? isBottomNavigationEnabled = null,
    Object? isCreatingClip = null,
    Object? cameraWidgetKey = null,
    Object? activeButton = null,
    Object? lastActiveButton = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      isProcessingMedia: null == isProcessingMedia
          ? _value.isProcessingMedia
          : isProcessingMedia // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploadingMedia: null == isUploadingMedia
          ? _value.isUploadingMedia
          : isUploadingMedia // ignore: cast_nullable_to_non_nullable
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
      promotionKey: null == promotionKey
          ? _value.promotionKey
          : promotionKey // ignore: cast_nullable_to_non_nullable
              as String,
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
      currentFilter: null == currentFilter
          ? _value.currentFilter
          : currentFilter // ignore: cast_nullable_to_non_nullable
              as AwesomeFilter,
      reposterActivityID: freezed == reposterActivityID
          ? _value.reposterActivityID
          : reposterActivityID // ignore: cast_nullable_to_non_nullable
              as String?,
      previousActivity: null == previousActivity
          ? _value.previousActivity
          : previousActivity // ignore: cast_nullable_to_non_nullable
              as ActivityData,
      delayTimerCurrentSelection: null == delayTimerCurrentSelection
          ? _value.delayTimerCurrentSelection
          : delayTimerCurrentSelection // ignore: cast_nullable_to_non_nullable
              as int,
      isDelayTimerEnabled: null == isDelayTimerEnabled
          ? _value.isDelayTimerEnabled
          : isDelayTimerEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      maximumClipDurationSelection: null == maximumClipDurationSelection
          ? _value.maximumClipDurationSelection
          : maximumClipDurationSelection // ignore: cast_nullable_to_non_nullable
              as int,
      isMaximumClipDurationEnabled: null == isMaximumClipDurationEnabled
          ? _value.isMaximumClipDurationEnabled
          : isMaximumClipDurationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isBottomNavigationEnabled: null == isBottomNavigationEnabled
          ? _value.isBottomNavigationEnabled
          : isBottomNavigationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreatingClip: null == isCreatingClip
          ? _value.isCreatingClip
          : isCreatingClip // ignore: cast_nullable_to_non_nullable
              as bool,
      cameraWidgetKey: null == cameraWidgetKey
          ? _value.cameraWidgetKey
          : cameraWidgetKey // ignore: cast_nullable_to_non_nullable
              as GlobalKey<PositiveCameraState>,
      activeButton: null == activeButton
          ? _value.activeButton
          : activeButton // ignore: cast_nullable_to_non_nullable
              as PositivePostNavigationActiveButton,
      lastActiveButton: null == lastActiveButton
          ? _value.lastActiveButton
          : lastActiveButton // ignore: cast_nullable_to_non_nullable
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
      bool isProcessingMedia,
      bool isUploadingMedia,
      PostType currentPostType,
      CreatePostCurrentPage currentCreatePostPage,
      bool isEditing,
      String currentActivityID,
      List<GalleryEntry> galleryEntries,
      GalleryEntry? editingGalleryEntry,
      List<String> tags,
      String promotionKey,
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
      String? reposterActivityID,
      ActivityData previousActivity,
      int delayTimerCurrentSelection,
      bool isDelayTimerEnabled,
      int maximumClipDurationSelection,
      bool isMaximumClipDurationEnabled,
      bool isBottomNavigationEnabled,
      bool isCreatingClip,
      GlobalKey<PositiveCameraState> cameraWidgetKey,
      PositivePostNavigationActiveButton activeButton,
      PositivePostNavigationActiveButton lastActiveButton});

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
    Object? isProcessingMedia = null,
    Object? isUploadingMedia = null,
    Object? currentPostType = null,
    Object? currentCreatePostPage = null,
    Object? isEditing = null,
    Object? currentActivityID = null,
    Object? galleryEntries = null,
    Object? editingGalleryEntry = freezed,
    Object? tags = null,
    Object? promotionKey = null,
    Object? allowSharing = null,
    Object? visibleTo = null,
    Object? allowComments = null,
    Object? activeButtonFlexText = null,
    Object? saveToGallery = null,
    Object? currentFilter = null,
    Object? reposterActivityID = freezed,
    Object? previousActivity = null,
    Object? delayTimerCurrentSelection = null,
    Object? isDelayTimerEnabled = null,
    Object? maximumClipDurationSelection = null,
    Object? isMaximumClipDurationEnabled = null,
    Object? isBottomNavigationEnabled = null,
    Object? isCreatingClip = null,
    Object? cameraWidgetKey = null,
    Object? activeButton = null,
    Object? lastActiveButton = null,
  }) {
    return _then(_$CreatePostViewModelStateImpl(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      isProcessingMedia: null == isProcessingMedia
          ? _value.isProcessingMedia
          : isProcessingMedia // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploadingMedia: null == isUploadingMedia
          ? _value.isUploadingMedia
          : isUploadingMedia // ignore: cast_nullable_to_non_nullable
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
      promotionKey: null == promotionKey
          ? _value.promotionKey
          : promotionKey // ignore: cast_nullable_to_non_nullable
              as String,
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
      currentFilter: null == currentFilter
          ? _value.currentFilter
          : currentFilter // ignore: cast_nullable_to_non_nullable
              as AwesomeFilter,
      reposterActivityID: freezed == reposterActivityID
          ? _value.reposterActivityID
          : reposterActivityID // ignore: cast_nullable_to_non_nullable
              as String?,
      previousActivity: null == previousActivity
          ? _value.previousActivity
          : previousActivity // ignore: cast_nullable_to_non_nullable
              as ActivityData,
      delayTimerCurrentSelection: null == delayTimerCurrentSelection
          ? _value.delayTimerCurrentSelection
          : delayTimerCurrentSelection // ignore: cast_nullable_to_non_nullable
              as int,
      isDelayTimerEnabled: null == isDelayTimerEnabled
          ? _value.isDelayTimerEnabled
          : isDelayTimerEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      maximumClipDurationSelection: null == maximumClipDurationSelection
          ? _value.maximumClipDurationSelection
          : maximumClipDurationSelection // ignore: cast_nullable_to_non_nullable
              as int,
      isMaximumClipDurationEnabled: null == isMaximumClipDurationEnabled
          ? _value.isMaximumClipDurationEnabled
          : isMaximumClipDurationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isBottomNavigationEnabled: null == isBottomNavigationEnabled
          ? _value.isBottomNavigationEnabled
          : isBottomNavigationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreatingClip: null == isCreatingClip
          ? _value.isCreatingClip
          : isCreatingClip // ignore: cast_nullable_to_non_nullable
              as bool,
      cameraWidgetKey: null == cameraWidgetKey
          ? _value.cameraWidgetKey
          : cameraWidgetKey // ignore: cast_nullable_to_non_nullable
              as GlobalKey<PositiveCameraState>,
      activeButton: null == activeButton
          ? _value.activeButton
          : activeButton // ignore: cast_nullable_to_non_nullable
              as PositivePostNavigationActiveButton,
      lastActiveButton: null == lastActiveButton
          ? _value.lastActiveButton
          : lastActiveButton // ignore: cast_nullable_to_non_nullable
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
      this.isProcessingMedia = false,
      this.isUploadingMedia = false,
      this.currentPostType = PostType.image,
      this.currentCreatePostPage = CreatePostCurrentPage.entry,
      this.isEditing = false,
      this.currentActivityID = '',
      final List<GalleryEntry> galleryEntries = const [],
      this.editingGalleryEntry,
      final List<String> tags = const [],
      this.promotionKey = '',
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
      this.reposterActivityID = '',
      required this.previousActivity,
      this.delayTimerCurrentSelection = 0,
      this.isDelayTimerEnabled = false,
      this.maximumClipDurationSelection = 0,
      this.isMaximumClipDurationEnabled = false,
      this.isBottomNavigationEnabled = true,
      this.isCreatingClip = false,
      required this.cameraWidgetKey,
      this.activeButton = PositivePostNavigationActiveButton.post,
      this.lastActiveButton = PositivePostNavigationActiveButton.post})
      : _galleryEntries = galleryEntries,
        _tags = tags;

  @override
  @JsonKey()
  final bool isBusy;
  @override
  @JsonKey()
  final bool isProcessingMedia;
  @override
  @JsonKey()
  final bool isUploadingMedia;
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
  final String promotionKey;
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
//? Repost
  @override
  @JsonKey()
  final String? reposterActivityID;
//? Editing
  @override
  final ActivityData previousActivity;
//? Clip delay and clip length options
  @override
  @JsonKey()
  final int delayTimerCurrentSelection;
  @override
  @JsonKey()
  final bool isDelayTimerEnabled;
  @override
  @JsonKey()
  final int maximumClipDurationSelection;
  @override
  @JsonKey()
  final bool isMaximumClipDurationEnabled;
  @override
  @JsonKey()
  final bool isBottomNavigationEnabled;
  @override
  @JsonKey()
  final bool isCreatingClip;
  @override
  final GlobalKey<PositiveCameraState> cameraWidgetKey;
  @override
  @JsonKey()
  final PositivePostNavigationActiveButton activeButton;
  @override
  @JsonKey()
  final PositivePostNavigationActiveButton lastActiveButton;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CreatePostViewModelState(isBusy: $isBusy, isProcessingMedia: $isProcessingMedia, isUploadingMedia: $isUploadingMedia, currentPostType: $currentPostType, currentCreatePostPage: $currentCreatePostPage, isEditing: $isEditing, currentActivityID: $currentActivityID, galleryEntries: $galleryEntries, editingGalleryEntry: $editingGalleryEntry, tags: $tags, promotionKey: $promotionKey, allowSharing: $allowSharing, visibleTo: $visibleTo, allowComments: $allowComments, activeButtonFlexText: $activeButtonFlexText, saveToGallery: $saveToGallery, currentFilter: $currentFilter, reposterActivityID: $reposterActivityID, previousActivity: $previousActivity, delayTimerCurrentSelection: $delayTimerCurrentSelection, isDelayTimerEnabled: $isDelayTimerEnabled, maximumClipDurationSelection: $maximumClipDurationSelection, isMaximumClipDurationEnabled: $isMaximumClipDurationEnabled, isBottomNavigationEnabled: $isBottomNavigationEnabled, isCreatingClip: $isCreatingClip, cameraWidgetKey: $cameraWidgetKey, activeButton: $activeButton, lastActiveButton: $lastActiveButton)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CreatePostViewModelState'))
      ..add(DiagnosticsProperty('isBusy', isBusy))
      ..add(DiagnosticsProperty('isProcessingMedia', isProcessingMedia))
      ..add(DiagnosticsProperty('isUploadingMedia', isUploadingMedia))
      ..add(DiagnosticsProperty('currentPostType', currentPostType))
      ..add(DiagnosticsProperty('currentCreatePostPage', currentCreatePostPage))
      ..add(DiagnosticsProperty('isEditing', isEditing))
      ..add(DiagnosticsProperty('currentActivityID', currentActivityID))
      ..add(DiagnosticsProperty('galleryEntries', galleryEntries))
      ..add(DiagnosticsProperty('editingGalleryEntry', editingGalleryEntry))
      ..add(DiagnosticsProperty('tags', tags))
      ..add(DiagnosticsProperty('promotionKey', promotionKey))
      ..add(DiagnosticsProperty('allowSharing', allowSharing))
      ..add(DiagnosticsProperty('visibleTo', visibleTo))
      ..add(DiagnosticsProperty('allowComments', allowComments))
      ..add(DiagnosticsProperty('activeButtonFlexText', activeButtonFlexText))
      ..add(DiagnosticsProperty('saveToGallery', saveToGallery))
      ..add(DiagnosticsProperty('currentFilter', currentFilter))
      ..add(DiagnosticsProperty('reposterActivityID', reposterActivityID))
      ..add(DiagnosticsProperty('previousActivity', previousActivity))
      ..add(DiagnosticsProperty(
          'delayTimerCurrentSelection', delayTimerCurrentSelection))
      ..add(DiagnosticsProperty('isDelayTimerEnabled', isDelayTimerEnabled))
      ..add(DiagnosticsProperty(
          'maximumClipDurationSelection', maximumClipDurationSelection))
      ..add(DiagnosticsProperty(
          'isMaximumClipDurationEnabled', isMaximumClipDurationEnabled))
      ..add(DiagnosticsProperty(
          'isBottomNavigationEnabled', isBottomNavigationEnabled))
      ..add(DiagnosticsProperty('isCreatingClip', isCreatingClip))
      ..add(DiagnosticsProperty('cameraWidgetKey', cameraWidgetKey))
      ..add(DiagnosticsProperty('activeButton', activeButton))
      ..add(DiagnosticsProperty('lastActiveButton', lastActiveButton));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostViewModelStateImpl &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.isProcessingMedia, isProcessingMedia) ||
                other.isProcessingMedia == isProcessingMedia) &&
            (identical(other.isUploadingMedia, isUploadingMedia) ||
                other.isUploadingMedia == isUploadingMedia) &&
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
            (identical(other.promotionKey, promotionKey) ||
                other.promotionKey == promotionKey) &&
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
            (identical(other.currentFilter, currentFilter) ||
                other.currentFilter == currentFilter) &&
            (identical(other.reposterActivityID, reposterActivityID) ||
                other.reposterActivityID == reposterActivityID) &&
            (identical(other.previousActivity, previousActivity) ||
                other.previousActivity == previousActivity) &&
            (identical(other.delayTimerCurrentSelection,
                    delayTimerCurrentSelection) ||
                other.delayTimerCurrentSelection ==
                    delayTimerCurrentSelection) &&
            (identical(other.isDelayTimerEnabled, isDelayTimerEnabled) ||
                other.isDelayTimerEnabled == isDelayTimerEnabled) &&
            (identical(other.maximumClipDurationSelection,
                    maximumClipDurationSelection) ||
                other.maximumClipDurationSelection ==
                    maximumClipDurationSelection) &&
            (identical(other.isMaximumClipDurationEnabled,
                    isMaximumClipDurationEnabled) ||
                other.isMaximumClipDurationEnabled ==
                    isMaximumClipDurationEnabled) &&
            (identical(other.isBottomNavigationEnabled, isBottomNavigationEnabled) ||
                other.isBottomNavigationEnabled == isBottomNavigationEnabled) &&
            (identical(other.isCreatingClip, isCreatingClip) ||
                other.isCreatingClip == isCreatingClip) &&
            (identical(other.cameraWidgetKey, cameraWidgetKey) ||
                other.cameraWidgetKey == cameraWidgetKey) &&
            (identical(other.activeButton, activeButton) ||
                other.activeButton == activeButton) &&
            (identical(other.lastActiveButton, lastActiveButton) ||
                other.lastActiveButton == lastActiveButton));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        isBusy,
        isProcessingMedia,
        isUploadingMedia,
        currentPostType,
        currentCreatePostPage,
        isEditing,
        currentActivityID,
        const DeepCollectionEquality().hash(_galleryEntries),
        editingGalleryEntry,
        const DeepCollectionEquality().hash(_tags),
        promotionKey,
        allowSharing,
        visibleTo,
        allowComments,
        activeButtonFlexText,
        saveToGallery,
        currentFilter,
        reposterActivityID,
        previousActivity,
        delayTimerCurrentSelection,
        isDelayTimerEnabled,
        maximumClipDurationSelection,
        isMaximumClipDurationEnabled,
        isBottomNavigationEnabled,
        isCreatingClip,
        cameraWidgetKey,
        activeButton,
        lastActiveButton
      ]);

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
          final bool isProcessingMedia,
          final bool isUploadingMedia,
          final PostType currentPostType,
          final CreatePostCurrentPage currentCreatePostPage,
          final bool isEditing,
          final String currentActivityID,
          final List<GalleryEntry> galleryEntries,
          final GalleryEntry? editingGalleryEntry,
          final List<String> tags,
          final String promotionKey,
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
          final String? reposterActivityID,
          required final ActivityData previousActivity,
          final int delayTimerCurrentSelection,
          final bool isDelayTimerEnabled,
          final int maximumClipDurationSelection,
          final bool isMaximumClipDurationEnabled,
          final bool isBottomNavigationEnabled,
          final bool isCreatingClip,
          required final GlobalKey<PositiveCameraState> cameraWidgetKey,
          final PositivePostNavigationActiveButton activeButton,
          final PositivePostNavigationActiveButton lastActiveButton}) =
      _$CreatePostViewModelStateImpl;

  @override
  bool get isBusy;
  @override
  bool get isProcessingMedia;
  @override
  bool get isUploadingMedia;
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
  String get promotionKey;
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
  @override //? Repost
  String? get reposterActivityID;
  @override //? Editing
  ActivityData get previousActivity;
  @override //? Clip delay and clip length options
  int get delayTimerCurrentSelection;
  @override
  bool get isDelayTimerEnabled;
  @override
  int get maximumClipDurationSelection;
  @override
  bool get isMaximumClipDurationEnabled;
  @override
  bool get isBottomNavigationEnabled;
  @override
  bool get isCreatingClip;
  @override
  GlobalKey<PositiveCameraState> get cameraWidgetKey;
  @override
  PositivePostNavigationActiveButton get activeButton;
  @override
  PositivePostNavigationActiveButton get lastActiveButton;
  @override
  @JsonKey(ignore: true)
  _$$CreatePostViewModelStateImplCopyWith<_$CreatePostViewModelStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
