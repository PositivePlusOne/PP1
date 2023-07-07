// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:algolia/algolia.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';

part 'guidance_directory_entry.freezed.dart';
part 'guidance_directory_entry.g.dart';

@freezed
class GuidanceDirectoryEntry with _$GuidanceDirectoryEntry {
  const factory GuidanceDirectoryEntry({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @JsonKey(name: 'id') required String documentId,
    @Default('') String title,
    @Default('') String blurb,
    @Default('') String body,
    @Default('') String websiteUrl,
    @Default('') String logoUrl,
    @Default('') String profile,
    @Default([]) List<String> services,
  }) = _GuidanceDirectoryEntry;

  factory GuidanceDirectoryEntry.empty() => const GuidanceDirectoryEntry(documentId: "");
  factory GuidanceDirectoryEntry.fromJson(Map<String, Object?> json) => _$GuidanceDirectoryEntryFromJson(json);

  static List<GuidanceDirectoryEntry> decodeGuidanceArticleList(dynamic jsonData) {
    final List<dynamic> jsonList = json.decode(jsonData);
    return jsonList.map((json) => GuidanceDirectoryEntry.fromJson(json)).toList();
  }

  static List<GuidanceDirectoryEntry> listFromAlgoliaSnap(List<AlgoliaObjectSnapshot> snap) {
    return snap.map((e) => GuidanceDirectoryEntry.fromJson(e.data)).toList();
  }
}
