// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';

class PositiveListTile extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final void Function() onTap;

  const PositiveListTile({
    required this.title,
    this.subtitle,
    required this.onTap,
    super.key,
  });

  static const double kHeight = 100.0;
  static const double kBorderRadius = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(kPaddingMedium),
          height: kHeight,
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: typography.styleTitleTwo.copyWith(color: colors.black),
              ),
              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: typography.styleBody.copyWith(color: colors.black),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
