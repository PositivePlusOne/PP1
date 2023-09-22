// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/notifications/notification_topic.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
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

@RoutePage()
class AccountPreferencesPage extends HookConsumerWidget {
  const AccountPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.read(appRouterProvider);

    final AccountPreferencesViewModel viewModel = ref.read(accountPreferencesViewModelProvider.notifier);
    final AccountPreferencesViewModelState state = ref.watch(accountPreferencesViewModelProvider);
    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);

    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final List<Widget> actions = [];
    if (profileControllerState.currentProfile != null) {
      actions.addAll(profileControllerState.currentProfile!.buildCommonProfilePageActions(disableAccount: true));
    }

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
        trailing: actions,
      ),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: false,
          children: <Widget>[
            Text(
              'App Preferences',
              style: typography.styleHeroMedium.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveGlassSheet(
              children: <Widget>[
                //! PP1-984
                // PositiveCheckboxButton(
                //   icon: UniconsLine.eye_slash,
                //   label: 'Incognito mode',
                //   value: state.isIncognitoEnabled,
                //   onTapped: viewModel.toggleIncognitoMode,
                //   isBusy: state.isBusy,
                //   showDisabledState: state.isBusy,
                // ),
                // const SizedBox(height: kPaddingMedium),
                PositiveCheckboxButton(
                  icon: UniconsLine.lock_access,
                  label: localizations.page_profile_biometrics_title,
                  value: state.areBiometricsEnabled,
                  onTapped: viewModel.toggleBiometrics,
                  isBusy: state.isBusy,
                  showDisabledState: state.isBusy,
                ),
                //! PP1-984
                // const SizedBox(height: kPaddingMedium),
                // PositiveCheckboxButton(
                //   icon: UniconsLine.envelope_check,
                //   label: 'Marketing emails',
                //   value: state.areMarketingEmailsEnabled,
                //   onTapped: viewModel.toggleMarketingEmails,
                //   isBusy: state.isBusy,
                //   showDisabledState: state.isBusy,
                // ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              'Notifications',
              style: typography.styleHeroMedium.copyWith(color: colors.black),
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
                for (final NotificationTopic topic in NotificationTopic.allTopics) ...<Widget>[
                  PositiveCheckboxButton(
                    label: topic.toLocalizedTopic,
                    value: state.notificationSubscribedTopics.contains(NotificationTopic.toJson(topic)),
                    isBusy: state.isBusy,
                    showDisabledState: state.isBusy,
                    onTapped: (_) => viewModel.toggleNotificationTopic(topic),
                  ),
                  if (topic != NotificationTopic.allTopics.last) const SizedBox(height: kPaddingMedium),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}
