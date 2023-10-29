class RelationshipSearchFilterBuilder {
  List<String> _filters = [];

  void addFollowingMeFilter(String memberId) {
    _filters.add('searchIndexRelationshipFollowers:$memberId');
  }

  void addIFollowFilter(String memberId) {
    _filters.add('searchIndexRelationshipFollows:$memberId');
  }

  void addFullyConnectedFilter(String memberId) {
    _filters.add('relationship.isFullyConnected:true AND searchIndexRelationshipConnections:$memberId');
  }

  void addPendingConnectionFilter(String memberId) {
    _filters.add('relationship.isPendingConnection:true AND NOT searchIndexRelationshipConnections:$memberId');
  }

  void addHiddenFilter(String memberId) {
    _filters.add('searchIndexRelationshipHides:$memberId');
  }

  void addBlockedFilter(String memberId) {
    _filters.add('searchIndexRelationshipBlocks:$memberId');
  }

  void addIManageFilter(String memberId) {
    _filters.add('searchIndexRelationshipManages:$memberId');
  }

  void clearFilters() {
    _filters = [];
  }

  String build() {
    return _filters.join(' AND ');
  }
}
