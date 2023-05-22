import 'package:app/providers/content/connections_controller.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/lists/connection_list_item.dart';
import 'package:flutter/material.dart';

class ConnectionsList extends StatelessWidget {
  final List<ConnectedUser> connectedUsers;
  const ConnectionsList({Key? key, required this.connectedUsers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: connectedUsers.length,
        (context, index) => ConnectionListItem(
          connectedUser: connectedUsers[index],
        ),
      ),
    );
  }
}
