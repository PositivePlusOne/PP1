// Dart imports:

// Flutter imports:
import 'package:app/providers/system/system_controller.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
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
import 'package:app/providers/analytics/analytics_controller.dart';
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

    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final AnalyticsControllerState analyticsControllerState = ref.watch(analyticsControllerProvider);

    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final SystemControllerState systemControllerState = ref.watch(systemControllerProvider);

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
              'Data Collection',
              style: typography.styleHeroMedium.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              'Allow the Positive+1 team to collect analytics from your device to help us improve the app.',
              style: typography.styleSubtitle.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveGlassSheet(
              children: <Widget>[
                PositiveCheckboxButton(
                  label: 'Enable Analytics',
                  value: analyticsControllerState.isCollectingData,
                  isBusy: state.isBusy,
                  showDisabledState: state.isBusy,
                  onTapped: (_) => analyticsController.toggleAnalyticsCollection(!analyticsControllerState.isCollectingData),
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              'App Preferences',
              style: typography.styleHeroMedium.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveRichText(
              body: 'Enabling biometrics adds an extra layer of security to your P+1 account. When enabled, you will need to pass your device\'s biometrics authentication to access your P+1 account after a period of inactivity.',
              textColor: colors.colorGray7,
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveGlassSheet(
              children: <Widget>[
                PositiveCheckboxButton(
                  icon: viewModel.biometricToggleIcon,
                  label: viewModel.biometricToggleTitle,
                  value: state.areBiometricsEnabled,
                  isBusy: state.isBusy,
                  showDisabledState: state.isBusy || state.availableBiometrics == AvailableBiometrics.none,
                  onTapped: (_) => viewModel.onBiometricsToggle(),
                ),
              ],
            ),
            const SizedBox(height: kPaddingLarge),
            Text(
              localizations.shared_navigation_tooltips_notifications,
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
                    label: topic.toTopicLocale,
                    value: state.notificationSubscribedTopics.contains(NotificationTopic.toJson(topic)),
                    isBusy: state.isBusy,
                    showDisabledState: state.isBusy,
                    onTapped: (_) => viewModel.toggleNotificationTopic(topic),
                  ),
                  if (topic != NotificationTopic.allTopics.last) const SizedBox(height: kPaddingMedium),
                ],
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            GestureDetector(
              onLongPress: ref.read(systemControllerProvider.notifier).launchDevelopmentTooling,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "${localizations.page_account_build_number}${systemControllerState.version}",
                  style: typography.styleBody.copyWith(color: colors.colorGray5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
