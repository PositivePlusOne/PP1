// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../dtos/database/activities/activities.dart';

class ActivityEventTile extends StatelessWidget {
  const ActivityEventTile({super.key, required this.activity});

  final Activity activity;

  // String? getImageUrl() {
  //   final media = activity.media.firstWhere(
  //     (m) => m.type == 'photo_link',
  //     orElse: () => Media(),
  //   );
  //   return media.url.isNotEmpty ? media.url : null;
  // }

  // DateTime timestampToDateTime(Map<String, dynamic> timestamp) {
  //   if (timestamp.isEmpty || timestamp['_seconds'] == null || timestamp['_nanoseconds'] == null) {
  //     return DateTime.now();
  //   }

  //   int seconds = timestamp['_seconds'];
  //   int nanoseconds = timestamp['_nanoseconds'];
  //   return DateTime.fromMicrosecondsSinceEpoch(seconds * 1000000 + nanoseconds ~/ 1000);
  // }

  @override
  Widget build(BuildContext context) {
    final eventConfig = activity.eventConfiguration ?? EventConfiguration();
    final schedule = eventConfig.schedule ?? Schedule();
    // final startTime = timestampToDateTime(schedule.startDate);
    // final endTime = timestampToDateTime(schedule.endDate);
    // final imageUrl = getImageUrl();

    return Column(
      children: <Widget>[
        Row(),
      ],
    );
  }
}
