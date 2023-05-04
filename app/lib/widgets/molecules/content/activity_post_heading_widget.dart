import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ActivityPostHeadingWidget extends ConsumerWidget {
  const ActivityPostHeadingWidget({
    required this.activity,
    required this.publisher,
    super.key,
  });

  final Activity activity;
  final Profile? publisher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String displayName = 'Unknown';
    String? profileImage = 'https://picsum.photos/200/300';

    if (publisher?.displayName.isNotEmpty ?? false) {
      displayName = publisher!.displayName;
    }

    if (publisher?.profileImage.isNotEmpty ?? false) {
      profileImage = publisher!.profileImage;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingSmallMedium),
      child: Row(
        children: <Widget>[
          PositiveProfileCircularIndicator(profile: publisher),
          const SizedBox(width: kPaddingSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                displayName,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: kPaddingExtraSmall),
              Text(
                'Created at...',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
