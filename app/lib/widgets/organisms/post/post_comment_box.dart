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
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/analytics/analytic_properties.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
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
    required this.activity,
    this.onSwitchProfileRequested,
    this.currentProfile,
    this.canSwitchProfile = false,
    super.key,
  });

  final MediaQueryData mediaQuery;
  final Profile? currentProfile;
  final bool canSwitchProfile;
  final VoidCallback? onSwitchProfileRequested;

  final Activity? activity;

  final TextEditingController commentTextController;
  final Function(String) onCommentChanged;
  final Function(String) onPostCommentRequested;
  final bool isBusy;

  static double calculateHeight(MediaQueryData mediaQuery) {
    return kBottomNavigationBarHeight + (kPaddingMedium * 2) + kBottomNavigationBarBorderWidth + bottomPadding(mediaQuery);
  }

  static double bottomPadding(MediaQueryData mediaQuery) {
    return max(mediaQuery.padding.bottom + kPaddingLarge, mediaQuery.viewInsets.bottom);
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
            left: kPaddingSmall,
            right: kPaddingSmall,
            bottom: kPaddingLarge + PostCommentBox.bottomPadding(mediaQuery),
            child: Container(
              decoration: BoxDecoration(
                color: colours.white,
                borderRadius: BorderRadius.circular(kBorderRadiusMassive),
              ),
              padding: const EdgeInsets.all(kPaddingSmallMedium),
              child: Row(
                children: <Widget>[
                  if (widget.canSwitchProfile) ...<Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: kPaddingSmall),
                      child: PositiveProfileCircularIndicator(
                        profile: widget.currentProfile,
                        onTap: widget.onSwitchProfileRequested,
                        isEnabled: !widget.isBusy,
                      ),
                    ),
                  ],
                  Expanded(
                    child: PositiveTextField(
                      labelText: 'Leave a comment',
                      allowMentions: true,
                      mentionSearchLimit: 2,
                      analyticProperties: generatePropertiesForPostSource(activity: widget.activity),
                      textEditingController: widget.commentTextController,
                      onTextChanged: widget.onCommentChanged,
                      onTextSubmitted: widget.onPostCommentRequested,
                      fillColor: colours.colorGray1,
                      searchResultsBrightness: Brightness.light,
                      isEnabled: !widget.isBusy,
                      minLines: 1,
                      maxLines: 5,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
