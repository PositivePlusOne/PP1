// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';
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
    final MarkdownStyleSheet markdownStyleSheet = getMarkdownStyleSheet(colors.white, colors, typography);

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
          MarkdownBody(
            data: ga.body,
            styleSheet: markdownStyleSheet,
            selectable: false,
            shrinkWrap: true,
            imageBuilder: (uri, title, alt) => PositiveMediaImage(media: Media.fromImageUrl(uri.toString())),
            onTapLink: (text, href, title) {
              href?.attemptToLaunchURL();
            },
            extensionSet: md.ExtensionSet(
              md.ExtensionSet.gitHubFlavored.blockSyntaxes,
              [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
            ),
          )
        ],
      ),
    );
  }
}
