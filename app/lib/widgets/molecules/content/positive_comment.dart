// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'activity_post_heading_widget.dart';

class PositiveComment extends ConsumerWidget {
  const PositiveComment({
    required this.comment,
    this.isFirst = false,
    super.key,
  });

  final Reaction comment;
  final bool isFirst;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    // Load the publisher.
    final String publisherKey = comment.userId;
    final Profile? publisherProfile = cacheController.get(publisherKey);

    return IgnorePointer(
      // ignoring: !widget.isEnabled,
      child: Container(
        padding: EdgeInsets.only(
          top: isFirst ? kPaddingNone : kPaddingMedium,
          bottom: kPaddingMedium,
        ),
        decoration: BoxDecoration(color: colours.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ActivityPostHeadingWidget(
              flMetaData: comment.flMeta,
              publisher: publisherProfile,
              //TODO(S) this should be the generic profile options
              onOptions: () {},
            ),
            const SizedBox(height: kPaddingSmall),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
              child: Text(
                comment.text,
                textAlign: TextAlign.left,
                style: typography.styleBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
