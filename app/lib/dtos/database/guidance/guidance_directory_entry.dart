// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';
// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'guidance_directory_entry.freezed.dart';
part 'guidance_directory_entry.g.dart';

@freezed
class GuidanceDirectoryEntry with _$GuidanceDirectoryEntry {
  const factory GuidanceDirectoryEntry({
    @JsonKey(name: 'id') required String documentId,
    @Default('') String title,
    @Default('') String blurb,
    @Default('') String body,
    @Default('') String logoUrl,
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
  }) = _GuidanceDirectoryEntry;

  factory GuidanceDirectoryEntry.empty() => const GuidanceDirectoryEntry(documentId: "");
  factory GuidanceDirectoryEntry.fromJson(Map<String, Object?> json) => _$GuidanceDirectoryEntryFromJson(json);

  static List<GuidanceDirectoryEntry> decodeGuidanceArticleList(dynamic jsonData) {
    final List<dynamic> jsonList = json.decode(jsonData);
    return jsonList.map((json) => GuidanceDirectoryEntry.fromJson(json)).toList();
  }
}
