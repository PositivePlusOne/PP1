import 'package:app/constants/design_constants.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

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
    this.horizontalPadding = kPaddingMedium,
    this.verticalPadding = kPaddingSmallMedium,
    super.key,
  });

  final int? likes;
  final Function()? onLike;
  final bool likeEnabled;

  final int? comments;
  final Function()? onComment;
  final bool commentsEnabled;

  final bool? bookmarked;
  final Function()? onBookmark;

  final Function()? onShare;
  final bool shareEnabled;

  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final UserController userController = ref.read(userControllerProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
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
                    color: colors.colorGray6,
                    size: kIconSmall,
                  ),
                  const SizedBox(width: kPaddingExtraSmall),
                  Text(
                    likes.toString(),
                    style: typography.styleSubtitle.copyWith(
                      color: colors.colorGray6,
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
                    color: colors.colorGray6,
                    size: kIconSmall,
                  ),
                  const SizedBox(width: kPaddingExtraSmall),
                  Text(
                    likes.toString(),
                    style: typography.styleSubtitle.copyWith(
                      color: colors.colorGray6,
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
                color: colors.colorGray6,
                size: kIconSmall,
              ),
            ),
          const SizedBox(width: kPaddingMedium),
          if (onShare != null && shareEnabled)
            PositiveTapBehaviour(
              onTap: onShare,
              child: Icon(
                UniconsLine.message,
                color: colors.colorGray6,
                size: kIconSmall,
              ),
            ),
        ],
      ),
    );
  }
}
