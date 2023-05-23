// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/content/connections_controller.dart';

part 'connections_list_view_model.freezed.dart';

part 'connections_list_view_model.g.dart';

@freezed
class ConnectionsListState with _$ConnectionsListState {
  const factory ConnectionsListState({
    @Default(<ConnectedUser>[]) List<ConnectedUser> selectedUsers,
  }) = _ConnectionsListState;
}

@Riverpod()
class ConnectionsListViewModel extends _$ConnectionsListViewModel {
  @override
  ConnectionsListState build() {
    return const ConnectionsListState();
  }

  void selectUser(ConnectedUser user) {
    if (state.selectedUsers.contains(user)) {
      state = state.copyWith(selectedUsers: state.selectedUsers.where((element) => element != user).toList());
    } else {
      state = state.copyWith(selectedUsers: [...state.selectedUsers, user]);
    }
  }
}
