// ignore_for_file: non_constant_identifier_names

// Dart imports:
import 'dart:async';
import 'dart:isolate';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:image/image.dart' as img;

class FilterHelpers {
  Isolate? photoFilterIsolate;

  static Future<Uint8List> applyFilter({
    required Uint8List data,
    required AwesomeFilter filter,
  }) async {
    if (filter.name == 'none') {
      return data;
    }

    final payload = (Uint8List: data, Filter: filter);
    final Uint8List result = await compute(_applyFilter, payload);

    return result;
  }

  static FutureOr<Uint8List> _applyFilter(({AwesomeFilter Filter, Uint8List Uint8List}) message) async {
    var bytes = message.Uint8List;

    final img.Image image = img.decodeImage(bytes)!;
    final filter = message.Filter;

    final pixels = image.getBytes();
    filter.output.apply(pixels, image.width, image.height);

    final img.Image out = img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: pixels.buffer,
    );

    bytes = img.encodeJpg(out, quality: 100);

    return bytes;
  }
}
