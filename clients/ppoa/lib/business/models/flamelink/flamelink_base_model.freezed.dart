// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'flamelink_base_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FlamelinkBaseModel _$FlamelinkBaseModelFromJson(Map<String, dynamic> json) {
  return _FlamelinkBaseModel.fromJson(json);
}

/// @nodoc
mixin _$FlamelinkBaseModel {
  @JsonKey(name: '_fl_meta_')
  FlamelinkMeta get metadata => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  int get parentId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FlamelinkBaseModelCopyWith<FlamelinkBaseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlamelinkBaseModelCopyWith<$Res> {
  factory $FlamelinkBaseModelCopyWith(
          FlamelinkBaseModel value, $Res Function(FlamelinkBaseModel) then) =
      _$FlamelinkBaseModelCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlamelinkMeta metadata,
      String id,
      int order,
      int parentId});

  $FlamelinkMetaCopyWith<$Res> get metadata;
}

/// @nodoc
class _$FlamelinkBaseModelCopyWithImpl<$Res>
    implements $FlamelinkBaseModelCopyWith<$Res> {
  _$FlamelinkBaseModelCopyWithImpl(this._value, this._then);

  final FlamelinkBaseModel _value;
  // ignore: unused_field
  final $Res Function(FlamelinkBaseModel) _then;

  @override
  $Res call({
    Object? metadata = freezed,
    Object? id = freezed,
    Object? order = freezed,
    Object? parentId = freezed,
  }) {
    return _then(_value.copyWith(
      metadata: metadata == freezed
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as FlamelinkMeta,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      order: order == freezed
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: parentId == freezed
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  @override
  $FlamelinkMetaCopyWith<$Res> get metadata {
    return $FlamelinkMetaCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value));
    });
  }
}

/// @nodoc
abstract class _$$_FlamelinkBaseModelCopyWith<$Res>
    implements $FlamelinkBaseModelCopyWith<$Res> {
  factory _$$_FlamelinkBaseModelCopyWith(_$_FlamelinkBaseModel value,
          $Res Function(_$_FlamelinkBaseModel) then) =
      __$$_FlamelinkBaseModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlamelinkMeta metadata,
      String id,
      int order,
      int parentId});

  @override
  $FlamelinkMetaCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$_FlamelinkBaseModelCopyWithImpl<$Res>
    extends _$FlamelinkBaseModelCopyWithImpl<$Res>
    implements _$$_FlamelinkBaseModelCopyWith<$Res> {
  __$$_FlamelinkBaseModelCopyWithImpl(
      _$_FlamelinkBaseModel _value, $Res Function(_$_FlamelinkBaseModel) _then)
      : super(_value, (v) => _then(v as _$_FlamelinkBaseModel));

  @override
  _$_FlamelinkBaseModel get _value => super._value as _$_FlamelinkBaseModel;

  @override
  $Res call({
    Object? metadata = freezed,
    Object? id = freezed,
    Object? order = freezed,
    Object? parentId = freezed,
  }) {
    return _then(_$_FlamelinkBaseModel(
      metadata: metadata == freezed
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as FlamelinkMeta,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      order: order == freezed
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: parentId == freezed
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_FlamelinkBaseModel implements _FlamelinkBaseModel {
  const _$_FlamelinkBaseModel(
      {@JsonKey(name: '_fl_meta_') required this.metadata,
      required this.id,
      required this.order,
      required this.parentId});

  factory _$_FlamelinkBaseModel.fromJson(Map<String, dynamic> json) =>
      _$$_FlamelinkBaseModelFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlamelinkMeta metadata;
  @override
  final String id;
  @override
  final int order;
  @override
  final int parentId;

  @override
  String toString() {
    return 'FlamelinkBaseModel(metadata: $metadata, id: $id, order: $order, parentId: $parentId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FlamelinkBaseModel &&
            const DeepCollectionEquality().equals(other.metadata, metadata) &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.order, order) &&
            const DeepCollectionEquality().equals(other.parentId, parentId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(metadata),
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(order),
      const DeepCollectionEquality().hash(parentId));

  @JsonKey(ignore: true)
  @override
  _$$_FlamelinkBaseModelCopyWith<_$_FlamelinkBaseModel> get copyWith =>
      __$$_FlamelinkBaseModelCopyWithImpl<_$_FlamelinkBaseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FlamelinkBaseModelToJson(
      this,
    );
  }
}

abstract class _FlamelinkBaseModel implements FlamelinkBaseModel {
  const factory _FlamelinkBaseModel(
      {@JsonKey(name: '_fl_meta_') required final FlamelinkMeta metadata,
      required final String id,
      required final int order,
      required final int parentId}) = _$_FlamelinkBaseModel;

  factory _FlamelinkBaseModel.fromJson(Map<String, dynamic> json) =
      _$_FlamelinkBaseModel.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlamelinkMeta get metadata;
  @override
  String get id;
  @override
  int get order;
  @override
  int get parentId;
  @override
  @JsonKey(ignore: true)
  _$$_FlamelinkBaseModelCopyWith<_$_FlamelinkBaseModel> get copyWith =>
      throw _privateConstructorUsedError;
}
