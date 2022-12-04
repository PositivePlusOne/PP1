// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../../converters/reference_converter.dart';
import '../../converters/timestamp_converter.dart';

part 'flamelink_meta.freezed.dart';
part 'flamelink_meta.g.dart';

@freezed
class FlamelinkMeta with _$FlamelinkMeta {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory FlamelinkMeta({
    required String createdBy,
    @JsonKey(fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson) required Timestamp timestamp,
    @JsonKey(name: 'docId') required String documentId,
    @JsonKey(name: 'fl_id') required String flamelinkId,
    @JsonKey(name: 'env') required String environment,
    required String lastModifiedBy,
    @JsonKey(fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson) required Timestamp lastModifiedDate,
    required String schema,
    @JsonKey(name: 'schemaRef', toJson: firestoreDocRefToJson, fromJson: firestoreDocRefFromJson) required DocumentReference schemaReference,
    required String schemaType,
    required String status,
  }) = _FlamelinkMeta;

  factory FlamelinkMeta.fromJson(Map<String, Object?> json) => _$FlamelinkMetaFromJson(json);
}
