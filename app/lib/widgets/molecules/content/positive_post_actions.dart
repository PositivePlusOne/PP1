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

class PositivePostActions extends HookConsumerWidget {
  const PositivePostActions({
    this.likes,
    this.onLike,
    this.likesEnabled = false,
    this.isLiked = false,
    this.comments,
    this.onComment,
    this.commentsEnabled = false,
    this.bookmarked = false,
    this.bookmarkEnabled = false,
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
  final bool likesEnabled;
  final bool isLiked;

  final int? comments;
  final Function(BuildContext context)? onComment;
  final bool commentsEnabled;

  final bool bookmarked;
  final bool bookmarkEnabled;
  final Function(BuildContext context)? onBookmark;

  final Function(BuildContext context)? onShare;
  final bool shareEnabled;

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PositiveTapBehaviour(
            onTap: onLike,
            isEnabled: likesEnabled,
            showDisabledState: !likesEnabled,
            child: Row(
              children: <Widget>[
                Icon(
                  UniconsLine.heart,
                  color: isLiked ? colours.purple : colours.colorGray6,
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
          PositiveTapBehaviour(
            onTap: onComment,
            isEnabled: commentsEnabled,
            showDisabledState: !commentsEnabled,
            child: Row(
              children: <Widget>[
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
          PositiveTapBehaviour(
            onTap: onBookmark,
            isEnabled: bookmarkEnabled,
            showDisabledState: !bookmarkEnabled,
            child: Icon(
              bookmarked ? UniconsSolid.bookmark : UniconsLine.bookmark,
              color: colours.colorGray6,
              size: kIconSmall,
            ),
          ),
          const SizedBox(width: kPaddingMedium),
          PositiveTapBehaviour(
            onTap: onShare,
            isEnabled: shareEnabled,
            showDisabledState: !shareEnabled,
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
