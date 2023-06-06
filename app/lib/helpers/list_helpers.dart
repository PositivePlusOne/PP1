// Flutter imports:
import 'package:flutter/material.dart';

List<Widget> addSeparatorsToWidgetList({required List<Widget> list, required Widget separator}) {
  final List<Widget> returnList = [];
  for (var i = 0; i < list.length; i++) {
    returnList.add(list[i]);
    if (i != list.length - 1) returnList.add(separator);
  }

  return returnList;
}
