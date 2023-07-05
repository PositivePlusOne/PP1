// Flutter imports:
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/buttons/positive_switch.dart';
import '../../atoms/input/positive_text_field_dropdown.dart';
import '../../atoms/input/positive_text_field_icon.dart';
import '../../molecules/containers/positive_glass_sheet.dart';

// Project imports:

class CreatePostDialog extends HookConsumerWidget {
  CreatePostDialog({
    required this.postType,
    required this.onWillPopScope,
    super.key,
  });

  final VoidCallback onWillPopScope;
  final PostType postType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (postType == PostType.event) {
      return createPostLayout(context, ref); //TODO EVENT LAYOUT
    } else {
      return createPostLayout(context, ref);
    }
  }

  Container createPostLayout(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final TextStyle textStyle = typography.styleSubtitleBold.copyWith(color: colours.white);
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final double marginHeight = kPaddingMedium + mediaQueryData.padding.top;
    return Container(
      color: colours.black.withAlpha(230),
      child: Padding(
        padding: EdgeInsets.only(top: marginHeight, left: kPaddingMedium, right: kPaddingMedium, bottom: mediaQueryData.padding.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PositiveButton.appBarIcon(
              colors: colours,
              primaryColor: colours.colorGray7,
              icon: UniconsLine.angle_left,
              size: PositiveButtonSize.medium,
              style: PositiveButtonStyle.primaryBorder,
              onTapped: onWillPopScope,
            ),
            const SizedBox(height: kPaddingMedium),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(kPaddingNone),
                children: [
                  CreatePostTextField(
                    text: postType == PostType.text ? localisations.page_create_post_message : localisations.page_create_post_caption,
                    colours: colours,
                    textStyle: textStyle,
                    maxLines: 15,
                    minLines: 8,
                  ),
                  const SizedBox(height: kPaddingSmall),
                  CreatePostTextField(
                    text: localisations.page_create_post_tags,
                    colours: colours,
                    textStyle: textStyle,
                    maxLines: 3,
                    minLines: 1,
                  ),
                  // PositiveTextField(
                  //   labelText: "test",
                  //   initialText: "Test",
                  //   onTextChanged: (_) {},
                  //   suffixIcon: PositiveTextFieldIcon.success(backgroundColor: colours.red),
                  //   isEnabled: true,
                  // ),
                  if (postType == PostType.image) ...[
                    const SizedBox(height: kPaddingSmall),
                    CreatePostTextField(
                      text: localisations.page_create_post_alt_text,
                      colours: colours,
                      textStyle: textStyle,
                      maxLines: 3,
                      minLines: 1,
                    ),
                  ],
                  if (postType == PostType.image || postType == PostType.multiImage) ...[
                    const SizedBox(height: kPaddingSmall),
                    CreatePostToggleContainer(
                      colours: colours,
                      textStyle: textStyle,
                      text: localisations.page_create_post_save,
                    ),
                  ],
                  const SizedBox(height: kPaddingSmall),
                  CreatePostToggleContainer(
                    colours: colours,
                    textStyle: textStyle,
                    text: localisations.page_create_post_allow_sharing,
                  ),
                  const SizedBox(height: kPaddingSmall),
                  CreatePostBox(
                    colours: colours,
                    forceBorder: true,
                    child: PositiveTextFieldDropdown(
                      initialValue: localisations.shared_user_type_generic_everyone,
                      labelText: localisations.page_create_post_visibility,
                      labelTextStyle: typography.styleSubtextBold.copyWith(color: colours.white),
                      onValueChanged: (type) {},
                      values: [
                        localisations.shared_user_type_generic_everyone,
                        localisations.shared_user_type_generic_connections,
                        localisations.shared_user_type_generic_followers,
                        localisations.shared_user_type_generic_me,
                      ],
                      textStyle: textStyle,
                      backgroundColour: colours.transparent,
                      iconColour: colours.black,
                      iconBackgroundColour: colours.white,
                      isEnabled: true,
                    ),
                  ),
                  const SizedBox(height: kPaddingSmall),
                  CreatePostBox(
                    colours: colours,
                    forceBorder: true,
                    child: PositiveTextFieldDropdown(
                      initialValue: localisations.shared_user_type_generic_everyone,
                      labelText: localisations.page_create_post_comments,
                      labelTextStyle: typography.styleSubtextBold.copyWith(color: colours.white),
                      onValueChanged: (type) {},
                      values: [
                        localisations.shared_user_type_generic_everyone,
                        localisations.shared_user_type_generic_connections,
                        localisations.shared_user_type_generic_followers,
                        localisations.shared_user_type_generic_me,
                      ],
                      textStyle: textStyle,
                      backgroundColour: colours.transparent,
                      iconColour: colours.black,
                      iconBackgroundColour: colours.white,
                      isEnabled: true,
                    ),
                  ),
                  const SizedBox(height: kPaddingSmall),
                ],
              ),
            ),
            // const Spacer(),
            // PositiveGlassSheet(
            //   children: <Widget>[
            //     PositiveButton(
            //       colors: colours,
            //       primaryColor: colours.black,
            //       label: "buttonText",
            //       onTapped: () {},
            //       isDisabled: false,
            //     ),
            //   ],
            // ),
            // const SizedBox(height: kPaddingSmall),
          ],
        ),
      ),
    );
  }
}

class CreatePostBox extends StatelessWidget {
  const CreatePostBox({
    super.key,
    required this.colours,
    this.padding = EdgeInsets.zero,
    this.forceBorder = false,
    this.child,
    this.prefixWidget,
    this.suffixWidget,
    this.height,
  });

  final DesignColorsModel colours;
  final Widget? child;
  final double? height;
  final EdgeInsets padding;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final bool forceBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      constraints: const BoxConstraints(minHeight: kCreatePostHeight),
      height: height,
      decoration: BoxDecoration(
        color: colours.white.withAlpha(30),
        borderRadius: BorderRadius.circular(kBorderRadiusLargePlus),
        border: forceBorder
            ? Border.all(
                color: colours.white,
                width: PositiveTextField.kBorderWidthFocused,
              )
            : null,
      ),
      child: child,
    );
  }
}

class CreatePostTextField extends StatelessWidget {
  const CreatePostTextField({
    super.key,
    required this.colours,
    required this.minLines,
    required this.maxLines,
    required this.textStyle,
    required this.text,
  });

  final DesignColorsModel colours;
  final int minLines;
  final int maxLines;
  final TextStyle textStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return CreatePostBox(
      colours: colours,
      child: PositiveTextField(
        labelText: text,
        onTextChanged: (_) {},
        textStyle: textStyle,
        labelStyle: textStyle,
        fillColor: colours.transparent,
        tintColor: colours.white,
        borderRadius: kBorderRadiusLargePlus,
        isEnabled: true,
        minLines: minLines,
        maxLines: maxLines,
      ),
    );
  }
}

class CreatePostToggleContainer extends StatelessWidget {
  const CreatePostToggleContainer({
    super.key,
    required this.colours,
    required this.textStyle,
    required this.text,
  });

  final DesignColorsModel colours;
  final TextStyle textStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return CreatePostBox(
      colours: colours,
      padding: EdgeInsets.only(right: kPaddingSmall, left: kPaddingLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: textStyle,
          ),
          PositiveSwitch(
            value: false,
            activeColour: colours.white,
            inactiveColour: colours.colorGray4,
            ignoring: true,
            isEnabled: true,
          ),
        ],
      ),
    );
  }
}

enum PostType {
  text,
  image,
  multiImage,
  clip,
  event,
  repost,
}
