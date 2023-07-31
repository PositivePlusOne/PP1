// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/buttons/positive_switch.dart';
import '../../atoms/input/positive_text_field_dropdown.dart';

// Project imports:

class CreatePostDialogue extends HookConsumerWidget {
  const CreatePostDialogue({
    required this.postType,
    required this.onTagsPressed,
    required this.isBusy,
    this.captionController,
    this.altTextController,
    this.onUpdateSaveToGallery,
    this.onUpdateAllowSharing,
    this.onUpdateVisibleTo,
    this.onUpdateAllowComments,
    this.multiImageFiles,
    this.prepopulatedActivity,
    this.valueAllowSharing = false,
    this.valueSaveToGallery = false,
    this.tags = const [],
    this.trailingWidget,
    super.key,
  });

  final PostType postType;
  final TextEditingController? captionController;
  final TextEditingController? altTextController;

  final bool isBusy;

  final List<String> tags;
  final List<XFile>? multiImageFiles;

  final Activity? prepopulatedActivity;

  final VoidCallback onTagsPressed;
  final Function()? onUpdateSaveToGallery;
  final Function()? onUpdateAllowSharing;
  final Function(String)? onUpdateVisibleTo;
  final Function(String)? onUpdateAllowComments;

  final bool valueAllowSharing;
  final bool valueSaveToGallery;

  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (postType == PostType.event) {
      return createEventPostLayout(context, ref); //TODO EVENT LAYOUT
    } else {
      return createPostLayout(context, ref);
    }
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-  Layout for Create, Image, Multi-Image, and Clips Post Types -=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\

  Widget createPostLayout(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final AppRouter router = ref.read(appRouterProvider);

    final TextStyle textStyle = typography.styleButtonRegular.copyWith(color: colours.white);

    final double marginHeight = kPaddingMedium + mediaQueryData.padding.top;
    return Container(
      color: colours.black.withAlpha(230),
      child: Padding(
        padding: EdgeInsets.only(top: marginHeight, left: kPaddingMedium, right: kPaddingMedium, bottom: mediaQueryData.padding.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //* -=-=-=-=- Back Button -=-=-=-=- *\\
            PositiveButton.appBarIcon(
              colors: colours,
              primaryColor: colours.colorGray7,
              icon: UniconsLine.angle_left,
              size: PositiveButtonSize.medium,
              style: PositiveButtonStyle.primaryBorder,
              onTapped: router.pop,
            ),
            const SizedBox(height: kPaddingMedium),

            //* -=-=-=-=- Multi Image Thumbnails -=-=-=-=- *\\
            if (postType == PostType.multiImage && multiImageFiles != null && multiImageFiles!.isNotEmpty)
              CreatePostMultiImageThumbnailList(
                images: multiImageFiles!,
                colours: colours,
              ),
            const SizedBox(height: kPaddingSmall),

            //* -=-=-=-=- List view containing input widgets -=-=-=-=- *\\
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(kPaddingNone),
                children: [
                  //* -=-=-=-=- Caption -=-=-=-=- *\\
                  CreatePostTextField(
                    text: postType == PostType.text ? localisations.page_create_post_message : localisations.page_create_post_caption,
                    controller: captionController,
                    colours: colours,
                    textStyle: textStyle,
                    maxLength: kMaxLengthCaption,
                    maxLines: 15,
                    minLines: 8,
                    isBusy: isBusy,
                  ),
                  const SizedBox(height: kPaddingSmall),

                  //* -=-=-=-=- Tags -=-=-=-=- *\\
                  CreatePostTagsContainer(
                    text: localisations.page_create_post_tags,
                    colours: colours,
                    textStyle: textStyle,
                    localisations: localisations,
                    tags: tags,
                    typography: typography,
                    isBusy: isBusy,
                    onTap: onTagsPressed,
                  ),

                  //* -=-=-=-=- Alt Text -=-=-=-=- *\\
                  if (postType == PostType.image) ...[
                    const SizedBox(height: kPaddingSmall),
                    CreatePostTextField(
                      text: localisations.page_create_post_alt_text,
                      controller: altTextController,
                      colours: colours,
                      textStyle: textStyle,
                      maxLength: kMaxLengthAltText,
                      maxLines: 3,
                      minLines: 1,
                      isBusy: isBusy,
                    ),
                  ],

                  //* -=-=-=-=- Save to Gallery Button -=-=-=-=- *\\
                  if ((postType == PostType.image || postType == PostType.multiImage) && onUpdateSaveToGallery != null) ...[
                    const SizedBox(height: kPaddingSmall),
                    CreatePostToggleContainer(
                      value: valueSaveToGallery,
                      colours: colours,
                      onTap: isBusy ? () {} : onUpdateSaveToGallery,
                      textStyle: textStyle,
                      text: localisations.page_create_post_save,
                    ),
                  ],
                  const SizedBox(height: kPaddingSmall),

                  //* -=-=-=-=- Allow Sharing -=-=-=-=- *\\
                  CreatePostToggleContainer(
                    value: valueAllowSharing,
                    colours: colours,
                    onTap: isBusy ? () {} : onUpdateAllowSharing,
                    textStyle: textStyle,
                    text: localisations.page_create_post_allow_sharing,
                  ),
                  const SizedBox(height: kPaddingSmall),

                  //* -=-=-=-=- Sharing Visibility -=-=-=-=- *\\
                  CreatePostBox(
                    colours: colours,
                    forceBorder: true,
                    child: PositiveTextFieldDropdown(
                      initialValue: localisations.shared_user_type_generic_everyone,
                      labelText: localisations.page_create_post_visibility,
                      labelTextStyle: typography.styleSubtextBold.copyWith(color: colours.white),
                      onValueChanged: (type) {
                        if (onUpdateVisibleTo != null) {
                          onUpdateVisibleTo!(type.toString());
                        }
                      },
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
                      isEnabled: !isBusy,
                    ),
                  ),

                  //* -=-=-=-=- Allow Comments -=-=-=-=- *\\
                  const SizedBox(height: kPaddingSmall),
                  CreatePostBox(
                    colours: colours,
                    forceBorder: true,
                    child: PositiveTextFieldDropdown(
                      initialValue: localisations.shared_user_type_generic_everyone,
                      labelText: localisations.page_create_post_comments,
                      labelTextStyle: typography.styleSubtextBold.copyWith(color: colours.white),
                      onValueChanged: (type) {
                        if (onUpdateAllowComments != null) {
                          onUpdateVisibleTo!(type.toString());
                        }
                      },
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
                      isEnabled: !isBusy,
                    ),
                  ),
                  const SizedBox(height: kPaddingSmall),
                ],
              ),
            ),
            // const Spacer(),
            const SizedBox(height: kPaddingSmall),
            trailingWidget ?? const SizedBox(),
            const SizedBox(height: kPaddingSmall),
          ],
        ),
      ),
    );
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-                  Layout for Event Post Types                 -=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\

  Widget createEventPostLayout(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final AppRouter router = ref.read(appRouterProvider);

    final TextStyle textStyle = typography.styleButtonRegular.copyWith(color: colours.white);

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
              onTapped: router.pop,
            ),
            const SizedBox(height: kPaddingMedium),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(kPaddingNone),
                children: [
                  CreatePostTextField(
                    text: postType == PostType.text ? localisations.page_create_post_message : localisations.page_create_post_caption,
                    controller: captionController,
                    colours: colours,
                    textStyle: textStyle,
                    maxLength: kMaxLengthCaption,
                    maxLines: 15,
                    minLines: 8,
                  ),
                  const SizedBox(height: kPaddingSmall),
                  CreatePostTagsContainer(
                    text: localisations.page_create_post_tags,
                    colours: colours,
                    textStyle: textStyle,
                    localisations: localisations,
                    tags: tags,
                    typography: typography,
                    onTap: onTagsPressed,
                  ),
                  if (postType == PostType.image) ...[
                    const SizedBox(height: kPaddingSmall),
                    CreatePostTextField(
                      text: localisations.page_create_post_alt_text,
                      controller: altTextController,
                      colours: colours,
                      textStyle: textStyle,
                      maxLength: kMaxLengthAltText,
                      maxLines: 3,
                      minLines: 1,
                    ),
                  ],
                  if (postType == PostType.image || postType == PostType.multiImage) ...[
                    const SizedBox(height: kPaddingSmall),
                    CreatePostToggleContainer(
                      value: valueSaveToGallery,
                      colours: colours,
                      onTap: onUpdateSaveToGallery,
                      textStyle: textStyle,
                      text: localisations.page_create_post_save,
                    ),
                  ],
                  const SizedBox(height: kPaddingSmall),
                  CreatePostToggleContainer(
                    value: valueAllowSharing,
                    colours: colours,
                    onTap: onUpdateAllowSharing,
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
                      onValueChanged: (type) {
                        if (onUpdateVisibleTo != null) {
                          onUpdateVisibleTo!(type.toString());
                        }
                      },
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
                      onValueChanged: (type) {
                        if (onUpdateAllowComments != null) {
                          onUpdateVisibleTo!(type.toString());
                        }
                      },
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
    this.isBusy = false,
    this.controller,
    this.maxLength,
  });

  final DesignColorsModel colours;
  final int minLines;
  final int maxLines;
  final TextStyle textStyle;
  final String text;
  final TextEditingController? controller;
  final int? maxLength;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return CreatePostBox(
      colours: colours,
      child: PositiveTextField(
        labelText: text,
        textStyle: textStyle,
        labelStyle: textStyle,
        textEditingController: controller,
        showRemainingStyle: textStyle.copyWith(color: colours.colorGray3),
        fillColor: colours.transparent,
        tintColor: colours.white,
        borderRadius: kBorderRadiusLargePlus,
        isEnabled: !isBusy,
        showRemaining: true,
        maxLength: maxLength,
        maxLengthEnforcement: maxLength != null ? MaxLengthEnforcement.enforced : MaxLengthEnforcement.none,
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
    required this.onTap,
    required this.value,
  });

  final DesignColorsModel colours;
  final TextStyle textStyle;
  final String text;
  final bool value;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return PositiveTapBehaviour(
      onTap: onTap,
      child: CreatePostBox(
        colours: colours,
        padding: const EdgeInsets.only(right: kPaddingSmall, left: kPaddingLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: textStyle,
            ),
            PositiveSwitch(
              value: value,
              activeColour: colours.white,
              inactiveColour: colours.colorGray4,
              ignoring: true,
              isEnabled: false,
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePostTagsContainer extends StatelessWidget {
  const CreatePostTagsContainer({
    required this.colours,
    required this.textStyle,
    required this.text,
    required this.onTap,
    required this.typography,
    required this.tags,
    required this.localisations,
    this.isBusy = false,
    super.key,
  });

  final String text;
  final TextStyle textStyle;
  final List<String> tags;
  final Function()? onTap;

  final bool isBusy;

  final DesignColorsModel colours;
  final DesignTypographyModel typography;
  final AppLocalizations localisations;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tagsList = [];

    if (tags.isNotEmpty) {
      tagsList.add(
        CreatePostTagPill(
          tagName: tags.first,
          typography: typography,
          colours: colours,
        ),
      );

      final bool tagsAllow = (tags.length >= 2 && tags.first.length <= 15) && (tags[1].length <= 15);

      if (tags.length == 2 && tagsAllow) {
        tagsList.add(const SizedBox(width: kPaddingExtraSmall));

        tagsList.add(
          CreatePostTagPill(
            tagName: tags[1],
            typography: typography,
            colours: colours,
          ),
        );
      }

      if (tags.length > 2 && !tagsAllow) {
        tagsList.add(const SizedBox(width: kPaddingExtraSmall));

        tagsList.add(
          CreatePostTagPill(
            tagName: localisations.page_create_post_additional_tags((tags.length - 1).toString()),
            typography: typography,
            colours: colours,
          ),
        );
      }
    }

    return PositiveTapBehaviour(
      onTap: onTap,
      isEnabled: !isBusy,
      child: CreatePostBox(
        colours: colours,
        padding: const EdgeInsets.only(right: kPaddingSmallMedium, left: kPaddingLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: textStyle,
            ),
            const Spacer(),
            Row(
              children: tagsList,
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePostTagPill extends StatelessWidget {
  const CreatePostTagPill({
    required this.tagName,
    required this.typography,
    required this.colours,
    super.key,
  });

  final String tagName;
  final DesignTypographyModel typography;
  final DesignColorsModel colours;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kPaddingMedium,
      padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
      decoration: BoxDecoration(
        color: colours.colorGray1,
        borderRadius: BorderRadius.circular(kBorderRadiusLargePlus),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          tagName,
          style: typography.styleSubtextBold.copyWith(color: colours.colorGray7),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class CreatePostMultiImageThumbnailList extends StatelessWidget {
  const CreatePostMultiImageThumbnailList({
    required this.images,
    required this.colours,
    super.key,
  });

  final List<XFile> images;
  final DesignColorsModel colours;

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageWidgets = <Widget>[];
    const double imageSpacing = 35.0;
    const int maxImages = 3;
    final int imageCount = images.length.clamp(1, maxImages);

    Iterable<XFile> imagesThumb = images.take(maxImages);

    for (int i = 0; i < imagesThumb.length; i++) {
      imageWidgets.add(
        CreatePostMultiImageThumbnail(
          image: images[i],
          colours: colours,
        ),
      );
    }

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: kLogoMaximumWidth,
        width: kLogoMaximumWidth + (imageCount - 1) * imageSpacing,
        child: Stack(
          children: [
            for (int i = 0; i < imagesThumb.length; i++)
              Positioned(
                width: kLogoMaximumWidth,
                height: kLogoMaximumWidth,
                right: i * imageSpacing,
                top: kPaddingNone,
                child: imageWidgets[i],
              ),
          ],
        ),
      ),
    );
  }
}

class CreatePostMultiImageThumbnail extends StatelessWidget {
  const CreatePostMultiImageThumbnail({
    required this.image,
    required this.colours,
    super.key,
  });

  final XFile image;
  final DesignColorsModel colours;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kLogoMaximumWidth,
      width: kLogoMaximumWidth,
      padding: const EdgeInsets.all(kBorderThicknessSmall),
      decoration: BoxDecoration(
        color: colours.white,
        borderRadius: BorderRadius.circular(kBorderRadiusInfinite),
      ),
      child: Container(
        padding: const EdgeInsets.all(kBorderThicknessLarge),
        decoration: BoxDecoration(
          color: colours.black,
          borderRadius: BorderRadius.circular(kBorderRadiusInfinite),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kBorderRadiusInfinite),
          child: Image.file(
            File(image.path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
