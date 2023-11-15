// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/resources/resources.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/atoms/iconography/positive_stamp.dart';
import 'package:app/widgets/atoms/indicators/positive_page_indicator.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../helpers/brand_helpers.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../molecules/containers/positive_glass_sheet.dart';

enum PositiveGenericPageStyle {
  imaged,
  decorated,
}

class PositiveGenericPage extends ConsumerWidget {
  const PositiveGenericPage({
    required this.title,
    required this.body,
    required this.buttonText,
    required this.onContinueSelected,
    this.style = PositiveGenericPageStyle.imaged,
    this.canBack = false,
    this.isBusy = false,
    this.currentStepIndex = 0,
    this.totalSteps = 0,
    this.onHelpSelected,
    super.key,
  });

  final String title;
  final String body;
  final String buttonText;
  final PositiveGenericPageStyle style;

  final Future<void> Function()? onHelpSelected;
  final Future<void> Function() onContinueSelected;
  final bool isBusy;
  final bool canBack;

  final int currentStepIndex;
  final int totalSteps;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    const double badgeRadius = 166.0;

    return PositiveScaffold(
      onWillPopScope: () async {
        if (canBack) {
          Navigator.of(context).pop();
          return true;
        }

        return false;
      },
      isBusy: isBusy,
      visibleComponents: {
        if (style == PositiveGenericPageStyle.imaged) ...[
          ...PositiveScaffoldComponent.excludeFooterPadding,
        ] else ...[
          ...PositiveScaffoldComponent.values,
        ],
      },
      decorations: buildType1ScaffoldDecorations(colors),
      footerWidgets: <Widget>[
        if (style == PositiveGenericPageStyle.decorated || style == PositiveGenericPageStyle.imaged) ...[
          PositiveButton(
            colors: colors,
            primaryColor: colors.black,
            label: buttonText,
            onTapped: onContinueSelected,
            isDisabled: isBusy,
          ),
          const SizedBox(height: kPaddingSmall),
        ],
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            if (canBack || totalSteps > 0) ...<Widget>[
              Row(
                children: [
                  if (canBack) ...<Widget>[
                    PositiveBackButton(isDisabled: isBusy),
                  ],
                  if (totalSteps > 0) ...<Widget>[
                    PositivePageIndicator(
                      color: colors.black,
                      pagesNum: totalSteps,
                      currentPage: currentStepIndex.toDouble(),
                    ),
                  ],
                ].spaceWithHorizontal(kPaddingSmall),
              ),
              const SizedBox(height: kPaddingMedium),
            ],
            Text(
              title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              body,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            if (onHelpSelected != null) ...[
              const SizedBox(height: kPaddingSmall),
              Align(
                alignment: Alignment.centerLeft,
                child: IntrinsicWidth(
                  child: PositiveButton(
                    colors: colors,
                    primaryColor: colors.black,
                    label: appLocalizations.shared_form_information_display,
                    size: PositiveButtonSize.small,
                    style: PositiveButtonStyle.text,
                    onTapped: () => onHelpSelected!(),
                  ),
                ),
              ),
            ],
            const SizedBox(height: kPaddingMassive),
            Transform.translate(
              offset: const Offset(kPaddingMassive, kPaddingNone),
              child: Transform.rotate(
                angle: 15.0.degreeToRadian,
                child: PositiveStamp.smile(
                  colors: colors,
                  fillColour: colors.yellow,
                  size: badgeRadius,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
