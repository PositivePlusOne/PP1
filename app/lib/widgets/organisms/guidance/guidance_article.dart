// Flutter imports:
import 'package:app/widgets/atoms/buttons/positive_checkbox.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:markdown_widget/markdown_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown/markdown.dart' as md;

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/guidance/guidance_article.dart';
import 'package:app/dtos/database/guidance/guidance_category.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/tiles/positive_list_tile.dart';

enum GuidanceArticleListType {
  guidance('Guidance'),
  appHelp('Help');

  const GuidanceArticleListType(this.label);
  final String label;
}

class GuidanceArticleList extends ConsumerWidget {
  const GuidanceArticleList({
    required this.type,
    required this.articles,
    required this.onArticleSelected,
    required this.onCategorySelected,
    super.key,
  });

  final GuidanceArticleListType type;
  final List<GuidanceArticle> articles;
  final void Function(GuidanceArticle article) onArticleSelected;
  final void Function(GuidanceCategory category) onCategorySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.read(designControllerProvider.select((value) => value.typography));
    final colors = ref.read(designControllerProvider.select((value) => value.colors));

    TextStyle style = typography.styleHeroMedium.copyWith(color: colors.colorGray4);
    if (type == GuidanceArticleListType.appHelp) {
      style = typography.styleTopic.copyWith(color: colors.colorGray4);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          type.label,
          style: style,
        ),
        for (final article in articles) ...[
          GuidanceArticleTile(
            article: article,
            onTap: () => onArticleSelected(article),
          ),
        ],
        if (articles.isEmpty) ...[
          Text(
            'Hmmmmm, there seems to be nothing here. Sorry about that!',
            style: typography.styleBody.copyWith(color: colors.black),
            textAlign: TextAlign.left,
          ),
        ]
      ],
    );
  }
}

class GuidanceArticleTile extends ConsumerWidget {
  final GuidanceArticle article;
  final VoidCallback onTap;

  const GuidanceArticleTile({
    required this.onTap,
    required this.article,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PositiveListTile(
      title: article.title,
      onTap: onTap,
    );
  }
}

class GuidanceArticleContent extends ConsumerWidget {
  final GuidanceArticle ga;

  const GuidanceArticleContent(this.ga, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ga.title,
            style: typography.styleHeroMedium.copyWith(color: colors.black),
          ),
          kPaddingSmall.asVerticalBox,
          MarkdownWidget(
            data: ga.body,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            markdownGeneratorConfig: MarkdownGeneratorConfig(
              linesMargin: const EdgeInsets.symmetric(vertical: kPaddingExtraSmall),
            ),
            config: MarkdownConfig(
              configs: <WidgetConfig>[
                H1Config(style: typography.styleHeroMedium.copyWith(color: colors.black)),
                H2Config(style: typography.styleHeroSmall.copyWith(color: colors.black)),
                H3Config(style: typography.styleTitle.copyWith(color: colors.black)),
                H4Config(style: typography.styleTitleTwo.copyWith(color: colors.black)),
                H5Config(style: typography.styleSubtitleBold.copyWith(color: colors.black)),
                H6Config(style: typography.styleSubtextBold.copyWith(color: colors.black)),
                PConfig(textStyle: typography.styleBody.copyWith(color: colors.black)),
                LinkConfig(
                  style: typography.styleBody.copyWith(
                    color: colors.linkBlue,
                    decoration: TextDecoration.underline,
                  ),
                  onTap: (link) {
                    link.attemptToLaunchURL();
                  },
                ),
                CodeConfig(style: typography.styleSubtitle.copyWith(color: colors.black, fontFamily: 'AlbertSans')),
                BlockquoteConfig(sideColor: colors.purple, textColor: colors.black),
                TableConfig(bodyStyle: typography.styleBody.copyWith(color: colors.black)),
                const ListConfig(marginLeft: kPaddingMedium),
                ImgConfig(
                  builder: (url, attributes) => PositiveMediaImage(
                    media: Media.fromImageUrl(url),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
