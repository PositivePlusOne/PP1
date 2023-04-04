// Flutter imports:
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/enumerations/positive_notification_preference.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/molecules/input/positive_rich_text.dart';
import 'package:app/widgets/organisms/account/vms/account_preferences_view_model.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/buttons/positive_checkbox_button.dart';
import '../../molecules/containers/positive_glass_sheet.dart';
import '../../molecules/layouts/positive_basic_sliver_list.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';

class AccountPreferencesPage extends HookConsumerWidget {
  const AccountPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.read(appRouterProvider);

    final AccountPreferencesViewModel viewModel = ref.read(accountPreferencesViewModelProvider.notifier);
    final AccountPreferencesViewModelState state = ref.watch(accountPreferencesViewModelProvider);

    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    useLifecycleHook(viewModel);

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      appBar: PositiveAppBar(
        applyLeadingandTrailingPadding: true,
        safeAreaQueryData: mediaQueryData,
        foregroundColor: colors.black,
        includeLogoWherePossible: false,
        leading: PositiveButton.appBarIcon(
          colors: colors,
          primaryColor: colors.black,
          icon: UniconsLine.angle_left_b,
          onTapped: () => appRouter.removeLast(),
        ),
        trailing: <Widget>[
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.bell,
            onTapped: () async {},
            isDisabled: true,
          ),
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.user,
            onTapped: () async {},
            isDisabled: true,
          ),
        ],
      ),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: false,
          children: <Widget>[
            Text(
              'App Preferences',
              style: typography.styleSuperSize.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveGlassSheet(
              children: <Widget>[
                PositiveCheckboxButton(
                  icon: UniconsLine.eye_slash,
                  label: 'Incognito mode',
                  value: state.isIncognitoModeEnabled,
                  onTapped: viewModel.toggleIncognitoMode,
                ),
                const SizedBox(height: kPaddingMedium),
                PositiveCheckboxButton(
                  icon: UniconsLine.smile,
                  label: 'Face ID',
                  value: state.isBiometricsEnabled,
                  onTapped: viewModel.toggleBiometrics,
                ),
                const SizedBox(height: kPaddingMedium),
                PositiveCheckboxButton(
                  icon: UniconsLine.envelope_heart,
                  label: 'Marketing emails',
                  value: state.isMarketingEmailsEnabled,
                  onTapped: viewModel.toggleMarketingEmails,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              'Notifications',
              style: typography.styleSuperSize.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveRichText(
              body: 'While you will always get notifications from us within the app, you can customise which ones you will receive on your mobile device.\n\nEnable or disable your app notifications in your {}',
              textColor: colors.colorGray7,
              actions: const <String>['device settings.'],
              onActionTapped: (_) => viewModel.onOpenSettingsRequested(),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveGlassSheet(
              children: <Widget>[
                for (final PositiveNotificationPreference preference in PositiveNotificationPreference.values) ...<Widget>[
                  PositiveCheckboxButton(
                    label: preference.toLocalizedTopic,
                    value: true,
                    onTapped: () {},
                  ),
                  if (preference != PositiveNotificationPreference.values.last) const SizedBox(height: kPaddingMedium),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}
