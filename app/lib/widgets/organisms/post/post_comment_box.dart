// Dart imports:

// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';

class PostCommentBox extends StatefulHookConsumerWidget implements PreferredSizeWidget {
  const PostCommentBox({
    required this.mediaQuery,
    required this.commentTextController,
    required this.onCommentChanged,
    required this.onPostCommentRequested,
    required this.isBusy,
    Key? key,
  }) : super(key: key);

  final MediaQueryData mediaQuery;

  final TextEditingController commentTextController;
  final Function(String) onCommentChanged;
  final Function(String) onPostCommentRequested;
  final bool isBusy;

  static double calculateHeight(MediaQueryData mediaQuery) {
    return kBottomNavigationBarHeight + (kPaddingMedium * 2) + kBottomNavigationBarBorderWidth + bottomPadding(mediaQuery);
  }

  static double bottomPadding(MediaQueryData mediaQuery) {
    return max(mediaQuery.padding.bottom, mediaQuery.viewInsets.bottom);
  }

  @override
  Size get preferredSize => mediaQuery.size;

  static const String kHeroTag = 'pp1-components-comment-bar';

  static const double kBottomNavigationBarHeight = 80.0;
  static const double kBottomNavigationBarBorderWidth = 1.0;
  static const double kBottomNavigationBarSigmaBlur = 10.0;

  @override
  ConsumerState<PostCommentBox> createState() => _PostCommentBoxState();
}

class _PostCommentBoxState extends ConsumerState<PostCommentBox> {
  bool hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    return SizedBox(
      height: widget.preferredSize.height,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            top: mediaQuery.size.height - PostCommentBox.calculateHeight(mediaQuery),
            child: const PositiveNavigationBarShade(),
          ),
          Positioned(
            top: kPaddingMedium,
            left: kPaddingSmall,
            right: kPaddingSmall,
            bottom: kPaddingMedium + PostCommentBox.bottomPadding(mediaQuery),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: colours.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(kBorderRadiusMassive),
                  ),
                ),
                padding: const EdgeInsets.all(kPaddingSmallMedium),
                child: PositiveTextField(
                  labelText: 'Leave a comment',
                  textEditingController: widget.commentTextController,
                  onTextChanged: widget.onCommentChanged,
                  onTextSubmitted: widget.onPostCommentRequested,
                  fillColor: colours.colorGray1,
                  isEnabled: !widget.isBusy,
                  minLines: 1,
                  //TODO(S): We need a best guess helper to make sure maxLines can fit within the provided area
                  maxLines: 10,
                  onFocusedChanged: (focus) {
                    setState(() {
                      hasFocus = focus;
                    });
                  },
                  suffixIcon: Container(
                    decoration: BoxDecoration(
                      color: hasFocus ? colours.purple : colours.black,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(kBorderRadiusLarge),
                      ),
                    ),
                    padding: const EdgeInsets.all(kPaddingSmall),
                    child: PositiveTapBehaviour(
                      isEnabled: !widget.isBusy,
                      onTap: (_) => widget.onPostCommentRequested(widget.commentTextController.text),
                      child: Icon(
                        UniconsLine.message,
                        color: colours.white,
                        size: kIconSmall,
                      ),
                    ),
                  ),
                  tintColor: colours.purple,
                  borderRadius: kBorderRadiusLargePlus,
                  showRemaining: true,
                  textInputType: TextInputType.multiline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
