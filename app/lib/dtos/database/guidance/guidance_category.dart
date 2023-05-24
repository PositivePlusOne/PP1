// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:algolia/algolia.dart';
import 'package:app/dtos/database/common/fl_meta.dart';
// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'guidance_category.freezed.dart';
part 'guidance_category.g.dart';

@freezed
class GuidanceCategory with _$GuidanceCategory {
  const factory GuidanceCategory({
    @JsonKey(name: 'id') required String documentId,
    @Default('') String title,
    @Default('') String body,
    @Default('en') String locale,
    @Default(null) Map<String, dynamic>? parent,
    @Default(0) int priority,
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
  }) = _GuidanceCategory;

  factory GuidanceCategory.empty() => const GuidanceCategory(documentId: "");
  factory GuidanceCategory.fromJson(Map<String, Object?> json) => _$GuidanceCategoryFromJson(json);

  static List<GuidanceCategory> decodeGuidanceCategoryList(dynamic jsonData) {
    final List<dynamic> jsonList = json.decode(jsonData);
    return jsonList.map((json) => GuidanceCategory.fromJson(json)).toList();
  }

  static List<GuidanceCategory> listFromAlgoliaSnap(List<AlgoliaObjectSnapshot> snap) {
    return snap.map((e) => GuidanceCategory.fromJson(e.data)).toList();
  }
}
