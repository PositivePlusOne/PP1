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
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
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

    final AppRouter appRouter = ref.read(appRouterProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final bool isNonProduction = systemControllerState.environment != SystemEnvironment.production;
    final bool isShowingDebugMessages = systemControllerState.showingDebugMessages;

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
                title: Text(
                  'Welcome to our "secret" development page!',
                  style: typography.styleNotification.copyWith(color: colors.white),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SelectableText(
                      developmentViewModelState.status,
                      maxLines: 3,
                      style: typography.styleSubtext.copyWith(color: colors.white),
                    ),
                    const SizedBox(height: kPaddingExtraSmall),
                    Text(
                      'Version: ${systemControllerState.version}',
                      style: typography.styleSubtextBold.copyWith(color: colors.white),
                    ),
                  ],
                ),
              ),
              if (isNonProduction) ...<Widget>[
                PositiveFeedPaginationBehaviour.buildVisualSeparator(context),
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
                      activeColour: colors.white,
                      inactiveColour: colors.colorGray7,
                      ignoring: false,
                      value: isShowingDebugMessages,
                      onTapped: (_) => ref.read(systemControllerProvider.notifier).toggleDebugMessages(),
                    ),
                  ),
                ),
              ],
              PositiveFeedPaginationBehaviour.buildVisualSeparator(context),
              CupertinoListTile(
                title: Text(
                  'Design and UI',
                  style: typography.styleSubtextBold.copyWith(color: colors.white),
                ),
              ),
              CupertinoListTile.notched(
                onTap: developmentViewModel.displayAuthClaims,
                title: Text(
                  'Dark mode',
                  style: typography.styleButtonRegular.copyWith(color: colors.white),
                ),
                subtitle: Text(
                  'This is a work in progress, so please bare with us!',
                  style: typography.styleSubtext.copyWith(color: colors.white),
                ),
                additionalInfo: Transform.scale(
                  scale: 0.7,
                  child: PositiveSwitch(
                    activeColour: colors.white,
                    inactiveColour: colors.colorGray7,
                    ignoring: false,
                    value: developmentViewModelState.darkMode,
                    onTapped: (_) => developmentViewModel.toggleDarkMode(),
                  ),
                ),
              ),
              PositiveFeedPaginationBehaviour.buildVisualSeparator(context),
              CupertinoListTile(
                title: Text(
                  'General',
                  style: typography.styleSubtextBold.copyWith(color: colors.white),
                ),
              ),
              CupertinoListTile.notched(
                onTap: developmentViewModel.restartApp,
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
                onTap: developmentViewModel.displayAuthClaims,
                title: Text(
                  'Request auth claims',
                  style: typography.styleButtonRegular.copyWith(color: colors.white),
                ),
                subtitle: Text(
                  'Displays the logged in users auth claims in the status bar',
                  style: typography.styleSubtext.copyWith(color: colors.white),
                ),
              ),
              CupertinoListTile.notched(
                onTap: developmentViewModel.displayAuthClaims,
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
                    activeColour: colors.white,
                    inactiveColour: colors.colorGray7,
                    ignoring: false,
                    value: developmentViewModelState.displaySelectablePostIDs,
                    onTapped: (_) => developmentViewModel.toggleSelectablePostIDs(),
                  ),
                ),
              ),
              CupertinoListTile.notched(
                onTap: () => showLicensePage(
                  context: context,
                  applicationVersion: systemControllerState.version,
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
            ],
          ),
        ),
      ],
    );
  }
}
