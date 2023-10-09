// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../common/fl_meta.dart';

part 'tags.freezed.dart';
part 'tags.g.dart';

@freezed
class Tag with _$Tag {
  const factory Tag({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default('') String key,
    @Default('') String fallback,
    @Default(-1) int popularity,
    @Default(false) bool promoted,
    @Default([]) @JsonKey(fromJson: TagLocalization.fromJsonLocalizations, toJson: TagLocalization.toJsonLocalizations) List<TagLocalization> localizations,
    TagTopic? topic,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  static List<Tag> fromJsonList(List<dynamic> json) => json.map((e) => Tag.fromJson(e)).toList();
}

@freezed
class TagLocalization with _$TagLocalization {
  const factory TagLocalization({
    @Default('') String locale,
    @Default('') String value,
  }) = _TagLocalization;

  static List<TagLocalization> fromJsonLocalizations(dynamic json) {
    if (json is! Iterable || json.isEmpty) {
      return [];
    }

    return json.map((e) => TagLocalization.fromJson(e)).toList();
  }

  static String toJsonLocalizations(List<TagLocalization> localizations) {
    return jsonEncode(localizations.map((e) => e.toJson()).toList());
  }

  static TagLocalization fromJsonSafe(Map json) {
    if (json.isEmpty) {
      return const TagLocalization();
    }

    return TagLocalization.fromJson(json as Map<String, dynamic>);
  }

  factory TagLocalization.fromJson(Map<String, dynamic> json) => _$TagLocalizationFromJson(json);
}

@freezed
class TagTopic with _$TagTopic {
  const factory TagTopic({
    @Default('') String fallback,
    @Default([]) @JsonKey(fromJson: TagLocalization.fromJsonLocalizations, toJson: TagLocalization.toJsonLocalizations) List<TagLocalization> localizations,
    @Default(false) bool isEnabled,
  }) = _TagTopic;

  factory TagTopic.fromJson(Map<String, dynamic> json) => _$TagTopicFromJson(json);
  factory TagTopic.empty() => const TagTopic();

  static List<TagTopic> fromJsonList(dynamic json) {
    if (json is! Iterable || json.isEmpty) {
      return [];
    }

    return json.map((e) => TagTopic.fromJson(e)).toList();
  }
}

class TagHelpers {
  static const String _kPromotedKey = 'promoted';
  static const String _kFallbackKey = 'fallback';
  static const String _kKeyKey = 'key';
  // helper to create the tags that should be appended when an activity is promoted
  static List<String> createPromotedTags({required String userId}) => [createPromotedTag(), createPromotedTag(userId: userId)];

  /// helper to create the tag to be in the list of tags to show an activity is promoted
  static String createPromotedTag({String? userId}) => '$_kPromotedKey${userId == null ? '' : '-$userId'}';

  /// helper to determine if a tag (as a string) represents an activity that is promoted
  static bool isPromoted(String tag) => tag.startsWith(_kPromotedKey);

  static String getTagLocalizedName(Tag tag, Locale locale) {
    if (tag.localizations.any((TagLocalization localization) => localization.locale == locale.languageCode)) {
      return tag.localizations.firstWhere((TagLocalization localization) => localization.locale == locale.languageCode).value;
    }

    return tag.fallback;
  }

  static bool matches(Tag tag, Map<String, dynamic> map) {
    if (tag.key != map[_kKeyKey]) {
      return false;
    }

    if (tag.fallback != map[_kFallbackKey]) {
      return false;
    }

    if (tag.promoted != map[_kPromotedKey]) {
      return false;
    }

    // Check if all of the localizations match
    for (var localization in tag.localizations) {
      if (!map.containsKey(localization.locale) || map[localization.locale] != localization.value) {
        return false;
      }
    }

    return true;
  }
}
