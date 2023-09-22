// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/converters/date_converters.dart';
import 'package:app/dtos/converters/firestore_converters.dart';
import 'package:app/dtos/database/common/fl_meta.dart';
import 'package:app/extensions/json_extensions.dart';

part 'promotions.freezed.dart';
part 'promotions.g.dart';

@freezed
class Promotion with _$Promotion {
  const factory Promotion({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default('') String title,
    @Default('') String descriptionMarkdown,
    @Default('') String link,
    @Default('') String linkText,
    @Default(null) @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson) DocumentReference? owner,
    @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown) String? startTime,
    @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown) String? endTime,
  }) = _Promotion;

  factory Promotion.fromJson(Map<String, dynamic> json) => _$PromotionFromJson(json);

  static List<Promotion> fromJsonList(List<dynamic> data) {
    return data.map((e) => Promotion.fromJson(json.decodeSafe(e))).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Promotion> data) {
    return data.map((e) => e.toJson()).toList();
  }
}
