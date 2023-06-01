import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:app/dtos/database/common/media.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/widgets/molecules/content/positive_post_tags.dart';
import 'package:app/widgets/molecules/content/postitive_post_actions.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/design_constants.dart';
import '../../../dtos/database/activities/activities.dart';
import '../../../dtos/database/profile/profile.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/profiles/profile_controller.dart';
import '../../../providers/system/design_controller.dart';
import '../../../services/third_party.dart';
import '../../atoms/indicators/positive_loading_indicator.dart';

class PositivePostLayoutWidget extends HookConsumerWidget {
  PositivePostLayoutWidget({
    required this.postContent,
    required this.publisher,
    this.fullScreenView = false,
    super.key,
  });

  final Activity postContent;
  final Profile? publisher;
  final bool fullScreenView;

  late final DesignColorsModel colours;
  late final DesignTypographyModel typeography;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    colours = ref.read(designControllerProvider.select((value) => value.colors));
    typeography = ref.watch(designControllerProvider.select((value) => value.typography));

    //TODO(S): malformed post should be ignored or error
    if (postContent.generalConfiguration == null) {
      return Text(
        postContent.toString(),
      );
    }

    if ((postContent.generalConfiguration!.type == const ActivityGeneralConfigurationType.event())) {
      return _eventBuilder(context, ref);
    }

    if ((postContent.generalConfiguration!.type == const ActivityGeneralConfigurationType.post())) {
      return _postBuilder(context, ref);
    }

    if ((postContent.generalConfiguration!.type == const ActivityGeneralConfigurationType.clip())) {
      return _clipBuilder(context, ref);
    }

    //TODO(S): malformed post should be ignored or error
    return Text(
      postContent.toString(),
    );
  }

  Widget _eventBuilder(BuildContext context, WidgetRef ref) {
    final Logger logger = ref.read(loggerProvider);

    if (postContent.eventConfiguration == null || postContent.enrichmentConfiguration == null) {
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
          //* -=-=-=- Carousel of attached images -=-=-=- *\\
          if (postContent.media.isNotEmpty) ...[
            const SizedBox(height: kPaddingSmall),
            _postCarouselAttachedImages(
              context,
            ),
          ],
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
      ),
    );
  }

  Widget _postBuilder(BuildContext context, WidgetRef ref) {
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
          //* -=-=-=- Carousel of attached images -=-=-=- *\\
          if (postContent.media.isNotEmpty) ...[
            const SizedBox(height: kPaddingSmall),
            _postCarouselAttachedImages(context),
          ],
          //* -=-=-=- Post Actions -=-=-=- *\\
          _postActions(),
          //* -=-=-=- Markdown body, displayed for video and posts -=-=-=- *\\
          const SizedBox(height: kPaddingSmall),
          _markdownBody(),
        ],
      ),
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
          //* -=-=-=- attached video -=-=-=- *\\
          if (postContent.media.isNotEmpty) ...[
            const SizedBox(height: kPaddingSmall),
            _postCarouselAttachedImages(context),
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

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-            List of attached images           -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  List<Widget> _postListAttachedImages() {
    final List<Widget> imageWidgetList = [];
    final Color publisherColour = publisher?.accentColor.toSafeColorFromHex(defaultColor: colours.teal) ?? colours.teal;

    for (MediaDto media in postContent.media) {
      if (media.type == MediaType.photo_link) {
        imageWidgetList.add(
          CachedNetworkImage(
            fit: BoxFit.fitWidth,
            imageUrl: media.url,
            placeholder: (context, url) => Align(
              alignment: Alignment.center,
              child: PositiveLoadingIndicator(
                width: kIconSmall,
                color: publisherColour.complimentTextColor,
              ),
            ),
            errorWidget: (_, __, ___) => _errorLoadingImageWidget(),
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
  Widget _postCarouselAttachedImages(BuildContext context) {
    final List<Widget> listBanners = [];
    final Color publisherColour = publisher?.accentColor.toSafeColorFromHex(defaultColor: colours.teal) ?? colours.teal;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double height = min(kCarouselMaxHeight, screenWidth - 2 * kPaddingExtraSmall);

    //! For a dynamically sized carousel we will need to convert this to a custom widget
    //? Change the carousel to only be scrolable when the iamge has loaded, and provide the image size to resize the carousel
    //? Calculations for image size are provided in the async function commented out below
    //? I (SC) am happy to do this but this will be a larger job than mvp allows

    for (MediaDto media in postContent.media) {
      if (media.type == MediaType.photo_link) {
        listBanners.add(
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadiusLarge),
            child: CachedNetworkImage(
              fit: BoxFit.fitHeight,
              height: kPaddingExtraLarge,
              imageUrl: media.url,
              placeholder: (context, url) => Align(
                alignment: Alignment.center,
                child: PositiveLoadingIndicator(
                  width: kIconSmall,
                  color: publisherColour.complimentTextColor,
                ),
              ),
              errorWidget: (_, __, ___) => _errorLoadingImageWidget(),
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
      activeColor: colours.white,
      disableColor: colours.black,
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
  //   Image image = Image(image: CachedNetworkImageProvider(imageURL)); // I modified this line
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
      return const SizedBox();
    }
    return const SizedBox();
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-         error laoding video or image         -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget _errorLoadingImageWidget() {
    return SizedBox();
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-  Action Bar, likes, comments bookmark, link, -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget _postActions() {
    //TODO(S): Reenable when other info available
    // final Profile userProfile = ref.watch(profileControllerProvider.select((value) => value.userProfile ?? Profile.empty()));
    // final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    return PositivePostActions(
      likes: postContent.generalConfiguration!.currentLikes,
      comments: postContent.generalConfiguration!.currentComments,
      //TODO(S): Replace with bookmark information when available
      // bookmarked: userProfile.containsBookmarkByEventID( postContent.flMeta.id ),
      // onBookmark: profileController.updateBookmark(postContent.flMeta.id,value),
      //TODO(S): Replace with hyperlink when available
      // onHyperLink: () {},
    );
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-     Post Title, only displayed for events    -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget _postTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
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
      padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
      child: PositivePostHorizontalTags(
        tags: postContent.enrichmentConfiguration!.tags,
        typeography: typeography,
        colours: colours,
      ),
    );
  }

  Widget _location() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
      child: MarkdownBody(
        data: postContent.generalConfiguration!.content,
        styleSheet: getMarkdownStyleSheet(colours.white, colours, typeography),
        shrinkWrap: true,
        onTapLink: (text, url, title) {
          if (url != null) launchUrl(Uri.parse(url));
        },
      ),
    );
  }
}
