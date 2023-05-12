// Dart imports:
import 'dart:convert';

extension JsonExtensions on JsonCodec {
  // Safely decodes a map, returning an empty map if the input is null
  Map<String, Object?> decodeSafe(dynamic input) {
    if (input == null || input.isEmpty) {
      return {};
    }

    if (input is Map<String, Object?>) {
      return input;
    }

    try {
      return decode(input.toString()) as Map<String, Object?>;
    } catch (ex) {
      return {};
    }
  }
}
