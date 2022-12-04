// Flutter imports:
import 'package:flutter/material.dart';

TextStyle textStyleFromJson(Map<String, dynamic> json) {
  return TextStyle(
    fontFamily: json['fontFamily'],
    fontSize: json['fontSize'],
    fontWeight: json['fontWeight'],
  );
}

Map<String, dynamic> textStyleToJson(TextStyle object) {
  return <String, dynamic>{
    'fontFamily': object.fontFamily,
    'fontSize': object.fontSize,
    'fontWeight': object.fontWeight,
  };
}
