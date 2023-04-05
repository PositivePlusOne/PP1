// Package imports:
import 'package:collection/collection.dart';

enum PositiveFeatureFlag {
  incognitoMode,
  marketingEmails;

  static PositiveFeatureFlag? fromString(String? value) {
    if (value == null) {
      return null;
    }

    return PositiveFeatureFlag.values.firstWhereOrNull((element) => element.name == value);
  }

  static List<PositiveFeatureFlag> fromStringList(List<String> values) {
    return values.map((e) => PositiveFeatureFlag.fromString(e)!).toList();
  }

  static List<String> toStringList(List<PositiveFeatureFlag> values) {
    return values.map((e) => e.toString()).toList();
  }
}
