// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/converters/firestore_converters.dart';
import 'package:app/dtos/database/common/fl_meta.dart';

part 'bookmark.freezed.dart';
part 'bookmark.g.dart';

@freezed
class Bookmark with _$Bookmark {
  const factory Bookmark({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default(null) @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson) DocumentReference? profile,
    @Default(null) @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson) DocumentReference? activity,
    @Default(BookmarkType.post()) @JsonKey(fromJson: BookmarkType.fromJson, toJson: BookmarkType.toJson) BookmarkType type,
  }) = _Bookmark;

  factory Bookmark.empty() => const Bookmark();
  factory Bookmark.fromJson(Map<String, Object?> json) => _$BookmarkFromJson(json);

  static List<Bookmark> decodeBookmarkList(dynamic jsonData) {
    final List<dynamic> jsonList = json.decode(jsonData);
    return jsonList.map((json) => Bookmark.fromJson(json)).toList();
  }
}

@freezed
class BookmarkType with _$BookmarkType {
  const factory BookmarkType.post() = _BookmarkTypePost;
  const factory BookmarkType.event() = _BookmarkTypeEvent;
  const factory BookmarkType.clip() = _BookmarkTypeClip;

  static String toJson(BookmarkType type) {
    return type.when(
      post: () => 'post',
      event: () => 'event',
      clip: () => 'clip',
    );
  }

  factory BookmarkType.fromJson(String value) {
    switch (value) {
      case 'post':
        return const _BookmarkTypePost();
      case 'event':
        return const _BookmarkTypeEvent();
      case 'clip':
        return const _BookmarkTypeClip();
      default:
        throw ArgumentError('Invalid value for BookmarkType: $value');
    }
  }
}
