import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScrollingSelector extends HookConsumerWidget {
  const ScrollingSelector({
    required this.textValue,
    required this.shouldHighlight,
    super.key,
  });

  final String textValue;
  final bool shouldHighlight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return Container(
      decoration: BoxDecoration(
        color: shouldHighlight ? colours.black.withOpacity(kOpacityVignette) : colours.transparent,
        borderRadius: BorderRadius.circular(
          kBorderRadiusInfinite,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: kPaddingVerySmall),
      width: kPaddingLargeish,
      height: kPaddingMediumLarge,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          textValue,
          style: typography.styleSubtextBold.copyWith(color: colours.white),
        ),
      ),
    );
  }
}
