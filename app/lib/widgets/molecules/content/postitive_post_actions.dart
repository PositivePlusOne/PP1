import 'package:app/constants/design_constants.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';

class PositivePostActions extends HookConsumerWidget {
  const PositivePostActions({
    this.onLike,
    this.likes,
    this.comments,
    this.bookmarked,
    this.onBookmark,
    this.onHyperLink,
    this.horizontalPadding = kPaddingMedium,
    this.verticalPadding = kPaddingSmallMedium,
    super.key,
  });

  final Function()? onLike;
  final int? likes;
  final int? comments;

  final bool? bookmarked;
  final Function()? onBookmark;

  final Function()? onHyperLink;

  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (likes != null) ...[
            PositiveTapBehaviour(
              onTap: onLike,
              child: Icon(
                UniconsLine.heart,
                color: colors.colorGray6,
                size: kIconSmall,
              ),
            ),
            const SizedBox(width: kPaddingExtraSmall),
            Text(
              likes.toString(),
              style: typography.styleSubtitle.copyWith(
                color: colors.colorGray6,
              ),
            ),
          ],
          const SizedBox(width: kPaddingMedium),
          if (comments != null) ...[
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
          const Spacer(),
          if (bookmarked != null)
            PositiveTapBehaviour(
              onTap: onBookmark,
              child: Icon(
                bookmarked! ? UniconsSolid.bookmark : UniconsLine.bookmark,
                color: colors.colorGray6,
                size: kIconSmall,
              ),
            ),
          const SizedBox(width: kPaddingMedium),
          if (onHyperLink != null)
            PositiveTapBehaviour(
              onTap: onHyperLink,
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
