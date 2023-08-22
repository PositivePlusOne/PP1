// Dart imports:

// Flutter imports:
import 'dart:math';

import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';

class PostCommentBox extends ConsumerWidget implements PreferredSizeWidget {
  const PostCommentBox({
    required this.mediaQuery,
    required this.commentTextController,
    required this.onCommentChanged,
    required this.onPostCommentRequested,
    required this.isBusy,
    required this.colours,
    Key? key,
  }) : super(key: key);

  final MediaQueryData mediaQuery;

  final TextEditingController commentTextController;
  final Function(String) onCommentChanged;
  final Function(String) onPostCommentRequested;
  final bool isBusy;
  final DesignColorsModel colours;

  static double calculateHeight(MediaQueryData mediaQuery) {
    return kBottomNavigationBarHeight + (kPaddingMedium * 2) + kBottomNavigationBarBorderWidth + bottomPadding(mediaQuery);
  }

  static double bottomPadding(MediaQueryData mediaQuery) {
    return max(mediaQuery.padding.bottom, mediaQuery.viewInsets.bottom);
  }

  @override
  Size get preferredSize => Size.fromHeight(calculateHeight(mediaQuery));

  static const String kHeroTag = 'pp1-components-comment-bar';

  static const double kBottomNavigationBarHeight = 80.0;
  static const double kBottomNavigationBarBorderWidth = 1.0;
  static const double kBottomNavigationBarSigmaBlur = 10.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Hero(
      tag: kHeroTag,
      child: SizedBox(
        height: preferredSize.height,
        child: Stack(
          children: <Widget>[
            const Positioned.fill(
              child: PositiveNavigationBarShade(),
            ),
            Positioned(
              top: kPaddingMedium,
              left: kPaddingSmall,
              right: kPaddingSmall,
              bottom: kPaddingMedium + bottomPadding(mediaQuery),
              child: Container(
                decoration: BoxDecoration(
                  color: colours.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(kBorderRadiusMassive),
                  ),
                ),
                padding: const EdgeInsets.all(kPaddingSmallMedium),
                child: PositiveTextField(
                  hintText: 'Leave a comment',
                  textEditingController: commentTextController,
                  onTextChanged: onCommentChanged,
                  onTextSubmitted: onPostCommentRequested,
                  fillColor: colours.colorGray1,
                  suffixIcon: Container(
                    decoration: BoxDecoration(
                      color: colours.black,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(kBorderRadiusLarge),
                      ),
                    ),
                    padding: const EdgeInsets.all(kPaddingSmall),
                    child: PositiveTapBehaviour(
                      isEnabled: !isBusy,
                      onTap: () => onPostCommentRequested(commentTextController.text),
                      child: Icon(
                        UniconsLine.message,
                        color: colours.white,
                        size: kIconSmall,
                      ),
                    ),
                  ),
                  isEnabled: !isBusy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
