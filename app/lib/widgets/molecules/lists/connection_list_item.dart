import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/providers/content/connections_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:flutter/material.dart';

class ConnectionListItem extends StatelessWidget {
  final ConnectedUser connectedUser;
  const ConnectionListItem({Key? key, required this.connectedUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          PositiveProfileCircularIndicator(
            profile: Profile(
              accentColor: connectedUser.accentColor ?? "",
              displayName: connectedUser.displayName,
              profileImage: connectedUser.profileImage ?? "",
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(connectedUser.displayName),
                Text(extraProfileInfo()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String extraProfileInfo() {
    List<String> extraInfo = [];
    if (connectedUser.birthday != null) {
      final birthday = DateTime.tryParse(connectedUser.birthday!);
      if (birthday != null) {
        final age = DateTime.now().difference(birthday).inDays ~/ 365;
        extraInfo.add(age.toString());
      }
    }
    if (connectedUser.genders != null) {
      extraInfo.add(connectedUser.genders!.join(", "));
    }
    if (connectedUser.hivStatus != null) {
      extraInfo.add(connectedUser.hivStatus!);
    }
    if (connectedUser.locationName != null) {
      extraInfo.add(connectedUser.locationName!);
    }

    return extraInfo.join(", ");
  }
}
