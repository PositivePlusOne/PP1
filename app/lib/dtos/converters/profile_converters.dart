List<String> stringListFromJson(dynamic json) {
  if (json == null || json is! List) {
    return <String>[];
  }

  return json.map((e) => e.toString()).toList();
}
