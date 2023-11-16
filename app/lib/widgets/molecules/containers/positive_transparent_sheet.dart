// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/system/design_controller.dart';

class PositiveTransparentSheet extends ConsumerWidget {
  const PositiveTransparentSheet({
    required this.children,
    this.mainAxisSize = MainAxisSize.min,
    this.listSpacingSize = kPaddingNone,
    super.key,
  });

  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final double listSpacingSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadiusLarge),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(kPaddingMedium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          color: colors.colorGray3.withOpacity(kOpacityQuarter),
        ),
        child: Column(
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...children.spaceWithVertical(listSpacingSize),
          ],
        ),
      ),
    );
  }
}
