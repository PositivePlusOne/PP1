// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:algolia/algolia.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';

part 'guidance_article.freezed.dart';
part 'guidance_article.g.dart';

@freezed
class GuidanceArticle with _$GuidanceArticle {
  const factory GuidanceArticle({
    @JsonKey(name: 'id') required String documentId,
    @Default('') String title,
    @Default('') String body,
    @Default('en') String locale,
    @Default(0) int priority,
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
  }) = _GuidanceArticle;

  factory GuidanceArticle.empty() => const GuidanceArticle(documentId: "");
  factory GuidanceArticle.fromJson(Map<String, Object?> json) => _$GuidanceArticleFromJson(json);

  static List<GuidanceArticle> decodeGuidanceArticleList(dynamic jsonData) {
    final List<dynamic> jsonList = json.decode(jsonData);
    final List<GuidanceArticle> articles = jsonList.map((json) => GuidanceArticle.fromJson(json)).toList();
    articles.sort((a, b) => a.priority.compareTo(b.priority));

    return articles;
  }

  static List<GuidanceArticle> listFromAlgoliaSnap(List<AlgoliaObjectSnapshot> snap) {
    final List<GuidanceArticle> entries = snap.map((e) => GuidanceArticle.fromJson(e.data)).toList();
    entries.sort((a, b) => a.priority.compareTo(b.priority));

    return entries;
  }
}
