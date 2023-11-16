// Flutter imports:
import 'package:flutter/services.dart';

//? Universal input formatter to prevent successive new lines
FilteringTextInputFormatter removeDuplicateWhitespaceFormatter() {
  return FilteringTextInputFormatter.deny(RegExp(r'(?<=\n{2,}[ ]{0,}.{0,1})\n'));
}

//? Universal input formatter to remove numbers
FilteringTextInputFormatter removeNumbersFormatter() {
  return FilteringTextInputFormatter.deny(RegExp(r'[0-9]'));
}
