import 'package:flutter/material.dart';

@override
TextStyle textStyleFromJson(Map<String, dynamic> json) {
  return TextStyle(
    fontFamily: json['fontFamily'],
    fontSize: json['fontSize'],
    fontWeight: json['fontWeight'],
  );
}

@override
Map<String, dynamic> textStyleToJson(TextStyle object) {
  return <String, dynamic>{
    'fontFamily': object.fontFamily,
    'fontSize': object.fontSize,
    'fontWeight': object.fontWeight,
  };
}
