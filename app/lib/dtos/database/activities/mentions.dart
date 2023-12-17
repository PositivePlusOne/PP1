// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/json_extensions.dart';

part 'mentions.freezed.dart';
part 'mentions.g.dart';

@freezed
class Mention with _$Mention {
  const factory Mention({
    @Default(-1) int startIndex,
    @Default(-1) int endIndex,
    @Default('') String displayName,
    @Default('') String foreignKey,
    @Default('') String schema,
  }) = _Mention;

  factory Mention.fromJson(Map<String, dynamic> json) => _$MentionFromJson(json);

  static Mention fromForeignKey(String foreignKey, String schema) {
    return Mention(
      foreignKey: foreignKey.asHandle,
      schema: schema,
    );
  }

  static List<Mention> fromJsonList(List<dynamic> data) {
    return data.map((e) => Mention.fromJson(json.decodeSafe(e))).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Mention> data) {
    return data.map((e) => e.toJson()).toList();
  }
}
