// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/converters/date_converters.dart';

part 'fl_meta.freezed.dart';
part 'fl_meta.g.dart';

@freezed
class FlMeta with _$FlMeta {
  const factory FlMeta({
    String? createdBy,
    @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown) String? createdDate,
    String? ownedBy,
    @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown) String? ownedAsOfDate,
    @Default('') String directoryEntryId,
    String? lastModifiedBy,
    @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown) String? lastModifiedDate,
    @Default(-1) int lastFetchMillis,
    @Default(false) bool isPartial,
    String? docId,
    @JsonKey(name: 'fl_id') String? id,
    @Default('') String? env,
    @Default('en') String? locale,
    @Default('') String? schema,
    String? schemaRefId,
  }) = _FlMeta;

  factory FlMeta.empty(String id, String schema) => FlMeta(
        id: id,
        schema: schema,
      );

  factory FlMeta.fromJson(Map<String, dynamic> json) => _$FlMetaFromJson(json);
}
