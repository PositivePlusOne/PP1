// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/guidance/guidance_directory_entry.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';

class GuidanceDirectoryTile extends ConsumerWidget {
  const GuidanceDirectoryTile({
    required this.entry,
    required this.isBusy,
    super.key,
  });

  final GuidanceDirectoryEntry entry;
  final bool isBusy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final AppRouter appRouter = ref.read(appRouterProvider);

    final String directoryId = entry.flMeta?.id ?? '';

    return PositiveTapBehaviour(
      onTap: (_) => appRouter.push(GuidanceDirectoryEntryRoute(guidanceEntryId: directoryId)),
      isEnabled: !isBusy,
      showDisabledState: isBusy,
      child: Container(
        padding: const EdgeInsets.all(kPaddingMedium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          color: colors.white,
        ),
        child: Row(
          children: <Widget>[
            if (entry.logoUrl.isNotEmpty) ...<Widget>[
              PositiveMediaImage(
                media: Media.fromImageUrl(entry.logoUrl),
                isEnabled: false,
                fit: BoxFit.contain,
                width: kIconHuge,
                height: kIconHuge,
              ),
              const SizedBox(width: kPaddingMedium),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(entry.title, style: typography.styleHeroSmall.copyWith(color: colors.black)),
                  Text(entry.description, style: typography.styleSubtitle.copyWith(color: colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
