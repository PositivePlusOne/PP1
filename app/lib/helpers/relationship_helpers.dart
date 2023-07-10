String buildRelationshipIdentifier(List<String> members) {
  // Sorts the list, and then joins the list with a dash
  final List<String> newMembers = [...members]..sort();
  return newMembers.join('-');
}
