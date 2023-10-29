import 'dart:collection';

class RelationshipSearchFilterBuilder {
  List<String> _filters = [];

  void addMutedFilter(String memberId) {
    _filters.add('relationship.searchIndexRelationshipMutes:$memberId');
  }

  void addBlockedFilter(String memberId) {
    _filters.add('relationship.searchIndexRelationshipBlocks:$memberId');
  }

  void addConnectedFilter(String memberId) {
    _filters.add('relationship.searchIndexRelationshipConnections:$memberId');
  }

  void addFollowingFilter(String memberId) {
    _filters.add('relationship.searchIndexRelationshipFollows:$memberId');
  }

  void addFollowerFilter(String memberId) {
    _filters.add('relationship.searchIndexRelationshipFollowers:$memberId');
  }

  void addHiddenFilter(String memberId) {
    _filters.add('relationship.searchIndexRelationshipHides:$memberId');
  }

  void addManagerFilter(String memberId) {
    _filters.add('relationship.searchIndexRelationshipManages:$memberId');
  }

  void addManagedFilter(String memberId) {
    _filters.add('relationship.searchIndexRelationshipManaged:$memberId');
  }

  void addFullyConnectedFilter() {
    _filters.add('relationship.isFullyConnected:true');
  }

  void clearFilters() {
    _filters = [];
  }

  UnmodifiableListView<String> get filters => UnmodifiableListView(_filters);
}
