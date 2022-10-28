final RegExp _hexcolor = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

/// check if the string [str] is a hexadecimal color
bool isHexColor(String str) {
  return _hexcolor.hasMatch(str);
}
