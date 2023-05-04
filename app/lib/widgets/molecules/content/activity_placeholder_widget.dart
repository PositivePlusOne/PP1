// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';

class ActivityPlaceholderWidget extends ConsumerWidget {
  const ActivityPlaceholderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const SizedBox(width: kPaddingSmallMedium),
            Shimmer.fromColors(
              baseColor: colors.colorGray3,
              highlightColor: colors.colorGray1,
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: kPaddingSmall),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Shimmer.fromColors(
                  baseColor: colors.colorGray3,
                  highlightColor: colors.colorGray1,
                  child: Container(
                    height: 20.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: kPaddingExtraSmall),
                Shimmer.fromColors(
                  baseColor: colors.colorGray3,
                  highlightColor: colors.colorGray1,
                  child: Container(
                    height: 10.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: kPaddingSmall),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingSmallMedium),
          child: Shimmer.fromColors(
            baseColor: colors.colorGray3,
            highlightColor: colors.colorGray1,
            child: Container(
              height: 10.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: kPaddingSmall),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingSmallMedium),
          child: Shimmer.fromColors(
            baseColor: colors.colorGray3,
            highlightColor: colors.colorGray1,
            child: Container(
              height: 10.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
