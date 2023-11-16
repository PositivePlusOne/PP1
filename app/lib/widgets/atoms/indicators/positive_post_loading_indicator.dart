// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';

class PositivePostLoadingIndicator extends ConsumerWidget {
  const PositivePostLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingExtraSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //* -=-=-=- User information Placeholder -=-=-=- *\\
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingSmallMedium),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PositiveProfileCircularIndicator(),
                const SizedBox(width: kPaddingSmall),
                Container(
                  width: kBadgeSmallSize,
                  height: kIconSmall,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                    color: colours.colorGray2,
                  ),
                ),
                const Spacer(),
                Icon(
                  UniconsLine.ellipsis_h,
                  color: colours.colorGray2,
                  size: kIconMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: kPaddingSmall),
          //* -=-=-=- Carousel of attached images Placeholder -=-=-=- *\\
          Container(
            width: double.infinity,
            height: 380,
            decoration: BoxDecoration(color: colours.colorGray2, borderRadius: BorderRadius.circular(kBorderRadiusLarge)),
          ),
          // //* -=-=-=- Post Actions Placeholder -=-=-=- *\\
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingSmallMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: kIconLarge,
                  height: kIconMedium,
                  decoration: BoxDecoration(color: colours.colorGray2, borderRadius: BorderRadius.circular(kBorderRadiusLarge)),
                ),
                const SizedBox(width: kPaddingMedium),
                Container(
                  width: kIconLarge,
                  height: kIconMedium,
                  decoration: BoxDecoration(color: colours.colorGray2, borderRadius: BorderRadius.circular(kBorderRadiusLarge)),
                ),
                const Spacer(),
                Container(
                  width: kIconMedium,
                  height: kIconMedium,
                  decoration: BoxDecoration(color: colours.colorGray2, borderRadius: BorderRadius.circular(kBorderRadiusLarge)),
                ),
                const SizedBox(width: kPaddingMedium),
                Container(
                  width: kIconMedium,
                  height: kIconMedium,
                  decoration: BoxDecoration(color: colours.colorGray2, borderRadius: BorderRadius.circular(kBorderRadiusLarge)),
                ),
              ],
            ),
          ),
          // //* -=-=-=- Post Text Placeholder -=-=-=- *\\
          Container(
            width: double.infinity,
            height: kIconSmall,
            decoration: BoxDecoration(color: colours.colorGray2, borderRadius: BorderRadius.circular(kBorderRadiusLarge)),
          ),
          const SizedBox(height: kPaddingExtraSmall),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              width: double.infinity,
              height: kIconSmall,
              decoration: BoxDecoration(color: colours.colorGray2, borderRadius: BorderRadius.circular(kBorderRadiusLarge)),
            ),
          ),
          const SizedBox(height: kPaddingExtraSmall),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: Container(
              width: double.infinity,
              height: kIconSmall,
              decoration: BoxDecoration(color: colours.colorGray2, borderRadius: BorderRadius.circular(kBorderRadiusLarge)),
            ),
          ),
        ],
      ),
    );
  }
}
