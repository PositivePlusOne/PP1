// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'activity_post_heading_widget.dart';

class PositiveComment extends ConsumerWidget {
  const PositiveComment({
    required this.currentProfile,
    required this.comment,
    required this.activity,
    required this.feedOrigin,
    required this.onOptionSelected,
    this.isFirst = false,
    super.key,
  });

  final Profile? currentProfile;
  final Reaction comment;
  final Activity? activity;
  final String feedOrigin;

  final bool isFirst;
  final FutureOr<void> Function(Reaction comment, Profile? publisherProfile) onOptionSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    // Load the publisher.
    final String publisherKey = comment.userId;
    final Profile? publisherProfile = cacheController.get(publisherKey);

    final String currentProfileKey = currentProfile?.flMeta?.id ?? '';
    final String expectedRelationshipId = [currentProfileKey, publisherKey].asGUID;
    final Relationship? relationship = cacheController.get(expectedRelationshipId);

    return Container(
      padding: EdgeInsets.only(
        top: isFirst ? kPaddingNone : kPaddingMedium,
        bottom: kPaddingMedium,
      ),
      decoration: BoxDecoration(color: colours.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ActivityPostHeadingWidget(
            activity: activity,
            currentProfile: currentProfile,
            publisher: publisherProfile ?? Profile.empty(),
            publisherRelationship: relationship,
            origin: feedOrigin,
            onOptions: () => onOptionSelected(comment, publisherProfile),
          ),
          const SizedBox(height: kPaddingSmall),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
            child: buildMarkdownWidgetFromBody(
              comment.text,
              boldHandles: true,
              mentions: comment.mentions,
            ),
          ),
        ],
      ),
    );
  }
}
