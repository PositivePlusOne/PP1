// Dart imports:
import 'dart:convert';

extension JsonExtensions on JsonCodec {
  // Safely decodes a map, returning an empty map if the input is null
  Map<String, Object?> decodeSafe(String? input) {
    if (input == null || input.isEmpty) {
      return {};
    }

    try {
      return decode(input) as Map<String, Object?>;
    } catch (ex) {
      return {};
    }
  }
}
