import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'activity_post_heading_widget.dart';

class ActivityWidget extends ConsumerWidget {
  const ActivityWidget({
    required this.activity,
    required this.publisher,
    super.key,
  });

  final Activity activity;
  final Profile? publisher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        ActivityPostHeadingWidget(
          activity: activity,
          publisher: publisher,
        ),
        ListTile(
          title: Text(activity.foreignKey),
          subtitle: Text(activity.toString()),
        ),
      ],
    );
  }
}
