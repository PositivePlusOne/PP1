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
      if (input is String) {
        return decode(input) as Map<String, Object?>;
      }

      final reencoded = encode(input);
      final decoded = decode(reencoded) as Map<String, Object?>;
      return decoded;
    } catch (ex) {
      return {};
    }
  }
}
