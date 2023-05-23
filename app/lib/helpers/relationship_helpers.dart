String buildRelationshipIdentifier(List<String> members) {
  // Sorts the list, and then joins the list with a dash
  members.sort();
  return members.join('-');
}
