// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/profile_form_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/indicators/positive_page_indicator.dart';

class ProfileNameEntryPage extends ConsumerWidget {
  const ProfileNameEntryPage({super.key});

  Color getTextFieldTintColor(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.name.isEmpty) {
      return colors.purple;
    }

    return controller.nameValidationResults.isNotEmpty ? colors.red : colors.green;
  }

  PositiveTextFieldIcon? getTextFieldSuffixIcon(ProfileFormController controller, DesignColorsModel colors) {
    if (controller.state.name.isEmpty) {
      return null;
    }

    return controller.nameValidationResults.isNotEmpty ? PositiveTextFieldIcon.error(colors) : PositiveTextFieldIcon.success(colors);
  }

  Future<void> _onConfirmed(
    ProfileFormController controller,
    AppRouter appRouter,
  ) async {
    await controller.onNameConfirmed();

    await appRouter.push(const ProfileDisplayNameEntryRoute());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.watch(appRouterProvider);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final ProfileFormController controller = ref.read(profileFormControllerProvider.notifier);
    final ProfileFormState state = ref.watch(profileFormControllerProvider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(controller, colors);
    final PositiveTextFieldIcon? suffixIcon = getTextFieldSuffixIcon(controller, colors);

    String errorMessage = localizations.fromValidationErrorList(controller.nameValidationResults);
    bool shouldDisplayErrorMessage = state.name.isNotEmpty && errorMessage.isNotEmpty;

    //* If a controller threw an exception, we want to display that instead of the validation errors
    if (errorMessage.isEmpty) {
      errorMessage = localizations.fromObject(state.currentError);
      shouldDisplayErrorMessage = errorMessage.isNotEmpty;
    }

    final List<Widget> hints = <Widget>[
      if (shouldDisplayErrorMessage) ...<Widget>[
        PositiveHint.fromError(errorMessage, colors),
        const SizedBox(height: kPaddingMedium),
      ],
    ];

    return PositiveScaffold(
      backgroundColor: colors.colorGray1,
      trailingWidgets: hints,
      footerWidgets: <Widget>[
        //TODO(andy): Add "Display In App" toggle
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: () => _onConfirmed(controller, appRouter),
          isDisabled: !controller.isNameValid,
          label: localizations.shared_actions_continue,
        ),
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Row(
              children: [
                PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  isDisabled: true,
                  onTapped: () {},
                  label: localizations.shared_actions_back,
                  style: PositiveButtonStyle.text,
                  layout: PositiveButtonLayout.textOnly,
                  size: PositiveButtonSize.small,
                ),
                PositivePageIndicator(
                  colors: colors,
                  pagesNum: 9,
                  currentPage: 0,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localizations.page_profile_name_entry_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Text(
              localizations.page_profile_name_entry_description,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            _WhyButton(
              text: localizations.page_profile_name_entry_why,
              style: typography.styleButtonBold.copyWith(
                color: colors.black,
              ),
            ),
            const SizedBox(height: kPaddingLarge),
            PositiveTextField(
              labelText: localizations.page_profile_name_entry_input_label,
              initialText: state.name,
              onTextChanged: controller.onNameChanged,
              tintColor: tintColor,
              suffixIcon: suffixIcon,
              isEnabled: !state.isBusy,
              textInputType: TextInputType.name,
            ),
          ],
        ),
      ],
    );
  }
}

class _WhyButton extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _WhyButton({
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: kPaddingExtraSmall,
          horizontal: kPaddingSmall,
        ),
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }

  void _onPressed() {
    //TODO(andy): implement on why pressed
  }
}
