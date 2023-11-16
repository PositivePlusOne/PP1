int convertStringToUniqueInt(String string) {
  int result = 0;
  for (int i = 0; i < string.length; i++) {
    result += string.codeUnitAt(i);
  }

  return result;
}
