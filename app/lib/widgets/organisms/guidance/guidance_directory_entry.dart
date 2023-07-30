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
  const GuidanceDirectoryEntryList({
    required this.controller,
    required this.directoryEntries,
    super.key,
  });

  final GuidanceController controller;
  final List<GuidanceDirectoryEntry> directoryEntries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.read(designControllerProvider.select((value) => value.typography));
    final colors = ref.read(designControllerProvider.select((value) => value.colors));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        kPaddingMedium.asVerticalBox,
        Text(
          'Directory',
          style: typography.styleSuperSize.copyWith(
            color: colors.black,
          ),
        ),
        Text(
          'Find companies and charities that are helping to support people impacted by HIV.',
          style: typography.styleBody.copyWith(color: colors.black),
        ),
        kPaddingSmall.asVerticalBox,
        for (final entry in directoryEntries) ...[
          GuidanceDirectoryEntryTile(directoryEntry: entry, controller: controller),
        ]
      ].spaceWithVertical(kPaddingVerySmall),
    );
  }
}

class GuidanceDirectoryEntryTile extends ConsumerWidget {
  const GuidanceDirectoryEntryTile({
    required this.directoryEntry,
    required this.controller,
    super.key,
  });

  final GuidanceDirectoryEntry directoryEntry;
  final GuidanceController controller;

  static const double kBorderRadius = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.read(designControllerProvider.select((value) => value.typography));
    final colors = ref.read(designControllerProvider.select((value) => value.colors));

    final Icon errorWidget = Icon(
      UniconsLine.building,
      color: colors.colorGray5,
      size: kIconHuge,
    );

    return GestureDetector(
      onTap: () {},
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
                child: directoryEntry.logoUrl == ""
                    ? errorWidget
                    : FastCachedImage(
                        url: directoryEntry.logoUrl,
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
                      directoryEntry.title,
                      style: typography.styleTitleTwo.copyWith(
                        fontSize: 20,
                        color: colors.black,
                      ),
                    ),
                    Text(
                      directoryEntry.description,
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
          style: typography.styleSuperSize.copyWith(color: colors.black),
        ),
        kPaddingSmall.asVerticalBox,
        MarkdownBody(
          data: gde.markdown,
          styleSheet: markdownStyleSheet,
        )
      ].spaceWithVertical(kPaddingVerySmall),
    );
  }
}
