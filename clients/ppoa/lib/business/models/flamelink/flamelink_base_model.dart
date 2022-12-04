// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'flamelink_meta.dart';

part 'flamelink_base_model.freezed.dart';
part 'flamelink_base_model.g.dart';

@freezed
class FlamelinkBaseModel with _$FlamelinkBaseModel {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory FlamelinkBaseModel({
    @JsonKey(name: '_fl_meta_') required FlamelinkMeta metadata,
    required String id,
    required int order,
    required int parentId,
  }) = _FlamelinkBaseModel;

  factory FlamelinkBaseModel.fromJson(Map<String, Object?> json) => _$FlamelinkBaseModelFromJson(json);
}
