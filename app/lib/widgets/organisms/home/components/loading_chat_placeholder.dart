// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';

class LoadingChatPlaceholder extends ConsumerWidget {
  const LoadingChatPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: kPaddingLarge),
          Text(
            'Get the convo started',
            style: typography.styleHero.copyWith(color: colors.black),
          ),
          const SizedBox(height: kPaddingMedium),
          Text(
            'We are loading your conversations, please wait a moment.',
            style: typography.styleBody.copyWith(color: colors.black),
          ),
        ],
      ),
    );
  }
}
