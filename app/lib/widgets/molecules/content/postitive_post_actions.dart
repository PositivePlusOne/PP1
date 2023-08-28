// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../../providers/user/user_controller.dart';

class PositivePostActions extends HookConsumerWidget {
  const PositivePostActions({
    this.likes,
    this.onLike,
    this.likeEnabled = false,
    this.comments,
    this.onComment,
    this.commentsEnabled = false,
    this.bookmarked,
    this.onBookmark,
    this.onShare,
    this.shareEnabled = false,
    this.padding = const EdgeInsets.only(
      left: kPaddingMedium,
      right: kPaddingMedium,
      top: kPaddingSmallMedium,
      bottom: kPaddingSmallMedium,
    ),
    super.key,
  });

  final int? likes;
  final Function(BuildContext context)? onLike;
  final bool likeEnabled;

  final int? comments;
  final Function(BuildContext context)? onComment;
  final bool commentsEnabled;

  final bool? bookmarked;
  final Function(BuildContext context)? onBookmark;

  final Function(BuildContext context)? onShare;
  final bool shareEnabled;

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final UserController userController = ref.read(userControllerProvider.notifier);

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (likes != null && likeEnabled)
            PositiveTapBehaviour(
              onTap: onLike,
              isEnabled: userController.isUserLoggedIn,
              child: Row(
                children: [
                  Icon(
                    UniconsLine.heart,
                    color: colours.colorGray6,
                    size: kIconSmall,
                  ),
                  const SizedBox(width: kPaddingExtraSmall),
                  Text(
                    '${likes ?? 0}',
                    style: typography.styleSubtitle.copyWith(
                      color: colours.colorGray6,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: kPaddingMedium),
          if (comments != null && commentsEnabled)
            PositiveTapBehaviour(
              onTap: onComment,
              child: Row(
                children: [
                  Icon(
                    UniconsLine.comment_alt_message,
                    color: colours.colorGray6,
                    size: kIconSmall,
                  ),
                  const SizedBox(width: kPaddingExtraSmall),
                  Text(
                    '${comments ?? 0}',
                    style: typography.styleSubtitle.copyWith(
                      color: colours.colorGray6,
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
          if (bookmarked != null)
            PositiveTapBehaviour(
              onTap: onBookmark,
              isEnabled: userController.isUserLoggedIn,
              child: Icon(
                bookmarked! ? UniconsSolid.bookmark : UniconsLine.bookmark,
                color: colours.colorGray6,
                size: kIconSmall,
              ),
            ),
          const SizedBox(width: kPaddingMedium),
          if (onShare != null && shareEnabled)
            PositiveTapBehaviour(
              onTap: onShare,
              child: Icon(
                UniconsLine.message,
                color: colours.colorGray6,
                size: kIconSmall,
              ),
            ),
        ],
      ),
    );
  }
}
