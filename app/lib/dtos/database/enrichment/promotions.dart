// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/converters/date_converters.dart';
import 'package:app/dtos/database/common/fl_meta.dart';
import 'package:app/extensions/json_extensions.dart';

part 'promotions.freezed.dart';
part 'promotions.g.dart';

@freezed
class Promotion with _$Promotion {
  const factory Promotion({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default('') String title,
    @Default('') String link,
    @Default('') String linkText,
    @Default([]) List<PromotionOwner> owners,
    @Default([]) List<PromotedActivity> activities,
    @Default(false) bool isActive,
    @Default(0) int totalViewsSinceLastUpdate,
    @Default(0) int totalViewsAllotment,
  }) = _Promotion;

  factory Promotion.fromJson(Map<String, dynamic> json) => _$PromotionFromJson(json);

  static List<Promotion> fromJsonList(List<dynamic> data) {
    return data.map((e) => Promotion.fromJson(json.decodeSafe(e))).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Promotion> data) {
    return data.map((e) => e.toJson()).toList();
  }
}

@freezed
class PromotionOwner with _$PromotionOwner {
  const factory PromotionOwner({
    @Default('') String activityId,
  }) = _PromotionOwner;

  factory PromotionOwner.fromJson(Map<String, dynamic> json) => _$PromotionOwnerFromJson(json);

  static List<PromotionOwner> fromJsonList(List<dynamic> data) {
    return data.map((e) => PromotionOwner.fromJson(json.decodeSafe(e))).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<PromotionOwner> data) {
    return data.map((e) => e.toJson()).toList();
  }
}

@freezed
class PromotedActivity with _$PromotedActivity {
  const factory PromotedActivity({
    @Default('') String activityId,
  }) = _PromotedActivity;

  factory PromotedActivity.fromJson(Map<String, dynamic> json) => _$PromotedActivityFromJson(json);

  static List<PromotedActivity> fromJsonList(List<dynamic> data) {
    return data.map((e) => PromotedActivity.fromJson(json.decodeSafe(e))).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<PromotedActivity> data) {
    return data.map((e) => e.toJson()).toList();
  }
}
