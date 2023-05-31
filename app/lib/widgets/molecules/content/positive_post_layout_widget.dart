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

    if (postContent.generalConfiguration == null) {
      return Text(
        postContent.toString(),
      );
    }

    if ((postContent.generalConfiguration!.type == const ActivityGeneralConfigurationType.event())) {
      return _eventBuilder(ref);
    }

    if ((postContent.generalConfiguration!.type == const ActivityGeneralConfigurationType.post())) {
      return _postBuilder(ref);
    }

    if ((postContent.generalConfiguration!.type == const ActivityGeneralConfigurationType.clip())) {
      return _clipBuilder(ref);
    }

    return Text(
      postContent.toString(),
    );
  }

  Widget _eventBuilder(WidgetRef ref) {
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
            _postCarouselAttachedImages(),
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

  Widget _postBuilder(WidgetRef ref) {
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
            _postCarouselAttachedImages(),
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

  Widget _clipBuilder(WidgetRef ref) {
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
            _postCarouselAttachedImages(),
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
  Widget _postCarouselAttachedImages() {
    final List<BannerModel> listBanners = [];
    int i = 0;

    for (MediaDto media in postContent.media) {
      if (media.type == MediaType.photo_link) {
        listBanners.add(
          BannerModel(
            boxFit: BoxFit.contain,
            imagePath: media.url,
            id: i.toString(),
          ),
        );
        i++;
      }
    }

    return BannerCarousel(
      banners: listBanners,
      customizedIndicators: IndicatorModel.animation(width: 20, height: 5, spaceBetween: 2, widthAnimation: 50),
      customizedBanners: [],
      height: 120,
      activeColor: colours.white,
      disableColor: colours.black,
      animation: true,
      borderRadius: kBorderRadiusHuge,
      indicatorBottom: false,
    );
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=-          Carousel of attached images         -=-=-=-=-=- *\\
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
