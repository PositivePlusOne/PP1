// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/content/dtos/gallery_entry.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
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
    this.promotionKeyTextController,
    this.onUpdateSaveToGallery,
    this.onUpdateAllowSharing,
    this.onUpdatePromotedPost,
    this.onUpdateVisibleTo,
    this.onUpdateAllowComments,
    this.galleryEntries = const [],
    this.prepopulatedActivity,
    this.valueAllowSharing = false,
    this.valueSaveToGallery = false,
    this.valuePromotedPost = false,
    this.onForceClosePressed,
    this.tags = const [],
    this.trailingWidget,
    this.sharingVisibility = const ActivitySecurityConfigurationMode.public(),
    this.initialValueAllowComments = const ActivitySecurityConfigurationMode.public(),
    super.key,
  });

  final PostType postType;
  final TextEditingController? captionController;
  final TextEditingController? altTextController;
  final TextEditingController? promotionKeyTextController;

  final bool isBusy;

  final List<String> tags;
  final List<GalleryEntry> galleryEntries;

  final Activity? prepopulatedActivity;

  final void Function(BuildContext context) onTagsPressed;
  final Function(BuildContext context)? onUpdateSaveToGallery;
  final Function(BuildContext context)? onUpdateAllowSharing;
  final Function(BuildContext context)? onUpdatePromotedPost;
  final Function(ActivitySecurityConfigurationMode)? onUpdateVisibleTo;
  final Function(ActivitySecurityConfigurationMode)? onUpdateAllowComments;

  final Function()? onForceClosePressed;

  final ActivitySecurityConfigurationMode initialValueAllowComments;
  final ActivitySecurityConfigurationMode sharingVisibility;

  final bool valueAllowSharing;
  final bool valueSaveToGallery;
  final bool valuePromotedPost;

  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (postType == PostType.event) {
      return createEventPostLayout(context, ref); //TODO EVENT LAYOUT
    } else {
      return createPostLayout(context, ref);
    }
  }

  int _getRemainingPromotions(WidgetRef ref) {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final currentProfile = profileController.currentProfile;
    final currentProfileId = profileController.currentProfileId;
    int remainingPromotions = ProfileStatistics.kPromotionsNotPermitted;
    if (null != currentProfile && null != currentProfileId && currentProfile.isOrganisation) {
      // an organisation might be able to create promoted posts, let's get how many they are permitted
      final String expectedStatisticsKey = profileController.buildExpectedStatisticsCacheKey(profileId: profileController.currentProfileId!);
      final CacheController cacheController = ref.read(cacheControllerProvider);
      final ProfileStatistics? profileStatistics = cacheController.get<ProfileStatistics>(expectedStatisticsKey);
      // now we finally have the stats, we can see how many promotions we have remaining
      remainingPromotions = profileStatistics?.promotionsPermitted ?? ProfileStatistics.kPromotionsNotPermitted;
    }
    // returning the result
    return remainingPromotions;
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
    // we also need the number of promotions this user is allowed (-1 if never any)
    final remainingPromotions = _getRemainingPromotions(ref);

    return Container(
      color: colours.black.withAlpha(230),
      child: ListView(
        padding: EdgeInsets.only(bottom: mediaQueryData.padding.bottom + kPaddingMedium),
        children: <Widget>[
          //* -=-=-=-=- Back Button -=-=-=-=- *\\
          PositiveAppBar(
            backgroundColor: colours.transparent,
            foregroundColor: colours.white,
            includeLogoWherePossible: false,
            safeAreaQueryData: mediaQueryData,
            applyLeadingandTrailingPadding: true,
            leading: PositiveButton.appBarIcon(
              colors: colours,
              icon: UniconsLine.angle_left,
              primaryColor: colours.white,
              style: PositiveButtonStyle.outline,
              onTapped: () => router.pop(),
            ),
            trailing: [
              if (onForceClosePressed != null)
                PositiveButton.appBarIcon(
                  colors: colours,
                  icon: UniconsLine.multiply,
                  primaryColor: colours.white,
                  style: PositiveButtonStyle.outline,
                  onTapped: () => onForceClosePressed!(),
                ),
            ],
          ),
          //* -=-=-=-=- Multi Image Thumbnails -=-=-=-=- *\\
          [
            if (galleryEntries.length >= 2) ...<Widget>[
              CreatePostMultiImageThumbnailList(
                images: galleryEntries,
                colours: colours,
              ),
              const SizedBox(height: kPaddingLarge),
            ],
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
              textInputType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: kPaddingSmall),

            //* -=-=-=-=- Tags -=-=-=-=- *\\
            CreatePostTagsContainer(
              text: localisations.page_create_post_tags,
              colours: colours,
              textStyle: textStyle,
              localisations: localisations,
              tags: TagHelpers.filterReservedTagStrings(tags),
              typography: typography,
              isBusy: isBusy,
              onTap: onTagsPressed,
            ),

            //* -=-=-=-=- Alt Text -=-=-=-=- *\\
            //TODO(S): Removed due to lack of alt text on clips
            // if (postType == PostType.image || postType == PostType.clip) ...[
            if (postType == PostType.image) ...[
              const SizedBox(height: kPaddingSmall),
              CreatePostTextField(
                text: localisations.page_create_post_alt_text,
                controller: altTextController,
                colours: colours,
                textStyle: textStyle,
                maxLength: kMaxLengthAltText,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                minLines: 1,
                isBusy: isBusy,
              ),
            ],

            //* -=-=-=-=- Save to Gallery Button -=-=-=-=- *\\
            //? Save to Gallery button removed until save to gallery functionallity added
            // if ((postType == PostType.image || postType == PostType.multiImage || postType == PostType.clip) && onUpdateSaveToGallery != null) ...[
            //   const SizedBox(height: kPaddingSmall),
            //   CreatePostToggleContainer(
            //     value: valueSaveToGallery,
            //     colours: colours,
            //     onTap: isBusy ? (context) {} : onUpdateSaveToGallery,
            //     textStyle: textStyle,
            //     text: localisations.page_create_post_save,
            //   ),
            // ],
            // const SizedBox(height: kPaddingSmall),

            //* -=-=-=-=- Allow Sharing -=-=-=-=- *\\
            if (postType != PostType.repost) ...[
              const SizedBox(height: kPaddingSmall),
              CreatePostToggleContainer(
                value: valueAllowSharing,
                colours: colours,
                onTap: isBusy ? (context) {} : onUpdateAllowSharing,
                textStyle: textStyle,
                text: localisations.page_create_post_allow_sharing,
              ),
              const SizedBox(height: kPaddingSmall),
            ],

            //* -=-=-=-=- Promoted Post -=-=-=-=- *\\
            if (remainingPromotions > 0) ...[
              // only showing if they are permitted
              CreatePostToggleContainer(
                value: valuePromotedPost,
                colours: colours,
                onTap: isBusy ? (context) {} : onUpdatePromotedPost,
                textStyle: textStyle,
                text: localisations.page_create_post_promoted_post(remainingPromotions),
              ),
              const SizedBox(height: kPaddingSmall),
              // and if a promotion, we need the promotion key
              if (valuePromotedPost)
                CreatePostTextField(
                  text: localisations.page_create_post_promotion_key,
                  controller: promotionKeyTextController,
                  colours: colours,
                  textStyle: textStyle,
                  maxLength: kMaxLengthAltText,
                  maxLines: 1,
                  minLines: 1,
                  isBusy: isBusy,
                ),
              const SizedBox(height: kPaddingSmall),
            ],

            //* -=-=-=-=- Sharing Visibility -=-=-=-=- *\\
            CreatePostBox(
              colours: colours,
              forceBorder: true,
              child: PositiveTextFieldDropdown<ActivitySecurityConfigurationMode>(
                labelText: localisations.page_create_post_visibility,
                values: ActivitySecurityConfigurationMode.orderedVisibilityModes,
                initialValue: sharingVisibility,
                valueStringBuilder: (value) => ActivitySecurityConfigurationMode.toVisibilityLocale(value, localisations),
                placeholderStringBuilder: (value) => ActivitySecurityConfigurationMode.toVisibilityLocale(value, localisations),
                onValueChanged: (type) => onUpdateVisibleTo!(type),
                labelTextStyle: typography.styleSubtextBold.copyWith(color: colours.white),
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
              child: PositiveTextFieldDropdown<ActivitySecurityConfigurationMode>(
                labelText: localisations.page_create_post_comments,
                values: ActivitySecurityConfigurationMode.getOrderedCommentModes(isEvent: false),
                initialValue: initialValueAllowComments,
                valueStringBuilder: (value) => ActivitySecurityConfigurationMode.toCommentLocale(value, localisations),
                placeholderStringBuilder: (value) => ActivitySecurityConfigurationMode.toCommentLocale(value, localisations),
                onValueChanged: (type) => onUpdateAllowComments!(type),
                labelTextStyle: typography.styleSubtextBold.copyWith(color: colours.white),
                textStyle: textStyle,
                backgroundColour: colours.transparent,
                iconColour: colours.black,
                iconBackgroundColour: colours.white,
                isEnabled: !isBusy,
              ),
            ),

            //* -=-=-=-=- Post Visibility Warning -=-=-=-=- *\\
            const SizedBox(height: kPaddingMedium),
            if (sharingVisibility == const ActivitySecurityConfigurationMode.public())
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(kPaddingSmall),
                decoration: BoxDecoration(
                  color: colours.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(kBorderRadiusLargePlus),
                  border: Border.all(
                    color: colours.purple,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(UniconsLine.info_circle, color: colours.purple),
                    const SizedBox(width: kPaddingSmall),
                    Flexible(child: Text(localisations.page_create_post_visibility_warning, style: textStyle)),
                  ],
                ),
              ),

            trailingWidget ?? const SizedBox(),
            kCreatePostNavigationHeight.asVerticalBox,
            mediaQueryData.padding.bottom.asVerticalBox,
          ].padded(const EdgeInsets.symmetric(horizontal: kPaddingMedium)),
        ],
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

    // we also need the number of promotions this user is allowed (-1 if never any)
    final remainingPromotions = _getRemainingPromotions(ref);

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
              primaryColor: colours.white,
              icon: UniconsLine.angle_left,
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
                    textInputType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: kPaddingSmall),
                  CreatePostTagsContainer(
                    text: localisations.page_create_post_tags,
                    colours: colours,
                    textStyle: textStyle,
                    localisations: localisations,
                    tags: TagHelpers.filterReservedTagStrings(tags),
                    typography: typography,
                    onTap: onTagsPressed,
                  ),
                  if (postType == PostType.image) ...[
                    const SizedBox(height: kPaddingSmall),
                    CreatePostTextField(
                      text: localisations.page_create_post_alt_text,
                      textCapitalization: TextCapitalization.sentences,
                      controller: altTextController,
                      colours: colours,
                      textStyle: textStyle,
                      maxLength: kMaxLengthAltText,
                      maxLines: 3,
                      minLines: 1,
                    ),
                  ],

                  //* -=-=-=-=- Save to Gallery Button -=-=-=-=- *\\
                  //? Save to Gallery button removed until save to gallery functionallity added
                  // if (postType == PostType.image || postType == PostType.multiImage) ...[
                  //   const SizedBox(height: kPaddingSmall),
                  //   CreatePostToggleContainer(
                  //     value: valueSaveToGallery,
                  //     colours: colours,
                  //     onTap: onUpdateSaveToGallery,
                  //     textStyle: textStyle,
                  //     text: localisations.page_create_post_save,
                  //   ),
                  // ],
                  // const SizedBox(height: kPaddingSmall),

                  //* -=-=-=-=- Allow Sharing -=-=-=-=- *\\
                  if (postType != PostType.repost) ...[
                    CreatePostToggleContainer(
                      value: valueAllowSharing,
                      colours: colours,
                      onTap: onUpdateAllowSharing,
                      textStyle: textStyle,
                      text: localisations.page_create_post_allow_sharing,
                    ),
                    const SizedBox(height: kPaddingSmall),
                  ],
                  //* -=-=-=-=- Promoted Post -=-=-=-=- *\\
                  if (remainingPromotions > 0) ...[
                    // only showing if they are permitted
                    CreatePostToggleContainer(
                      value: valuePromotedPost,
                      colours: colours,
                      onTap: onUpdatePromotedPost,
                      textStyle: textStyle,
                      text: localisations.page_create_post_promoted_post(remainingPromotions),
                    ),
                    const SizedBox(height: kPaddingSmall),
                    // and if a promotion, we need the promotion key
                    if (valuePromotedPost)
                      CreatePostTextField(
                        text: localisations.page_create_post_promotion_key,
                        controller: promotionKeyTextController,
                        colours: colours,
                        textStyle: textStyle,
                        maxLength: kMaxLengthAltText,
                        maxLines: 1,
                        minLines: 1,
                        isBusy: isBusy,
                      ),
                    const SizedBox(height: kPaddingSmall),
                  ],
                  CreatePostBox(
                    colours: colours,
                    forceBorder: true,
                    child: PositiveTextFieldDropdown<ActivitySecurityConfigurationMode>(
                      labelText: localisations.page_create_post_visibility,
                      onValueChanged: (type) => onUpdateVisibleTo!(type),
                      values: ActivitySecurityConfigurationMode.orderedVisibilityModes,
                      initialValue: sharingVisibility,
                      labelTextStyle: typography.styleSubtextBold.copyWith(color: colours.white),
                      valueStringBuilder: (value) => ActivitySecurityConfigurationMode.toVisibilityLocale(value, localisations),
                      placeholderStringBuilder: (value) => ActivitySecurityConfigurationMode.toVisibilityLocale(value, localisations),
                      textStyle: textStyle,
                      backgroundColour: colours.transparent,
                      iconColour: colours.black,
                      iconBackgroundColour: colours.white,
                      isEnabled: !isBusy,
                    ),
                  ),
                  const SizedBox(height: kPaddingSmall),
                  CreatePostBox(
                    colours: colours,
                    forceBorder: true,
                    child: PositiveTextFieldDropdown<ActivitySecurityConfigurationMode>(
                      labelText: localisations.page_create_post_comments,
                      values: ActivitySecurityConfigurationMode.getOrderedCommentModes(isEvent: true),
                      initialValue: initialValueAllowComments,
                      valueStringBuilder: (value) => ActivitySecurityConfigurationMode.toCommentLocale(value, localisations),
                      placeholderStringBuilder: (value) => ActivitySecurityConfigurationMode.toCommentLocale(value, localisations),
                      onValueChanged: (type) => onUpdateAllowComments!(type),
                      labelTextStyle: typography.styleSubtextBold.copyWith(color: colours.white),
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

class CreatePostTextField extends StatefulWidget {
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
    this.textInputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
  });

  final DesignColorsModel colours;
  final int minLines;
  final int maxLines;
  final TextStyle textStyle;
  final String text;
  final TextEditingController? controller;
  final int? maxLength;
  final bool isBusy;
  final TextInputType textInputType;
  final TextCapitalization textCapitalization;

  @override
  State<CreatePostTextField> createState() => _CreatePostTextFieldState();
}

class _CreatePostTextFieldState extends State<CreatePostTextField> {
  @override
  Widget build(BuildContext context) {
    return CreatePostBox(
      colours: widget.colours,
      child: PositiveTextField(
        labelText: widget.text,
        textStyle: widget.textStyle,
        labelStyle: widget.textStyle,
        textEditingController: widget.controller,
        onTextChanged: (_) => setStateIfMounted(),
        showRemainingStyle: widget.textStyle.copyWith(color: widget.colours.colorGray3),
        fillColor: widget.colours.transparent,
        tintColor: widget.colours.white,
        borderRadius: kBorderRadiusLargePlus,
        isEnabled: !widget.isBusy,
        showRemaining: true,
        maxLength: widget.maxLength,
        maxLengthEnforcement: widget.maxLength != null ? MaxLengthEnforcement.enforced : MaxLengthEnforcement.none,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        textInputType: widget.textInputType,
        textCapitalization: widget.textCapitalization,
        allowMentions: true,
        searchResultsBrightness: Brightness.dark,
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
    this.enabled = true,
  });

  final DesignColorsModel colours;
  final TextStyle textStyle;
  final String text;
  final bool value;
  final bool enabled;
  final Function(BuildContext context)? onTap;

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
              isEnabled: enabled,
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
  final Function(BuildContext context)? onTap;

  final bool isBusy;

  final DesignColorsModel colours;
  final DesignTypographyModel typography;
  final AppLocalizations localisations;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tagsList = <Widget>[];
    final bool tagsAllow = (tags.length >= 2 && tags.first.length <= 15) && (tags[1].length <= 15);

    if (tags.isNotEmpty) {
      tagsList.add(
        CreatePostTagPill(
          tagName: tags[0],
          typography: typography,
          colours: colours,
        ),
      );
    }

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

    if (tags.length > 2 || (tags.length == 2 && !tagsAllow)) {
      tagsList.add(const SizedBox(width: kPaddingExtraSmall));

      tagsList.add(
        CreatePostTagPill(
          tagName: localisations.page_create_post_additional_tags((tags.length - 1).toString()),
          typography: typography,
          colours: colours,
        ),
      );
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
            Row(children: tagsList),
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

  final List<GalleryEntry> images;
  final DesignColorsModel colours;

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageWidgets = <Widget>[];
    const double imageSpacing = 35.0;
    const int maxImages = 3;
    final int imageCount = images.length.clamp(1, maxImages);

    Iterable<GalleryEntry> imagesThumb = images.take(maxImages);

    for (int i = 0; i < imagesThumb.length; i++) {
      imageWidgets.add(
        CreatePostMultiImageThumbnail(
          entry: images[i],
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
    required this.entry,
    required this.colours,
    super.key,
  });

  final GalleryEntry entry;
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
          child: Image.memory(
            entry.data ?? Uint8List(0),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
