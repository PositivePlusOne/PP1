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
      top: kPaddingSmall,
      bottom: kPaddingSmall,
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
    const EdgeInsetsGeometry extraClickableArea = EdgeInsets.all(kPaddingSmall);

    return Container(
      padding: padding.subtract(extraClickableArea).clamp(EdgeInsets.zero, padding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          PositiveTapBehaviour(
            onTap: onLike,
            isEnabled: likesEnabled,
            showDisabledState: !likesEnabled,
            hitTestBehaviourOverride: HitTestBehavior.translucent,
            child: Padding(
              padding: extraClickableArea,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? colours.purple : colours.colorGray6,
                    size: kIconSmall,
                  ),
                  const SizedBox(width: kPaddingExtraSmall),
                  Text(
                    '${likes ?? 0}',
                    style: typography.styleSubtitleBold.copyWith(
                      color: colours.colorGray6,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PositiveTapBehaviour(
            onTap: onComment,
            isEnabled: commentsEnabled,
            showDisabledState: !commentsEnabled,
            hitTestBehaviourOverride: HitTestBehavior.translucent,
            child: Padding(
              padding: extraClickableArea,
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
                    style: typography.styleSubtitleBold.copyWith(
                      fontSize: 12.0,
                      color: colours.colorGray6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          //! PP1-984
          // PositiveTapBehaviour(
          //   onTap: onBookmark,
          //   isEnabled: bookmarkEnabled,
          //   showDisabledState: !bookmarkEnabled,
          //   child: Icon(
          //     bookmarked ? UniconsSolid.bookmark : UniconsLine.bookmark,
          //     color: colours.colorGray6,
          //     size: kIconSmall,
          //   ),
          // ),
          // const SizedBox(width: kPaddingMedium),
          PositiveTapBehaviour(
            onTap: onShare,
            isEnabled: shareEnabled,
            showDisabledState: !shareEnabled,
            hitTestBehaviourOverride: HitTestBehavior.translucent,
            child: Padding(
              padding: extraClickableArea,
              child: Icon(
                UniconsLine.message,
                color: colours.colorGray6,
                size: kIconSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
