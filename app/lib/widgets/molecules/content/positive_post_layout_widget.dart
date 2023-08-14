// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:banner_carousel/banner_carousel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/main.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';
import 'package:app/widgets/molecules/content/positive_post_tags.dart';
import 'package:app/widgets/molecules/content/postitive_post_actions.dart';
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
    required this.publisher,
    this.truncatePostText = true,
    this.sidePadding = kPaddingNone,
    this.onImageTap,
    super.key,
  });

  final Activity postContent;
  final Profile? publisher;
  final bool truncatePostText;
  final double sidePadding;

  final void Function(Media media)? onImageTap;

  DesignColorsModel get colours => providerContainer.read(designControllerProvider.select((value) => value.colors));
  DesignTypographyModel get typeography => providerContainer.read(designControllerProvider.select((value) => value.typography));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ActivityGeneralConfigurationType? postType = postContent.generalConfiguration?.type;
    if (postType == null) {
      return const SizedBox.shrink();
    }

    return Material(
      type: MaterialType.transparency,
      child: postType.when<Widget>(
        post: () => _postBuilder(context, ref),
        event: () => _eventBuilder(context, ref),
        clip: () => _clipBuilder(context, ref),
        repost: () => const SizedBox.shrink(),
      ),
    );
  }

  Widget _eventBuilder(BuildContext context, WidgetRef ref) {
    final Logger logger = ref.read(loggerProvider);

    if (postContent.eventConfiguration == null || postContent.enrichmentConfiguration == null) {
      logger.d('postContent does not have eventConfiguration and enrichmentConfiguration');
      return const SizedBox();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //* -=-=-=- Single attached image -=-=-=- *\\
        if (postContent.media.length == 1) ...[
          const SizedBox(height: kPaddingSmall),
        ],
        if (postContent.media.length == 1) ..._postListAttachedImages(),
        //* -=-=-=- Carousel of attached images -=-=-=- *\\
        if (postContent.media.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              return _postCarouselAttachedImages(context, constraints);
            },
          ),

        //* -=-=-=- Post Actions -=-=-=- *\\
        _postActions(),

        //* -=-=-=- Post Title -=-=-=- *\\
        _postTitle(),

        //* -=-=-=- Tags -=-=-=- *\\
        if (postContent.enrichmentConfiguration!.tags.isNotEmpty) ...[
          const SizedBox(height: kPaddingSmall),
          _tags(),
        ],

        //* -=-=-=- Location -=-=-=- *\\
        if (postContent.enrichmentConfiguration!.tags.isNotEmpty) ...[
          const SizedBox(height: kPaddingSmall),
          _location(),
        ],
      ],
    );
  }

  Widget _postBuilder(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //* -=-=-=- Single attached image -=-=-=- *\\
        if (postContent.media.length == 1) ...[
          const SizedBox(height: kPaddingSmall),
        ],
        if (postContent.media.length == 1) ..._postListAttachedImages(),
        //* -=-=-=- Carousel of attached images -=-=-=- *\\
        if (postContent.media.length > 1) ...[
          const SizedBox(height: kPaddingSmall),
          LayoutBuilder(
            builder: (context, constraints) {
              return _postCarouselAttachedImages(context, constraints);
            },
          ),
        ],
        //* -=-=-=- Post Actions -=-=-=- *\\
        _postActions(),
        //* -=-=-=- Markdown body, displayed for video and posts -=-=-=- *\\
        const SizedBox(height: kPaddingSmall),
        _markdownBody(),
      ],
    );
  }

  Widget _clipBuilder(BuildContext context, WidgetRef ref) {
    final Logger logger = ref.read(loggerProvider);

    if (postContent.eventConfiguration != null && postContent.enrichmentConfiguration != null) {
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
          //* -=-=-=- Single attached image -=-=-=- *\\
          if (postContent.media.length == 1) ...[
            const SizedBox(height: kPaddingSmall),
          ],
          if (postContent.media.length == 1) ..._postListAttachedImages(),
          //* -=-=-=- attached video -=-=-=- *\\
          if (postContent.media.isNotEmpty) ...[
            const SizedBox(height: kPaddingSmall),
            LayoutBuilder(
              builder: (context, constraints) {
                return _postCarouselAttachedImages(context, constraints);
              },
            ),
          ],
          _postAttachedVideo(),
          //* -=-=-=- Post Actions -=-=-=- *\\
          _postActions(),
          //* -=-=-=- Post Title -=-=-=- *\\
          _postTitle(),
          //* -=-=-=- Tags -=-=-=- *\\
          if (postContent.enrichmentConfiguration!.tags.isNotEmpty) ...[
            const SizedBox(height: kPaddingSmall),
            _tags(),
          ],
          //* -=-=-=- Location -=-=-=- *\\
          if (postContent.enrichmentConfiguration!.tags.isNotEmpty) ...[
            const SizedBox(height: kPaddingSmall),
            _location(),
          ],
          //* -=-=-=- Markdown body, displayed for video and posts -=-=-=- *\\
          _markdownBody(),
        ],
      ),
    );
  }

  //TODO(S): Partial scaffold for repost, repost functionality not enabled yet
  // Future<Widget> _repostBuilder(BuildContext context, WidgetRef ref) async {
  //   final Logger logger = ref.read(loggerProvider);

  //   if (postContent.eventConfiguration != null && postContent.enrichmentConfiguration != null) {
  //     logger.d('postContent does not have eventConfiguration and enrichmentConfiguration');
  //     return const SizedBox();
  //   }
  //   final ActivitiesController activityController = ref.read(activitiesControllerProvider.notifier);
  //   Activity activity = await activityController.getActivity(postContent.foreignKey);

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: kPaddingExtraSmall),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         //* -=-=-=- attached video -=-=-=- *\\
  //         if (postContent.media.isNotEmpty) ...[
  //           const SizedBox(height: kPaddingSmall),
  //           LayoutBuilder(
  //             builder: (context, constraints) {
  //               return _postCarouselAttachedImages(context, constraints);
  //             },
  //           ),
  //         ],
  //         _postAttachedVideo(),
  //         //* -=-=-=- Post Actions -=-=-=- *\\
  //         _postActions(),
  //         //* -=-=-=- Post Title -=-=-=- *\\
  //         _postTitle(),
  //         //* -=-=-=- Tags -=-=-=- *\\
  //         if (postContent.enrichmentConfiguration!.tags.isNotEmpty) ...[
  //           const SizedBox(height: kPaddingSmall),
  //           _tags(),
  //         ],
  //         //* -=-=-=- Location -=-=-=- *\\
  //         if (postContent.enrichmentConfiguration!.tags.isNotEmpty) ...[
  //           const SizedBox(height: kPaddingSmall),
  //           _location(),
  //         ],
  //         //* -=-=-=- Markdown body, displayed for video and posts -=-=-=- *\\
  //         _markdownBody(),
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
    final Color publisherColour = publisher?.accentColor.toSafeColorFromHex(defaultColor: colours.defualtUserColour) ?? colours.defualtUserColour;

    for (Media media in postContent.media) {
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
    final Color publisherColour = publisher?.accentColor.toSafeColorFromHex(defaultColor: colours.defualtUserColour) ?? colours.defualtUserColour;
    final double height = min(kCarouselMaxHeight, constraints.maxWidth);

    //! For a dynamically sized carousel we would need to convert this to a custom widget
    //? Change the carousel to only be scrolable when the iamge has loaded, and provide the image size to resize the carousel
    //? Calculations for image size are provided in the async function commented out below
    //? I (SC) am happy to do this but this will be a larger job than mvp allows

    for (Media media in postContent.media) {
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
    if (postContent.media.first.type == MediaType.video_link) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: sidePadding),
        child: const SizedBox(),
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
  //* -=-=-=-=-=-  Action Bar, likes, comments bookmark, link, -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget _postActions() {
    //TODO(S): Reenable when other info available
    // final Profile userProfile = ref.watch(profileControllerProvider.select((value) => value.userProfile ?? Profile.empty()));
    // final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: PositivePostActions(
        likes: 0,
        //TODO(S): like enabled and onlike functionality here
        likeEnabled: true,
        onLike: () {},

        //TODO(S): share enabled and on share functionality here
        shareEnabled: true,
        onShare: () {},

        comments: 0,
        //TODO(S): comment enabled and on comment functionality here
        commentsEnabled: true,
        onComment: () {},

        //TODO(S): bookmark enabled and on bookmark functionality here
        bookmarked: true,
        onBookmark: () {},
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
        postContent.eventConfiguration!.name,
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
        tags: postContent.enrichmentConfiguration!.tags,
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
            text: postContent.eventConfiguration!.location,
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
  Widget _markdownBody() {
    String parsedMarkdown = html2md.convert(postContent.generalConfiguration?.content ?? '');
    if (truncatePostText && parsedMarkdown.length > kMaxLengthTruncatedPost) {
      //? Truncate string to max length
      parsedMarkdown = parsedMarkdown.substring(0, kMaxLengthTruncatedPost);
      //? remove until last instance of space to get rid of whole words, remove carrage returns, new lines, and tabs to condense the string
      parsedMarkdown = '${parsedMarkdown.substring(0, parsedMarkdown.lastIndexOf(" ")).replaceAll(RegExp('[\r\n\t]'), '')}...';
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kPaddingSmall + sidePadding),
      child: buildMarkdownWidgetFromBody(parsedMarkdown),
    );
  }
}
