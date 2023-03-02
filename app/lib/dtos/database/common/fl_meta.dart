// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fl_meta.freezed.dart';
part 'fl_meta.g.dart';

@freezed
class FlMeta with _$FlMeta {
  const factory FlMeta({
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_date') String? createdDate,
    @JsonKey(name: 'doc_id') String? docId,
    String? env,
    String? locale,
    String? schema,
    @JsonKey(name: 'schema_ref_id') String? schemaRefId,
    @JsonKey(name: 'updated_by') String? updatedBy,
    @JsonKey(name: 'updated_date') String? updatedDate,
  }) = _FlMeta;

  factory FlMeta.fromJson(Map<String, dynamic> json) => _$FlMetaFromJson(json);
}
