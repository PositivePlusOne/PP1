// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/converters/firestore_converters.dart';
import 'package:app/dtos/database/common/fl_meta.dart';

part 'guidance_category.freezed.dart';
part 'guidance_category.g.dart';

@freezed
class GuidanceCategory with _$GuidanceCategory {
  const factory GuidanceCategory({
    @JsonKey(name: 'id') required String documentId,
    @Default('') String title,
    @Default('') String body,
    @Default('en') String locale,
    @Default(null) @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson) DocumentReference? parent,
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
