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
    @Default([]) @JsonKey(fromJson: GuidanceDirectoryEntryService.listFromJson, toJson: GuidanceDirectoryEntryService.listToJson) List<GuidanceDirectoryEntryService> services,
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

@freezed
class GuidanceDirectoryEntryService with _$GuidanceDirectoryEntryService {
  const factory GuidanceDirectoryEntryService.hivSupport() = _GuidanceDirectoryEntryServiceHivSupport;
  const factory GuidanceDirectoryEntryService.counselling() = _GuidanceDirectoryEntryServiceCounselling;
  const factory GuidanceDirectoryEntryService.financialAdvice() = _GuidanceDirectoryEntryServiceFinancialAdvice;
  const factory GuidanceDirectoryEntryService.testing() = _GuidanceDirectoryEntryServiceTesting;
  const factory GuidanceDirectoryEntryService.sexualHealth() = _GuidanceDirectoryEntryServiceSexualHealth;
  const factory GuidanceDirectoryEntryService.unknown() = _GuidanceDirectoryEntryServiceUnknown;

  static String toJson(GuidanceDirectoryEntryService mode) {
    try {
      return mode.when(
        hivSupport: () => 'hiv_support',
        counselling: () => 'counselling',
        financialAdvice: () => 'financial_advice',
        testing: () => 'testing',
        sexualHealth: () => 'sexual_health',
        unknown: () => 'unknown',
      );
    } catch (e) {
      return 'unknown';
    }
  }

  static String asLocale(GuidanceDirectoryEntryService mode) {
    try {
      return mode.when(
        hivSupport: () => 'HIV Support',
        counselling: () => 'Counselling',
        financialAdvice: () => 'Financial Advice',
        testing: () => 'Testing',
        sexualHealth: () => 'Sexual Health',
        unknown: () => 'Unknown',
      );
    } catch (e) {
      return 'Unknown';
    }
  }

  static List<GuidanceDirectoryEntryService> listFromJson(List<dynamic> json) {
    return json.map((e) => GuidanceDirectoryEntryService.fromJson(e as String)).toList();
  }

  static List<String> listToJson(List<GuidanceDirectoryEntryService> modes) {
    return modes.map((e) => GuidanceDirectoryEntryService.toJson(e)).toList();
  }

  factory GuidanceDirectoryEntryService.fromJson(String value) {
    switch (value) {
      case 'hiv_support':
        return const GuidanceDirectoryEntryService.hivSupport();
      case 'counselling':
        return const GuidanceDirectoryEntryService.counselling();
      case 'financial_advice':
        return const GuidanceDirectoryEntryService.financialAdvice();
      case 'testing':
        return const GuidanceDirectoryEntryService.testing();
      case 'sexual_health':
        return const GuidanceDirectoryEntryService.sexualHealth();
      default:
        return const GuidanceDirectoryEntryService.unknown();
    }
  }
}
