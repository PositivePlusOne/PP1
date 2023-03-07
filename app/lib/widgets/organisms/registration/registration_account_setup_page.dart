// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/resources/resources.dart';
import 'package:app/widgets/atoms/iconography/positive_stamp.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/registration/vms/registration_account_view_model.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../molecules/containers/positive_glass_sheet.dart';
import '../../molecules/prompts/positive_hint.dart';

class RegistrationAccountSetupPage extends ConsumerWidget {
  const RegistrationAccountSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final RegistrationAccountViewModel viewModel = ref.watch(registrationAccountViewModelProvider.notifier);
    final RegistrationAccountViewModelState state = ref.watch(registrationAccountViewModelProvider);

    const double decorationHeightMin = 400;
    final double decorationHeightMax = max(mediaQueryData.size.height / 2, decorationHeightMin);
    const double badgeRadius = 166.0;
    const double imageTopOffset = badgeRadius / 4;

    final String errorMessage = localizations.fromObject(state.currentError);

    // TODO(any): Localize this
    return PositiveScaffold(
      hideBottomPadding: true,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Text(
              'Account Setup!',
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              'Let’s take a breather, from here we will ask for you to complete your profile before you can access Positive+1',
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            if (errorMessage.isNotEmpty) ...<Widget>[
              PositiveHint(
                label: errorMessage,
                icon: UniconsLine.exclamation_triangle,
                iconColor: colors.red,
              ),
              const SizedBox(height: kPaddingMedium),
            ],
          ],
        ),
        SliverFillRemaining(
          fillOverscroll: false,
          hasScrollBody: false,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            constraints: BoxConstraints(
              maxHeight: decorationHeightMax,
              minHeight: decorationHeightMin,
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: imageTopOffset,
                  left: 0.0,
                  bottom: 0.0,
                  right: 0.0,
                  child: Image.asset(
                    MockImages.bike,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0.0,
                  left: kPaddingMedium,
                  child: Transform.rotate(
                    angle: 15.0.degreeToRadian,
                    child: PositiveStamp.smile(
                      colors: colors,
                      fillColour: colors.yellow,
                      size: badgeRadius,
                    ),
                  ),
                ),
                Positioned(
                  bottom: mediaQueryData.padding.bottom + kPaddingMedium,
                  left: kPaddingSmall,
                  right: kPaddingSmall,
                  child: PositiveGlassSheet(
                    children: <Widget>[
                      PositiveButton(
                        colors: colors,
                        primaryColor: colors.black,
                        label: 'Let\'s Continue',
                        isDisabled: state.isBusy,
                        onTapped: viewModel.onCreateProfileSelected,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
