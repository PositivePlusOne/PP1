// Flutter imports:
import 'dart:async';

import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';

class PositiveListTile extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final bool isBusy;

  final FutureOr<void> Function(BuildContext context) onTap;

  const PositiveListTile({
    required this.title,
    required this.onTap,
    this.isBusy = false,
    this.subtitle,
    super.key,
  });

  static const double kBorderRadius = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return PositiveTapBehaviour(
      onTap: onTap,
      isEnabled: !isBusy,
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
                title,
                style: typography.styleTitleTwo.copyWith(color: colors.black, fontSize: 20),
              ),
              if (subtitle?.isNotEmpty ?? false) ...[
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
