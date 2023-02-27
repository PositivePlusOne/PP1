import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

class EmptyChatListPlaceholder extends ConsumerWidget {
  const EmptyChatListPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: kPaddingMassive),
          Text(
            'Get the convo started',
            style: typography.styleHero.copyWith(color: colors.black),
          ),
          const SizedBox(height: kPaddingMedium),
          Text(
            'You do not have any conversations. Let’s get one started!',
            style: typography.styleBody.copyWith(color: colors.black),
          ),
          const SizedBox(height: kPaddingSmall),
          IntrinsicWidth(
            child: PositiveButton(
              colors: colors,
              primaryColor: colors.teal,
              label: 'Start a conversation',
              icon: UniconsLine.comment_edit,
              size: PositiveButtonSize.medium,
              style: PositiveButtonStyle.primary,
              layout: PositiveButtonLayout.iconLeft,
              // isDisabled: true,
              onTapped: () async {},
            ),
          ),
          const SizedBox(height: kPaddingMedium),
        ],
      ),
    );
  }
}
