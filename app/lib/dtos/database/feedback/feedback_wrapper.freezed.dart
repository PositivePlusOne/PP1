// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_wrapper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeedbackWrapper _$FeedbackWrapperFromJson(Map<String, dynamic> json) {
  return _FeedbackWrapper.fromJson(json);
}

/// @nodoc
mixin _$FeedbackWrapper {
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  @JsonKey(fromJson: FeedbackType.fromJson, toJson: FeedbackType.toJson)
  FeedbackType get feedbackType => throw _privateConstructorUsedError;
  @JsonKey(fromJson: ReportType.fromJson, toJson: ReportType.toJson)
  ReportType get reportType => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedbackWrapperCopyWith<FeedbackWrapper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackWrapperCopyWith<$Res> {
  factory $FeedbackWrapperCopyWith(
          FeedbackWrapper value, $Res Function(FeedbackWrapper) then) =
      _$FeedbackWrapperCopyWithImpl<$Res, FeedbackWrapper>;
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      @JsonKey(fromJson: FeedbackType.fromJson, toJson: FeedbackType.toJson)
      FeedbackType feedbackType,
      @JsonKey(fromJson: ReportType.fromJson, toJson: ReportType.toJson)
      ReportType reportType,
      String content});

  $FlMetaCopyWith<$Res>? get flMeta;
  $FeedbackTypeCopyWith<$Res> get feedbackType;
  $ReportTypeCopyWith<$Res> get reportType;
}

/// @nodoc
class _$FeedbackWrapperCopyWithImpl<$Res, $Val extends FeedbackWrapper>
    implements $FeedbackWrapperCopyWith<$Res> {
  _$FeedbackWrapperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? feedbackType = null,
    Object? reportType = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      feedbackType: null == feedbackType
          ? _value.feedbackType
          : feedbackType // ignore: cast_nullable_to_non_nullable
              as FeedbackType,
      reportType: null == reportType
          ? _value.reportType
          : reportType // ignore: cast_nullable_to_non_nullable
              as ReportType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FlMetaCopyWith<$Res>? get flMeta {
    if (_value.flMeta == null) {
      return null;
    }

    return $FlMetaCopyWith<$Res>(_value.flMeta!, (value) {
      return _then(_value.copyWith(flMeta: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FeedbackTypeCopyWith<$Res> get feedbackType {
    return $FeedbackTypeCopyWith<$Res>(_value.feedbackType, (value) {
      return _then(_value.copyWith(feedbackType: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ReportTypeCopyWith<$Res> get reportType {
    return $ReportTypeCopyWith<$Res>(_value.reportType, (value) {
      return _then(_value.copyWith(reportType: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FeedbackWrapperImplCopyWith<$Res>
    implements $FeedbackWrapperCopyWith<$Res> {
  factory _$$FeedbackWrapperImplCopyWith(_$FeedbackWrapperImpl value,
          $Res Function(_$FeedbackWrapperImpl) then) =
      __$$FeedbackWrapperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      @JsonKey(fromJson: FeedbackType.fromJson, toJson: FeedbackType.toJson)
      FeedbackType feedbackType,
      @JsonKey(fromJson: ReportType.fromJson, toJson: ReportType.toJson)
      ReportType reportType,
      String content});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
  @override
  $FeedbackTypeCopyWith<$Res> get feedbackType;
  @override
  $ReportTypeCopyWith<$Res> get reportType;
}

/// @nodoc
class __$$FeedbackWrapperImplCopyWithImpl<$Res>
    extends _$FeedbackWrapperCopyWithImpl<$Res, _$FeedbackWrapperImpl>
    implements _$$FeedbackWrapperImplCopyWith<$Res> {
  __$$FeedbackWrapperImplCopyWithImpl(
      _$FeedbackWrapperImpl _value, $Res Function(_$FeedbackWrapperImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? feedbackType = null,
    Object? reportType = null,
    Object? content = null,
  }) {
    return _then(_$FeedbackWrapperImpl(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      feedbackType: null == feedbackType
          ? _value.feedbackType
          : feedbackType // ignore: cast_nullable_to_non_nullable
              as FeedbackType,
      reportType: null == reportType
          ? _value.reportType
          : reportType // ignore: cast_nullable_to_non_nullable
              as ReportType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedbackWrapperImpl implements _FeedbackWrapper {
  const _$FeedbackWrapperImpl(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      @JsonKey(fromJson: FeedbackType.fromJson, toJson: FeedbackType.toJson)
      this.feedbackType = const FeedbackType.unknown(),
      @JsonKey(fromJson: ReportType.fromJson, toJson: ReportType.toJson)
      this.reportType = const ReportType.unknown(),
      this.content = ''});

  factory _$FeedbackWrapperImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedbackWrapperImplFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey(fromJson: FeedbackType.fromJson, toJson: FeedbackType.toJson)
  final FeedbackType feedbackType;
  @override
  @JsonKey(fromJson: ReportType.fromJson, toJson: ReportType.toJson)
  final ReportType reportType;
  @override
  @JsonKey()
  final String content;

  @override
  String toString() {
    return 'FeedbackWrapper(flMeta: $flMeta, feedbackType: $feedbackType, reportType: $reportType, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackWrapperImpl &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.feedbackType, feedbackType) ||
                other.feedbackType == feedbackType) &&
            (identical(other.reportType, reportType) ||
                other.reportType == reportType) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, flMeta, feedbackType, reportType, content);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackWrapperImplCopyWith<_$FeedbackWrapperImpl> get copyWith =>
      __$$FeedbackWrapperImplCopyWithImpl<_$FeedbackWrapperImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedbackWrapperImplToJson(
      this,
    );
  }
}

abstract class _FeedbackWrapper implements FeedbackWrapper {
  const factory _FeedbackWrapper(
      {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
      @JsonKey(fromJson: FeedbackType.fromJson, toJson: FeedbackType.toJson)
      final FeedbackType feedbackType,
      @JsonKey(fromJson: ReportType.fromJson, toJson: ReportType.toJson)
      final ReportType reportType,
      final String content}) = _$FeedbackWrapperImpl;

  factory _FeedbackWrapper.fromJson(Map<String, dynamic> json) =
      _$FeedbackWrapperImpl.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  @JsonKey(fromJson: FeedbackType.fromJson, toJson: FeedbackType.toJson)
  FeedbackType get feedbackType;
  @override
  @JsonKey(fromJson: ReportType.fromJson, toJson: ReportType.toJson)
  ReportType get reportType;
  @override
  String get content;
  @override
  @JsonKey(ignore: true)
  _$$FeedbackWrapperImplCopyWith<_$FeedbackWrapperImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
