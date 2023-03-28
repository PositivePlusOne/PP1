List<String> stringListFromJson(List<dynamic>? json) {
  if (json == null) {
    return <String>[];
  }

  return json.map((e) => e.toString()).toList();
}
