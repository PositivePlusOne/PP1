// Package imports:
import 'package:flutter/services.dart';

FilteringTextInputFormatter removeDuplicateWhitespaceFormatter() {
  return FilteringTextInputFormatter.deny(RegExp(r'(?<=\n{2,}[ ]{0,}.{0,1})\n'));
}

FilteringTextInputFormatter removeNumbersFormatter() {
  return FilteringTextInputFormatter.deny(RegExp(r'[1-9]'));
}
