// Flutter imports:
import 'package:flutter/material.dart';

final Map<Alignment, String> kAlignmentStringsMap = <Alignment, String>{
  Alignment.bottomCenter: 'bottomCenter',
  Alignment.bottomLeft: 'bottomLeft',
  Alignment.bottomRight: 'bottomRight',
  Alignment.center: 'center',
  Alignment.centerLeft: 'centerLeft',
  Alignment.centerRight: 'centerRight',
  Alignment.topCenter: 'topCenter',
  Alignment.topLeft: 'topLeft',
  Alignment.topRight: 'topRight',
};

Alignment alignmentFromJson(String alignment) {
  for (final Alignment key in kAlignmentStringsMap.keys) {
    if (kAlignmentStringsMap[key] == alignment) {
      return key;
    }
  }

  return Alignment.center;
}

String alignmentToJson(Alignment object) {
  if (kAlignmentStringsMap.containsKey(object)) {
    return kAlignmentStringsMap[object]!;
  }

  return '';
}
