// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fl_meta.freezed.dart';
part 'fl_meta.g.dart';

@freezed
class FlMeta with _$FlMeta {
  const factory FlMeta({
    String? createdBy,
    String? createdDate,
    String? docId,
    @JsonKey(name: 'fl_id') String? id,
    @Default('') String? env,
    @Default('en') String? locale,
    @Default('') String? schema,
    String? schemaRefId,
    String? updatedBy,
    String? updatedDate,
  }) = _FlMeta;

  factory FlMeta.fromJson(Map<String, dynamic> json) => _$FlMetaFromJson(json);
}
