// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/converters/firestore_converters.dart';
import 'package:app/dtos/database/common/fl_meta.dart';
import 'package:app/dtos/database/geo/positive_place.dart';

part 'guidance_directory_entry.freezed.dart';
part 'guidance_directory_entry.g.dart';

@freezed
class GuidanceDirectoryEntry with _$GuidanceDirectoryEntry {
  const factory GuidanceDirectoryEntry({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default('') String title,
    @Default('') String description,
    @Default('') String markdown,
    PositivePlace? place,
    @Default('') String websiteUrl,
    @Default('') String logoUrl,
    @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson) DocumentReference? profile,
    @Default([]) List<String> services,
  }) = _GuidanceDirectoryEntry;

  factory GuidanceDirectoryEntry.empty() => const GuidanceDirectoryEntry();
  factory GuidanceDirectoryEntry.fromJson(Map<String, Object?> json) => _$GuidanceDirectoryEntryFromJson(json);

  static List<GuidanceDirectoryEntry> decodeGuidanceArticleList(dynamic jsonData) {
    final List<dynamic> jsonList = json.decode(jsonData);
    return jsonList.map((json) => GuidanceDirectoryEntry.fromJson(json)).toList();
  }

  static List<GuidanceDirectoryEntry> listFromAlgoliaSnap(List<AlgoliaObjectSnapshot> snap) {
    return snap.map((e) => GuidanceDirectoryEntry.fromJson(e.data)).toList();
  }
}
