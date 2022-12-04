// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'metadata.freezed.dart';
part 'metadata.g.dart';

@freezed
class Metadata with _$Metadata {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory Metadata({
    required String description,
    @Default('') required String mimeType,
    @Default(<String>[]) required List<String> tags,
  }) = _Metadata;

  factory Metadata.fromJson(Map<String, Object?> json) => _$MetadataFromJson(json);
}
