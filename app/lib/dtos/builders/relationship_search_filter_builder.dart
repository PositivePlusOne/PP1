// Dart imports:
import 'dart:collection';

class RelationshipSearchFilterBuilder {
  List<String> _filters = [];

  void addMutedFilter(String memberId) {
    _filters.add('searchIndexRelationshipMutes:$memberId');
  }

  void addBlockedFilter(String memberId) {
    _filters.add('searchIndexRelationshipBlocks:$memberId');
  }

  void addConnectedFilter(String memberId) {
    _filters.add('searchIndexRelationshipConnections:$memberId');
  }

  void addFollowingFilter(String memberId) {
    _filters.add('searchIndexRelationshipFollows:$memberId');
  }

  void addFollowerFilter(String memberId) {
    _filters.add('searchIndexRelationshipFollowers:$memberId');
  }

  void addHiddenFilter(String memberId) {
    _filters.add('searchIndexRelationshipHides:$memberId');
  }

  void addManagerFilter(String memberId) {
    _filters.add('searchIndexRelationshipManages:$memberId');
  }

  void addManagedFilter(String memberId) {
    _filters.add('searchIndexRelationshipManaged:$memberId');
  }

  void addFullyConnectedFilter() {
    _filters.add('isFullyConnected:true');
  }

  void clearFilters() {
    _filters = [];
  }

  UnmodifiableListView<String> get filters => UnmodifiableListView(_filters);
}
