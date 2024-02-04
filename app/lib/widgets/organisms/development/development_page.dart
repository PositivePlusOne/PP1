// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/location/location_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/resources/resources.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/buttons/positive_switch.dart';
import 'package:app/widgets/behaviours/positive_feed_pagination_behaviour.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/development/vms/development_view_model.dart';
import '../../molecules/navigation/positive_app_bar.dart';

@RoutePage()
class DevelopmentPage extends ConsumerWidget {
  const DevelopmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final DevelopmentViewModel developmentViewModel = ref.watch(developmentViewModelProvider.notifier);
    final DevelopmentViewModelState developmentViewModelState = ref.watch(developmentViewModelProvider);

    final SystemControllerState systemControllerState = ref.watch(systemControllerProvider);

    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final AnalyticsControllerState analyticsControllerState = ref.watch(analyticsControllerProvider);

    final LocationController locationController = ref.read(locationControllerProvider.notifier);
    final LocationControllerState locationControllerState = ref.watch(locationControllerProvider);

    final NotificationsControllerState notificationsControllerState = ref.watch(notificationsControllerProvider);

    final AppRouter appRouter = ref.read(appRouterProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final bool isNonProduction = systemControllerState.environment != SystemEnvironment.production;
    final bool isShowingDebugMessages = systemControllerState.showingDebugMessages;

    final Profile? currentProfile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));

    return PositiveScaffold(
      appBar: PositiveAppBar(
        applyLeadingandTrailingPadding: true,
        safeAreaQueryData: mediaQueryData,
        backgroundColor: colors.black,
        foregroundColor: colors.white,
        trailing: <Widget>[
          PositiveButton.appBarIcon(
            colors: colors,
            foregroundColor: colors.white,
            icon: UniconsLine.multiply,
            onTapped: () => appRouter.removeLast(),
          ),
        ],
      ),
      backgroundColor: colors.black,
      appBarColor: colors.black,
      headingWidgets: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              CupertinoListTile(
                title: SelectableText(
                  developmentViewModelState.status,
                  maxLines: 3,
                  style: typography.styleBody.copyWith(color: colors.white),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Version: ${systemControllerState.version}',
                      style: typography.styleButtonBold.copyWith(color: colors.white),
                    ),
                  ],
                ),
              ),
              PositiveFeedPaginationBehaviour.buildVisualSeparator(context),
              if (isNonProduction) ...<Widget>[
                CupertinoListTile(
                  title: Text(
                    'Internal',
                    style: typography.styleSubtextBold.copyWith(color: colors.white),
                  ),
                ),
                CupertinoListTile.notched(
                  onTap: developmentViewModel.displayAuthClaims,
                  title: Text(
                    'Toggle informative debug messaging',
                    style: typography.styleButtonRegular.copyWith(color: colors.white),
                  ),
                  subtitle: Text(
                    'Where possible, popups which are a result of errors will include their stack traces.',
                    style: typography.styleSubtext.copyWith(color: colors.white),
                  ),
                  additionalInfo: Transform.scale(
                    scale: 0.7,
                    child: PositiveSwitch(
                      activeColour: colors.green.withAlpha(210),
                      inactiveColour: colors.red.withAlpha(210),
                      ignoring: false,
                      value: isShowingDebugMessages,
                      onTapped: (_) => ref.read(systemControllerProvider.notifier).toggleDebugMessages(),
                    ),
                  ),
                ),
                CupertinoListTile.notched(
                  onTap: developmentViewModel.requestManualLocation,
                  title: Text(
                    'Manually set GPS location',
                    style: typography.styleButtonRegular.copyWith(color: colors.white),
                  ),
                  subtitle: Text(
                    'Manually set your lat/long to test location based features.',
                    style: typography.styleSubtext.copyWith(color: colors.white),
                  ),
                ),
                PositiveFeedPaginationBehaviour.buildVisualSeparator(context),
              ],
              ...buildGeneralSection(
                context: context,
                viewModel: developmentViewModel,
                state: developmentViewModelState,
                analyticsController: analyticsController,
                analyticsState: analyticsControllerState,
                systemState: systemControllerState,
              ),
              ...buildLocationSection(
                context: context,
                viewModel: developmentViewModel,
                state: developmentViewModelState,
                locationController: locationController,
                locationState: locationControllerState,
                isProduction: systemControllerState.environment == SystemEnvironment.production,
              ),
              ...buildTroubleshootingAndSupport(
                context: context,
                viewModel: developmentViewModel,
                state: developmentViewModelState,
                notificationsState: notificationsControllerState,
                currentProfile: currentProfile,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> buildLocationSection({
    required DevelopmentViewModel viewModel,
    required DevelopmentViewModelState state,
    required LocationController locationController,
    required LocationControllerState locationState,
    required bool isProduction,
    required BuildContext context,
  }) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

    final double? currentLatitude = locationState.lastKnownLatitude;
    final double? currentLongitude = locationState.lastKnownLongitude;

    String currentLocation = 'Latitude: ${currentLatitude ?? 'Unknown'} - Longitude: ${currentLongitude ?? 'Unknown'}';
    if (locationState.isUpdatingLocation) {
      currentLocation = 'Updating location...';
    }

    String currentPermission = 'Unknown';
    if (locationState.locationPermission != null) {
      currentPermission = locationState.locationPermission?.toString() ?? 'Unknown';
    }

    return <Widget>[
      CupertinoListTile(
        title: Text(
          'Location',
          style: typography.styleSubtextBold.copyWith(color: colors.white),
        ),
      ),
      CupertinoListTile.notched(
        title: Text(
          'Current location',
          style: typography.styleButtonRegular.copyWith(color: colors.white),
        ),
        subtitle: Text(
          currentLocation,
          style: typography.styleSubtext.copyWith(color: colors.white),
        ),
      ),
      CupertinoListTile.notched(
        title: Text(
          'Current location permissions',
          style: typography.styleButtonRegular.copyWith(color: colors.white),
        ),
        subtitle: Text(
          currentPermission,
          style: typography.styleSubtext.copyWith(color: colors.white),
        ),
      ),
      CupertinoListTile.notched(
        onTap: () => locationController.attemptToUpdateLocation(force: true),
        title: Text(
          'Force location update',
          style: typography.styleButtonRegular.copyWith(color: colors.white),
        ),
        subtitle: Text(
          'Forces a location update to be performed.',
          style: typography.styleSubtext.copyWith(color: colors.white),
        ),
      ),
      // Display address components for non-production environments
      if (!isProduction) ...<Widget>[
        CupertinoListTile.notched(
          title: Text(
            'Current address components',
            style: typography.styleButtonRegular.copyWith(color: colors.white),
          ),
          subtitle: SelectableText(
            locationState.lastKnownAddressComponents.toString(),
            style: typography.styleSubtext.copyWith(color: colors.white),
          ),
        ),
      ],
      PositiveFeedPaginationBehaviour.buildVisualSeparator(context),
    ];
  }

  List<Widget> buildTroubleshootingAndSupport({
    required DevelopmentViewModel viewModel,
    required DevelopmentViewModelState state,
    required NotificationsControllerState notificationsState,
    required Profile? currentProfile,
    required BuildContext context,
  }) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

    final String currentFCMToken = currentProfile?.fcmToken ?? 'No FCM token found';
    final String currentAPNSToken = notificationsState.apnsToken;

    return [
      CupertinoListTile(
        title: Text(
          'Troubleshooting and Support',
          style: typography.styleSubtextBold.copyWith(color: colors.white),
        ),
      ),
      CupertinoListTile.notched(
        onTap: viewModel.displayAuthClaims,
        title: Text(
          'Display auth claims',
          style: typography.styleButtonRegular.copyWith(color: colors.white),
        ),
        subtitle: Text(
          'Displays the logged in users auth claims.',
          style: typography.styleSubtext.copyWith(color: colors.white),
        ),
      ),
      CupertinoListTile.notched(
        onTap: viewModel.displayNotificationSettings,
        title: Text(
          'Display notification settings',
          style: typography.styleButtonRegular.copyWith(color: colors.white),
        ),
        subtitle: Text(
          'Displays the current notification settings as configured.',
          style: typography.styleSubtext.copyWith(color: colors.white),
        ),
      ),
      CupertinoListTile.notched(
        title: Text(
          'Current FCM Token',
          style: typography.styleButtonRegular.copyWith(color: colors.white),
        ),
        subtitle: SelectableText(
          currentFCMToken,
          style: typography.styleSubtext.copyWith(color: colors.white),
        ),
      ),
      CupertinoListTile.notched(
        title: Text(
          'Current APNS Token',
          style: typography.styleButtonRegular.copyWith(color: colors.white),
        ),
        subtitle: SelectableText(
          currentAPNSToken,
          style: typography.styleSubtext.copyWith(color: colors.white),
        ),
      ),
      CupertinoListTile.notched(
        onTap: () => viewModel.sendTestNotification(),
        title: Text(
          'Send Test Notification',
          style: typography.styleButtonRegular.copyWith(color: colors.white),
        ),
        subtitle: Text(
          'Make sure you are eligible to receive notifications by sending a test notification.',
          style: typography.styleSubtext.copyWith(color: colors.white),
        ),
      ),
      PositiveFeedPaginationBehaviour.buildVisualSeparator(context),
    ];
  }

  List<Widget> buildGeneralSection({
    required DevelopmentViewModel viewModel,
    required DevelopmentViewModelState state,
    required AnalyticsController analyticsController,
    required AnalyticsControllerState analyticsState,
    required SystemControllerState systemState,
    required BuildContext context,
  }) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

    return <Widget>[
      CupertinoListTile(
        title: Text(
          'General',
          style: typography.styleSubtextBold.copyWith(color: colors.white),
        ),
      ),
      CupertinoListTile.notched(
        onTap: viewModel.restartApp,
        title: Text(
          'Restart app',
          style: typography.styleButtonRegular.copyWith(color: colors.white),
        ),
        subtitle: Text(
          'Force restart the application.',
          style: typography.styleSubtext.copyWith(color: colors.white),
        ),
      ),
      CupertinoListTile.notched(
        title: Text(
          'Toggle ID display',
          style: typography.styleButtonRegular.copyWith(color: colors.white),
        ),
        subtitle: Text(
          'Displays the IDs of posts and users where applicable.',
          style: typography.styleSubtext.copyWith(color: colors.white),
        ),
        additionalInfo: Transform.scale(
          scale: 0.7,
          child: PositiveSwitch(
            activeColour: colors.green.withAlpha(210),
            inactiveColour: colors.red.withAlpha(210),
            ignoring: false,
            value: state.displaySelectablePostIDs,
            onTapped: (_) => viewModel.toggleSelectablePostIDs(),
          ),
        ),
      ),
      CupertinoListTile.notched(
        title: Text(
          'Activity Tracking',
          style: typography.styleButtonRegular.copyWith(color: colors.white),
        ),
        subtitle: Text(
          'Your data will be used to deliver promoted content personalized to you, and help us improve your experience.',
          maxLines: 2,
          style: typography.styleSubtext.copyWith(color: colors.white),
        ),
        additionalInfo: Transform.scale(
          scale: 0.7,
          child: PositiveSwitch(
            activeColour: colors.green.withAlpha(210),
            inactiveColour: colors.red.withAlpha(210),
            ignoring: false,
            value: analyticsState.isCollectingData,
            onTapped: (_) => analyticsController.toggleAnalyticsCollection(!analyticsState.isCollectingData),
          ),
        ),
      ),
      CupertinoListTile.notched(
        onTap: () => showLicensePage(
          context: context,
          applicationVersion: systemState.version,
          applicationIcon: Padding(
            padding: const EdgeInsets.only(bottom: kPaddingSmall),
            child: SvgPicture.asset(
              SvgImages.logosFooter,
              width: kLogoMaximumWidth,
            ),
          ),
        ),
        title: Text(
          'View OSS Licenses',
          style: typography.styleButtonRegular.copyWith(color: colors.white),
        ),
        subtitle: Text(
          'Cool code we used to build Positive+1',
          style: typography.styleSubtext.copyWith(color: colors.white),
        ),
      ),
      PositiveFeedPaginationBehaviour.buildVisualSeparator(context),
    ];
  }
}
