// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../dtos/database/activities/activities.dart';

class ActivityEventTile extends StatelessWidget {
  const ActivityEventTile({super.key, required this.activity});

  final Activity activity;

  String? getImageUrl() {
    final media = activity.media.firstWhere(
      (m) => m.type == 'photo_link',
      orElse: () => Media(),
    );
    return media.url.isNotEmpty ? media.url : null;
  }

  DateTime timestampToDateTime(Map<String, dynamic> timestamp) {
    if (timestamp.isEmpty || timestamp['_seconds'] == null || timestamp['_nanoseconds'] == null) {
      return DateTime.now();
    }

    int seconds = timestamp['_seconds'];
    int nanoseconds = timestamp['_nanoseconds'];
    return DateTime.fromMicrosecondsSinceEpoch(seconds * 1000000 + nanoseconds ~/ 1000);
  }

  @override
  Widget build(BuildContext context) {
    final eventConfig = activity.eventConfiguration ?? EventConfiguration();
    final schedule = eventConfig.schedule ?? Schedule();
    final startTime = timestampToDateTime(schedule.startDate);
    final endTime = timestampToDateTime(schedule.endDate);
    final imageUrl = getImageUrl();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              const SizedBox(height: 8),
              Text(
                eventConfig.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Location: ${eventConfig.location}'),
              const SizedBox(height: 4),
              Text('Venue: ${eventConfig.venue}'),
              const SizedBox(height: 8),
              Text(
                'Date: ${startTime.year}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')}',
              ),
              const SizedBox(height: 4),
              Text(
                'Time: ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
