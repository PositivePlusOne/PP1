// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import '../../../../providers/guidance/guidance_controller.dart';
import '../../../dtos/database/guidance/guidance_directory_entry.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/indicators/positive_loading_indicator.dart';

class GuidanceDirectoryEntryList extends ConsumerWidget {
  final List<GuidanceDirectoryEntry> gcs;

  const GuidanceDirectoryEntryList(this.gcs, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        kPaddingMedium.asVerticalBox,
        Text(
          'Directory',
          style: typography.styleHero.copyWith(
            color: colors.black,
          ),
        ),
        Text(
          'Find companies and charities that are helping to support people impacted by HIV.',
          style: typography.styleBody.copyWith(color: colors.black),
        ),
        kPaddingSmall.asVerticalBox,
        for (final gc in gcs) ...[
          GuidanceDirectoryEntryTile(gc),
        ]
      ].spaceWithVertical(kPaddingVerySmall),
    );
  }
}

class GuidanceDirectoryEntryTile extends ConsumerWidget {
  final GuidanceDirectoryEntry gde;

  static const double kBorderRadius = 20.0;

  const GuidanceDirectoryEntryTile(this.gde, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GuidanceController controller = ref.watch(guidanceControllerProvider.notifier);
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));

    final Icon errorWidget = Icon(
      UniconsLine.building,
      color: colors.colorGray5,
      size: kIconHuge,
    );

    return GestureDetector(
      onTap: () => controller.pushGuidanceDirectoryEntry(gde),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(kPaddingMedium),
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: gde.logoUrl == ""
                    ? errorWidget
                    : FastCachedImage(
                        url: gde.logoUrl,
                        loadingBuilder: (context, url) => const Align(
                          alignment: Alignment.center,
                          child: PositiveLoadingIndicator(
                            width: kIconSmall,
                          ),
                        ),
                        errorBuilder: (_, __, ___) => errorWidget,
                      ),
              ),
              kPaddingMedium.asHorizontalBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      gde.title,
                      style: typography.styleTitleTwo.copyWith(
                        fontSize: 20,
                        color: colors.black,
                      ),
                    ),
                    Text(
                      gde.blurb,
                      style: typography.styleBody.copyWith(
                        color: colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GuidanceDirectoryEntryContent extends ConsumerWidget {
  final GuidanceDirectoryEntry gde;

  const GuidanceDirectoryEntryContent(this.gde, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MarkdownStyleSheet markdownStyleSheet = getMarkdownStyleSheet(colors.white, colors, typography);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        kPaddingMedium.asVerticalBox,
        Text(
          gde.title,
          style: typography.styleHero.copyWith(color: colors.black),
        ),
        MarkdownBody(
          data: gde.body,
          styleSheet: markdownStyleSheet,
        )
      ].spaceWithVertical(kPaddingMedium),
    );
  }
}
