// Flutter imports:

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/extensions/widget_extensions.dart';
// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/guidance/guidance_controller.dart';
import '../../../dtos/database/guidance/guidance_directory_entry.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';

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
        Text(
          'Directory',
          style: typography.styleHero.copyWith(color: colors.black),
        ),
        Text(
          'Find companies and charities that are helping to support people impacted by HIV.',
          style: typography.styleBody.copyWith(color: colors.black),
        ),
        for (final gc in gcs) ...[
          GuidanceDirectoryEntryTile(gc),
        ]
      ].spaceWithVertical(kPaddingMedium),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                gde.title,
                style: typography.styleTitleTwo.copyWith(color: colors.black),
              ),
              Text(
                gde.blurb,
                style: typography.styleBody.copyWith(color: colors.black),
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
        Text(
          gde.title,
          style: typography.styleHero.copyWith(color: colors.black),
        ),
        Markdown(
          data: gde.body,
          padding: EdgeInsets.zero,
          styleSheet: markdownStyleSheet,
          shrinkWrap: true,
        )
      ].spaceWithVertical(kPaddingMedium),
    );
  }
}
