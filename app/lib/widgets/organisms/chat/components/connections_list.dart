// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/providers/content/connections_controller.dart';
import 'package:app/widgets/molecules/lists/connection_list_item.dart';
import 'package:app/widgets/organisms/chat/vms/connections_list_view_model.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class ConnectionsList extends ConsumerWidget {
  final List<ConnectedUser> connectedUsers;

  const ConnectionsList({Key? key, required this.connectedUsers}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverInfiniteList(
      itemCount: connectedUsers.length,
      hasReachedMax: ref.watch(connectedUsersControllerProvider).value?.hasReachMax ?? false,
      onFetchData: () => ref.read(connectedUsersControllerProvider.notifier).fetchMore(),
      debounceDuration: const Duration(milliseconds: 500),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(
          left: kPaddingMedium,
          right: kPaddingMedium,
          bottom: kPaddingExtraSmall,
        ),
        child: ConnectionListItem(
          onTap: () => ref.read(connectionsListViewModelProvider.notifier).selectUser(connectedUsers[index]),
          isSelected: ref.watch(connectionsListViewModelProvider).selectedUsers.contains(connectedUsers[index]),
          connectedUser: connectedUsers[index],
        ),
      ),
    );
  }
}
