// Dart imports:
import 'dart:async';
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
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
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

class PositivePostLayoutWidget extends StatefulHookConsumerWidget {
  const PositivePostLayoutWidget({
    required this.postContent,
    required this.publisher,
    this.origin,
    this.isShortformPost = true,
    this.isShared = false,
    this.sidePadding = kPaddingSmall,
    this.isBusy = false,
    this.onImageTap,
    required this.isLiked,
    required this.onLike,
    required this.totalLikes,
    required this.onBookmark,
    required this.isBookmarked,
    required this.totalComments,
    this.onPostPageRequested,
    super.key,
  });

  final Activity postContent;
  final String? origin;

  final Profile? publisher;
  final bool isShortformPost;
  final bool isShared;
  final double sidePadding;

  final bool isBusy;

  final FutureOr<void> Function(BuildContext context)? onPostPageRequested;

  final void Function(Media media)? onImageTap;

  final bool isLiked;
  final int totalLikes;
  final Future<void> Function(BuildContext context)? onLike;

  final bool isBookmarked;
  final Future<void> Function(BuildContext context)? onBookmark;

  final int totalComments;

  @override
  ConsumerState<PositivePostLayoutWidget> createState() => _PositivePostLayoutWidgetState();
}

class _PositivePostLayoutWidgetState extends ConsumerState<PositivePostLayoutWidget> {
  DesignColorsModel get colours => providerContainer.read(designControllerProvider.select((value) => value.colors));
  DesignTypographyModel get typeography => providerContainer.read(designControllerProvider.select((value) => value.typography));

  late double sidePadding;

  @override
  void initState() {
    super.initState();
    sidePadding = widget.isShortformPost ? widget.sidePadding : kPaddingNone;
  }

  @override
  Widget build(BuildContext context) {
    final ActivityGeneralConfigurationType? postType = widget.postContent.generalConfiguration?.type;
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

    if (widget.postContent.eventConfiguration == null || widget.postContent.enrichmentConfiguration == null) {
      logger.d('postContent does not have eventConfiguration and enrichmentConfiguration');
      return const SizedBox();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //* -=-=-=- Single attached image -=-=-=- *\\
        if (widget.postContent.media.length == 1) ...[
          const SizedBox(height: kPaddingSmall),
        ],
        if (widget.postContent.media.length == 1) ..._postListAttachedImages(),
        //* -=-=-=- Carousel of attached images -=-=-=- *\\
        if (widget.postContent.media.isNotEmpty)
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
        if (widget.postContent.enrichmentConfiguration!.tags.isNotEmpty) ...[
          const SizedBox(height: kPaddingSmall),
          _tags(),
        ],

        //* -=-=-=- Location -=-=-=- *\\
        if (widget.postContent.enrichmentConfiguration!.tags.isNotEmpty) ...[
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
      children: <Widget>[
        //* -=-=-=- Single attached image -=-=-=- *\\
        if (widget.postContent.media.isNotEmpty) ...[
          const SizedBox(height: kPaddingSmall),
        ],
        if (widget.postContent.media.length == 1 || !widget.isShortformPost) ...<Widget>[
          ..._postListAttachedImages(),
        ],
        //* -=-=-=- Carousel of attached images -=-=-=- *\\
        if (widget.postContent.media.length > 1 && widget.isShortformPost) ...[
          LayoutBuilder(
            builder: (context, constraints) {
              return _postCarouselAttachedImages(context, constraints);
            },
          ),
        ],
        //* -=-=-=- Post Actions -=-=-=- *\\
        _postActions(),
        //* -=-=-=- Markdown body, displayed for video and posts -=-=-=- *\\
        _markdownBody(),
      ],
    );
  }

  Widget _clipBuilder(BuildContext context, WidgetRef ref) {
    final Logger logger = ref.read(loggerProvider);

    if (widget.postContent.eventConfiguration != null && widget.postContent.enrichmentConfiguration != null) {
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
          if (widget.postContent.media.length == 1) ...[
            const SizedBox(height: kPaddingSmall),
          ],
          if (widget.postContent.media.length == 1) ..._postListAttachedImages(),
          //* -=-=-=- attached video -=-=-=- *\\
          if (widget.postContent.media.isNotEmpty) ...[
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
          if (widget.postContent.enrichmentConfiguration!.tags.isNotEmpty) ...[
            const SizedBox(height: kPaddingSmall),
            _tags(),
          ],
          //* -=-=-=- Location -=-=-=- *\\
          if (widget.postContent.enrichmentConfiguration!.tags.isNotEmpty) ...[
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
    final Color publisherColour = widget.publisher?.accentColor.toSafeColorFromHex(defaultColor: colours.defaultUserColour) ?? colours.defaultUserColour;

    for (Media media in widget.postContent.media) {
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
                onTap: () => widget.onImageTap?.call(media),
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
    final Color publisherColour = widget.publisher?.accentColor.toSafeColorFromHex(defaultColor: colours.defaultUserColour) ?? colours.defaultUserColour;
    final double height = min(kCarouselMaxHeight, constraints.maxWidth);

    //! For a dynamically sized carousel we would need to convert this to a custom widget
    //? Change the carousel to only be scrolable when the iamge has loaded, and provide the image size to resize the carousel
    //? Calculations for image size are provided in the async function commented out below
    //? I (SC) am happy to do this but this will be a larger job than mvp allows

    for (Media media in widget.postContent.media) {
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
    if (widget.postContent.media.first.type == MediaType.video_link) {
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
    final bool isShared = widget.isShared;
    if (isShared) {
      return const SizedBox.shrink();
    }

    final Activity activity = widget.postContent;
    final String currentProfileId = ref.read(profileControllerProvider.notifier.select((value) => value.currentProfileId)) ?? '';
    final String publisherId = activity.publisherInformation?.publisherId ?? '';

    final ActivitySecurityConfigurationMode shareMode = activity.securityConfiguration?.shareMode ?? const ActivitySecurityConfigurationMode.disabled();

    final bool canActShare = shareMode.canActOnActivity(activity.flMeta?.id ?? '');
    final bool isPublisher = currentProfileId == publisherId;
    final bool canShare = canActShare && !isPublisher;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: PositivePostActions(
        //TODO(S): like enabled and onlike functionality here
        isLiked: widget.isLiked,
        likes: widget.totalLikes,
        likesEnabled: !widget.isBusy && !isPublisher,
        onLike: widget.onLike,

        //TODO(S): share enabled and on share functionality here
        shareEnabled: !widget.isBusy && canShare,
        onShare: (context) => widget.postContent.share(context),

        //TODO(S): comment enabled and on comment functionality here
        comments: widget.totalComments,
        commentsEnabled: !widget.isBusy,
        onComment: (_) {},

        //TODO(S): bookmark enabled and on bookmark functionality here
        bookmarkEnabled: !widget.isBusy,
        bookmarked: widget.isBookmarked,
        onBookmark: widget.onBookmark,
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
        widget.postContent.eventConfiguration!.name,
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
        tags: widget.postContent.enrichmentConfiguration!.tags,
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
            text: widget.postContent.eventConfiguration!.location,
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
    String parsedMarkdown = html2md.convert(
      //TODO(S): either fork the package, find a new one, or replace the whole markdown idea to get around some hard coded issues
      //? This is purest Jank, replace \n with an unusual string until after the markdown conversion as the converter is hardcoded to remove all whitespace
      widget.postContent.generalConfiguration?.content.replaceAll("\n", ":Carriage Return:") ?? '',
    );
    if (widget.isShortformPost && parsedMarkdown.length > kMaxLengthTruncatedPost) {
      parsedMarkdown = parsedMarkdown.substring(0, kMaxLengthTruncatedPost);
      parsedMarkdown = '${parsedMarkdown.substring(0, parsedMarkdown.lastIndexOf(" ")).replaceAll(RegExp('[\r\n\t]'), '')}...';
    }

    final TagsController tagsController = ref.read(tagsControllerProvider.notifier);
    final List<Tag> tags = tagsController.resolveTags(widget.postContent.enrichmentConfiguration?.tags ?? []);

    return PositiveTapBehaviour(
      onTap: widget.onPostPageRequested,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kPaddingMedium + sidePadding),
        child: buildMarkdownWidgetFromBody(parsedMarkdown.replaceAll(":Carriage Return:", "\n"), tags: tags),
      ),
    );
  }
}
