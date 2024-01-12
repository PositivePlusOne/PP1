// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import '../../../constants/design_constants.dart';

class PositiveSearchLoadingTile extends ConsumerWidget {
  const PositiveSearchLoadingTile({super.key});

  static const double kProfileTileHeight = 72.0;
  static const double kProfileTileBorderRadius = 40.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    return Shimmer.fromColors(
      baseColor: colors.colorGray3,
      highlightColor: colors.colorGray1,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: kProfileTileHeight,
          maxHeight: kProfileTileHeight,
        ),
        decoration: BoxDecoration(
          color: colors.colorGray3,
          borderRadius: BorderRadius.circular(kProfileTileBorderRadius),
        ),
        padding: const EdgeInsets.all(kPaddingSmall),
        child: Row(
          children: <Widget>[
            Container(
              width: kIconHuge,
              height: kIconHuge,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.colorGray3,
              ),
            ),
            const SizedBox(width: kPaddingSmall),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 14.0,
                    width: double.infinity,
                    color: colors.colorGray3,
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    height: 10.0,
                    width: 100.0,
                    color: colors.colorGray3,
                  ),
                ],
              ),
            ),
            const SizedBox(width: kPaddingSmall),
            Container(
              width: kIconMedium,
              height: kIconMedium,
              color: colors.colorGray3,
            ),
          ],
        ),
      ),
    );
  }
}
