// Dart imports:
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

// Flutter imports:
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/atoms/video/positive_video_player.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:banner_carousel/banner_carousel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:unicons/unicons.dart';
import 'package:video_player/video_player.dart';

// Project imports:
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/content/positive_post_actions.dart';
import 'package:app/widgets/molecules/content/positive_post_tags.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/database/activities/activities.dart';
import '../../../dtos/database/profile/profile.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';
import '../../../services/third_party.dart';
import '../../atoms/indicators/positive_loading_indicator.dart';

class PositivePostLayoutWidget extends HookConsumerWidget {
  const PositivePostLayoutWidget({
    required this.postContent,
    required this.publisherProfile,
    required this.publisherRelationship,
    this.promotion,
    this.tags = const [],
    this.isShortformPost = true,
    this.isShared = false,
    this.sidePadding = kPaddingSmall,
    this.isBusy = false,
    this.likesEnabled = true,
    this.bookmarkEnabled = true,
    this.onImageTap,
    required this.isLiked,
    required this.onLike,
    required this.onComment,
    required this.totalLikes,
    required this.onBookmark,
    required this.isBookmarked,
    required this.totalComments,
    this.onPostPageRequested,
    super.key,
  });

  final Activity? postContent;
  final Profile? publisherProfile;
  final Relationship? publisherRelationship;
  final Promotion? promotion;
  final List<String> tags;

  final bool isShortformPost;
  final bool isShared;
  final double sidePadding;

  final bool isBusy;
  final bool likesEnabled;
  final bool bookmarkEnabled;

  final FutureOr<void> Function(BuildContext context)? onPostPageRequested;

  final void Function(Media media)? onImageTap;

  final bool isLiked;
  final int totalLikes;
  final FutureOr<void> Function(BuildContext context)? onLike;
  final FutureOr<void> Function(BuildContext context)? onComment;

  final bool isBookmarked;
  final FutureOr<void> Function(BuildContext context)? onBookmark;

  final int totalComments;

  DesignColorsModel get colours => providerContainer.read(designControllerProvider.select((value) => value.colors));
  DesignTypographyModel get typeography => providerContainer.read(designControllerProvider.select((value) => value.typography));

  /// return if this layout is for an activity that is 'promoted'
  bool get _isPromoted =>

      // we are promoted when there is a promotion or there is a tag that signals that it is
      promotion != null || tags.indexWhere((tag) => TagHelpers.isPromoted(tag)) != -1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ActivityGeneralConfigurationType? postType = postContent?.generalConfiguration?.type;
    if (postType == null) {
      return const SizedBox.shrink();
    }

    return Material(
      type: MaterialType.transparency,
      child: postType.when<Widget>(
        post: () => _postBuilder(context: context, ref: ref, currentProfile: publisherProfile, publisherRelationship: publisherRelationship),
        event: () => _eventBuilder(context: context, ref: ref, currentProfile: publisherProfile, publisherRelationship: publisherRelationship),
        clip: () => _clipBuilder(context: context, ref: ref, currentProfile: publisherProfile, publisherRelationship: publisherRelationship),
        repost: () => const SizedBox.shrink(),
      ),
    );
  }

  Widget _eventBuilder({
    required BuildContext context,
    required WidgetRef ref,
    required Profile? currentProfile,
    required Relationship? publisherRelationship,
  }) {
    final Logger logger = ref.read(loggerProvider);

    if (postContent?.eventConfiguration == null || postContent?.enrichmentConfiguration == null) {
      logger.d('postContent does not have eventConfiguration and enrichmentConfiguration');
      return const SizedBox();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //* -=-=-=- Single attached image -=-=-=- *\\
        if (postContent?.media.length == 1) ...[
          const SizedBox(height: kPaddingSmall),
        ],
        if (postContent?.media.length == 1) ..._postListAttachedImages(),
        //* -=-=-=- Carousel of attached images -=-=-=- *\\
        if (postContent?.media.isNotEmpty ?? false) ...[
          LayoutBuilder(
            builder: (context, constraints) {
              return _postCarouselAttachedImages(context, constraints);
            },
          ),

          //* -=-=-=- Post Actions -=-=-=- *\\
          _postActions(context: context, ref: ref, currentProfile: currentProfile, publisherRelationship: publisherRelationship),

          //* -=-=-=- Post Title -=-=-=- *\\
          _postTitle(),

          //* -=-=-=- Tags -=-=-=- *\\
          if (postContent?.enrichmentConfiguration!.tags.isNotEmpty ?? false) ...[
            const SizedBox(height: kPaddingSmall),
            _tags(),
          ],

          //* -=-=-=- Location -=-=-=- *\\
          if (postContent?.enrichmentConfiguration!.tags.isNotEmpty ?? false) ...[
            const SizedBox(height: kPaddingSmall),
            _location(),
          ],
        ],
      ],
    );
  }

  Widget _postBuilder({
    required BuildContext context,
    required WidgetRef ref,
    required Profile? currentProfile,
    required Relationship? publisherRelationship,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //* -=-=-=- Single attached image -=-=-=- *\\
        if (postContent?.media.isNotEmpty ?? false) ...[
          const SizedBox(height: kPaddingSmall),
        ],
        // put the image in a stack
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            if (postContent?.media.length == 1 || !isShortformPost)
              Column(
                children: [
                  ..._postListAttachedImages(),
                ],
              ),
            //* -=-=-=- Carousel of attached images -=-=-=- *\\
            if ((postContent?.media.length ?? 0) > 1 && isShortformPost)
              LayoutBuilder(
                builder: (context, constraints) {
                  return _postCarouselAttachedImages(context, constraints);
                },
              ),
            //* -=-=-=- promotion banner -=-=-=- *\\
            if (_isPromoted) _promotionBanner(),
          ],
        ),
        //* -=-=-=- Post Actions -=-=-=- *\\
        _postActions(context: context, ref: ref, currentProfile: currentProfile, publisherRelationship: publisherRelationship),
        //* -=-=-=- Markdown body, displayed for video and posts -=-=-=- *\\
        _markdownBody(context: context, ref: ref),
        //* -=-=-=- tags -=-=-=- *\\
        //! currently not in the design (want a bold #hashtag display of tags in the text apparently) DOUG - don't get how to do that so commenting out
        // if (postContent?.enrichmentConfiguration!.tags.isNotEmpty ?? false)
        //   // doing a row in order to center-align the list of tags
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       //! pretty sure this doesn't work for a long list though as the scroll view isn't constrained in an expanded )O:
        //       _tags(),
        //     ],
        //   ),
      ],
    );
  }

  Widget _clipBuilder({
    required BuildContext context,
    required WidgetRef ref,
    required Profile? currentProfile,
    required Relationship? publisherRelationship,
  }) {
    final Logger logger = ref.read(loggerProvider);

    if (postContent?.eventConfiguration != null && postContent?.enrichmentConfiguration != null) {
      logger.d('postContent does not have eventConfiguration and enrichmentConfiguration');
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingExtraSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //* -=-=-=- attached video -=-=-=- *\\
          _postAttachedVideo(),
          //* -=-=-=- promotion banner -=-=-=- *\\
          if (promotion != null) ...[
            const SizedBox(height: kPaddingSmall),
            _promotionBanner(),
          ],
          //* -=-=-=- Post Actions -=-=-=- *\\
          _postActions(context: context, ref: ref, currentProfile: currentProfile, publisherRelationship: publisherRelationship),
          //* -=-=-=- Markdown body, displayed for video and posts -=-=-=- *\\
          _markdownBody(context: context, ref: ref),
        ],
      ),
    );
  }

  //TODO(S): Partial scaffold for repost, repost functionality moved to another file
  // Future<Widget> _repostBuilder(
  //   BuildContext context,
  //   WidgetRef ref,
  //   Profile? currentProfile,
  //   Relationship? publisherRelationship,
  // ) async {
  //   final Logger logger = ref.read(loggerProvider);

  //   if (postContent != null && postContent!.generalConfiguration != null && postContent!.enrichmentConfiguration != null) {
  //     logger.d('widget.postContent does not have generalConfiguration and enrichmentConfiguration');
  //     return const SizedBox();
  //   }

  //   // if (postContent?.generalConfiguration!.repostActivityId.isNotEmpty) {
  //   //   logger.d('widget.postContent is missing repost data');
  //   //   return const SizedBox();
  //   // }

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: kPaddingExtraSmall),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         //* -=-=-=- attached video -=-=-=- *\\
  //         if (postContent!.media.isNotEmpty) ...[
  //           const SizedBox(height: kPaddingSmall),
  //           LayoutBuilder(
  //             builder: (context, constraints) {
  //               return _postCarouselAttachedImages(context, constraints);
  //             },
  //           ),
  //         ],
  //         _postAttachedVideo(),
  //         //* -=-=-=- Post Actions -=-=-=- *\\
  //         _postActions(context: context, ref: ref, currentProfile: currentProfile, publisherRelationship: publisherRelationship),
  //         //* -=-=-=- Post Title -=-=-=- *\\
  //         _postTitle(),
  //         //* -=-=-=- Tags -=-=-=- *\\
  //         if (postContent!.enrichmentConfiguration!.tags.isNotEmpty) ...[
  //           const SizedBox(height: kPaddingSmall),
  //           _tags(),
  //         ],
  //         //* -=-=-=- Location -=-=-=- *\\
  //         if (postContent!.enrichmentConfiguration!.tags.isNotEmpty) ...[
  //           const SizedBox(height: kPaddingSmall),
  //           _location(),
  //         ],
  //         //* -=-=-=- Markdown body, displayed for video and posts -=-=-=- *\\
  //         _markdownBody(context: context, ref: ref),
  //       ],
  //     ),
  //   );
  // }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-            List of attached images           -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  // ignore: unused_element
  List<Widget> _postListAttachedImages() {
    final List<Widget> imageWidgetList = [];
    final Color publisherColour = publisherProfile?.accentColor.toSafeColorFromHex(defaultColor: colours.defaultUserColour) ?? colours.defaultUserColour;

    for (Media media in postContent?.media ?? []) {
      if (media.type == MediaType.photo_link || media.type == MediaType.bucket_path) {
        imageWidgetList.add(
          Container(
            constraints: const BoxConstraints(
              maxHeight: kCarouselMaxHeight,
              minHeight: kCarouselMaxHeight,
              minWidth: double.infinity,
            ),
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            child: ClipRRect(
              borderRadius: sidePadding > 0 ? BorderRadius.circular(kBorderRadiusLarge) : BorderRadius.zero,
              child: PositiveMediaImage(
                fit: BoxFit.cover,
                media: media,
                onTap: () => onImageTap?.call(media),
                thumbnailTargetSize: PositiveThumbnailTargetSize.extraLarge,
                placeholderBuilder: (context) => Align(
                  alignment: Alignment.center,
                  child: PositiveLoadingIndicator(
                    width: kIconSmall,
                    color: publisherColour.complimentTextColor,
                  ),
                ),
                errorBuilder: (_) => _errorLoadingImageWidget(),
              ),
            ),
          ),
        );
        imageWidgetList.add(
          const SizedBox(height: kBorderThicknessMedium),
        );
      }
    }

    return imageWidgetList;
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-          Carousel of attached images         -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget _postCarouselAttachedImages(BuildContext context, BoxConstraints constraints) {
    final List<Widget> listBanners = [];
    final Color publisherColour = publisherProfile?.accentColor.toSafeColorFromHex(defaultColor: colours.defaultUserColour) ?? colours.defaultUserColour;
    final double height = min(kCarouselMaxHeight, constraints.maxWidth);

    //! For a dynamically sized carousel we would need to convert this to a custom widget
    //? Change the carousel to only be scrolable when the iamge has loaded, and provide the image size to resize the carousel
    //? Calculations for image size are provided in the async function commented out below
    //? I (SC) am happy to do this but this will be a larger job than mvp allows

    for (Media media in postContent?.media ?? []) {
      if (media.type == MediaType.photo_link || media.type == MediaType.bucket_path) {
        listBanners.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kBorderRadiusLarge),
              child: PositiveMediaImage(
                height: kPaddingExtraLarge,
                fit: BoxFit.cover,
                media: media,
                onTap: () => onImageTap?.call(media),
                thumbnailTargetSize: PositiveThumbnailTargetSize.extraLarge,
                placeholderBuilder: (context) => Align(
                  alignment: Alignment.center,
                  child: PositiveLoadingIndicator(
                    width: kIconSmall,
                    color: publisherColour.complimentTextColor,
                  ),
                ),
                errorBuilder: (_) => _errorLoadingImageWidget(),
              ),
            ),
          ),
        );
      }
    }
    return BannerCarousel(
      customizedBanners: listBanners,
      customizedIndicators: const IndicatorModel.animation(
        width: kPaddingExtraSmall,
        height: kPaddingExtraSmall,
        spaceBetween: kPaddingExtraSmall,
        widthAnimation: kPaddingSmall,
        heightAnimation: kPaddingSmall,
      ),
      height: height,
      margin: EdgeInsets.zero,
      activeColor: colours.white,
      disableColor: colours.white.withOpacity(kOpacityHalf),
      animation: true,
      borderRadius: kBorderRadiusHuge,
      indicatorBottom: false,
    );
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-          Calculate Image Dimensions          -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\

  // Future<Size> _calculateImageDimension(String imageURL) async {
  //   Completer<Size> completer = Completer();
  //   Image image = Image(image: FastCachedImageProvider(imageURL)); // I modified this line
  //   image.image.resolve(ImageConfiguration()).addListener(
  //     ImageStreamListener(
  //       (ImageInfo image, bool synchronousCall) {
  //         var myImage = image.image;
  //         Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
  //         completer.complete(size);
  //       },
  //     ),
  //   );
  //   return completer.future;
  // }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-                Attached Video                -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget _postAttachedVideo() {
    //TODO(S): embed clips
    final Media? media = postContent?.media.first;
    if (media != null && media.type == MediaType.bucket_path) {
      // final CacheController cacheController = providerContainer.read(cacheControllerProvider);
      // final String expectedCacheKey = buildCacheKey(widget.media, widget.thumbnailTargetSize);
      // final Uint8List? cachedBytes = cacheController.get(expectedCacheKey);
      // final String mimeType = lookupMimeType(media!.name, headerBytes: bytes) ?? '';

      return Container(
        width: double.infinity,
        height: 500,
        color: colours.red,
        child: PositiveVideoPlayer(media: media),
      );
    }
    return const SizedBox();
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-         error laoding video or image         -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget _errorLoadingImageWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: const SizedBox(),
    );
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-                Promotion Banner               -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget _promotionBanner() {
    final String link = promotion?.link ?? '';
    final String linkText = promotion?.linkText ?? appLocalizations.post_promoted_link_label;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: PositiveGlassSheet(
        children: [
          PositiveButton(
            onTapped: () {
              // we can only nav away to another page if there is one
              if (link.isNotEmpty) {
                link.attemptToLaunchURL();
              }
            },
            colors: colours,
            primaryColor: colours.black,
            label: linkText,
            size: PositiveButtonSize.small,
            style: PositiveButtonStyle.primary,
            layout: PositiveButtonLayout.iconRight,
            // and if there is a link - hint that we can go to it
            icon: link.isNotEmpty ? Icons.navigate_next : null,
          ),
        ],
      ),
    );
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-  Action Bar, likes, comments bookmark, link, -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget _postActions({
    required BuildContext context,
    required WidgetRef ref,
    required Profile? currentProfile,
    required Relationship? publisherRelationship,
  }) {
    if (isShared) {
      return const SizedBox.shrink();
    }

    final String currentProfileId = ref.read(profileControllerProvider.notifier.select((value) => value.currentProfileId)) ?? '';
    final String publisherId = postContent?.publisherInformation?.publisherId ?? '';

    final ActivitySecurityConfigurationMode shareMode = postContent?.securityConfiguration?.shareMode ?? const ActivitySecurityConfigurationMode.disabled();

    final bool canActShare = shareMode.canActOnActivity(activity: postContent, currentProfile: currentProfile, publisherRelationship: publisherRelationship);
    final bool isPublisher = currentProfileId == publisherId;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: PositivePostActions(
        //TODO(S): like enabled and onlike functionality here
        isLiked: isLiked,
        likes: totalLikes,
        likesEnabled: !isBusy && !isPublisher && likesEnabled,
        onLike: onLike,

        //TODO(S): share enabled and on share functionality here
        shareEnabled: !isBusy && canActShare,
        onShare: (context) => postContent?.share(context, currentProfile),

        //TODO(S): comment enabled and on comment functionality here
        comments: totalComments,
        commentsEnabled: !isBusy,
        onComment: onComment,

        //TODO(S): bookmark enabled and on bookmark functionality here
        bookmarkEnabled: !isBusy && bookmarkEnabled,
        bookmarked: isBookmarked,
        onBookmark: onBookmark,
      ),
    );
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-     Post Title, only displayed for events    -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget _postTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kPaddingSmall + sidePadding),
      child: Text(
        postContent?.eventConfiguration?.name ?? '',
        //TODO(S): this needs to be updated for non-left-to-right languages
        textAlign: TextAlign.left,
        style: typeography.styleTitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-         Tags and location information        -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget _tags() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kPaddingSmall + sidePadding),
      child: PositivePostHorizontalTags(
        tags: postContent?.enrichmentConfiguration?.tags ?? [],
        typeography: typeography,
        colours: colours,
      ),
    );
  }

  Widget _location() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kPaddingSmall + sidePadding),
      child: Row(
        children: [
          PositivePostIconTag(
            text: postContent?.eventConfiguration?.location ?? '',
            forwardIcon: UniconsLine.map_marker,
            typeography: typeography,
            colours: colours,
          ),
        ],
      ),
    );
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=- Markdown body, displayed for video and posts -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget _markdownBody({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    String parsedMarkdown = html2md.convert(
      //TODO(S): either fork the package, find a new one, or replace the whole markdown idea to get around some hard coded issues
      //? This is purest Jank, replace \n with an unusual string until after the markdown conversion as the converter is hardcoded to remove all whitespace
      postContent?.generalConfiguration?.content.replaceAll("\n", ":Carriage Return:") ?? '',
    );
    if (isShortformPost && parsedMarkdown.length > kMaxLengthTruncatedPost) {
      parsedMarkdown = parsedMarkdown.substring(0, kMaxLengthTruncatedPost);
      parsedMarkdown = '${parsedMarkdown.substring(0, parsedMarkdown.lastIndexOf(" ")).replaceAll(RegExp('[\r\n\t]'), '')}...';
    }

    final TagsController tagsController = ref.read(tagsControllerProvider.notifier);
    final List<Tag> tags = tagsController.resolveTags(postContent?.enrichmentConfiguration?.tags ?? []);

    return PositiveTapBehaviour(
      onTap: onPostPageRequested,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kPaddingMedium + sidePadding),
        child: buildMarkdownWidgetFromBody(parsedMarkdown.replaceAll(":Carriage Return:", "\n"), tags: tags),
      ),
    );
  }
}
