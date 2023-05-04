// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../providers/guidance/guidance_controller.dart';
import '../../../providers/system/design_controller.dart';
import '../../../providers/user/user_controller.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/indicators/positive_loading_indicator.dart';
import '../../molecules/layouts/positive_basic_sliver_list.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';
import '../../molecules/tiles/positive_list_tile.dart';
import '../home/components/hub_app_bar_content.dart';
import 'guidance_view_model.dart';

@RoutePage()
class GuidancePage extends ConsumerWidget {
  const GuidancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final mediaQuery = MediaQuery.of(context);
    final userControllerState = ref.watch(userControllerProvider);
    final shouldDisplayActivateAccountBanner = userControllerState.user == null;
    final vm = ref.watch(guidanceViewModelProvider.notifier);
    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQuery,
        index: 3,
      ),
      appBar: PositiveAppBar(
        applyLeadingandTrailingPadding: true,
        safeAreaQueryData: mediaQuery,
        foregroundColor: colors.black,
        backgroundColor: colors.pink,
        bottom: HubAppBarContent(
          shouldDisplayActivateAccountBanner: shouldDisplayActivateAccountBanner,
        ),
        leading: PositiveButton.appBarIcon(
            colors: colors,
            primaryColor: colors.black,
            icon: UniconsLine.angle_left_b,
            onTapped: () {
              final gc = ref.read(guidanceControllerProvider.notifier);
              gc.popGuidanceContent();
            }),
        trailType: PositiveAppBarTrailType.convex,
        trailing: <Widget>[
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.bell,
            onTapped: vm.onNotificationsSelected,
          ),
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.user,
            onTapped: vm.onAccountSelected,
          ),
        ],
      ),
      headingWidgets: [
        PositiveBasicSliverList(
          includeAppBar: false,
          children: getGuidancePageContent(ref),
        ),
      ],
    );
  }

  List<Widget> getGuidancePageContent(WidgetRef ref) {
    final bool busy = ref.watch(guidanceControllerProvider.select((value) => value.isBusy));
    if (busy) {
      return [
        const PositiveLoadingIndicator(),
      ];
    }

    final stack = ref.watch(guidanceControllerProvider.select((value) => value.guidancePageContentStack));

    // if empty, display guidance root
    if (stack.isEmpty) {
      return buildRootGuidanceContent(ref);
    }
    // if not empty, build content builders on top of stack
    return [
      stack.last.build(),
    ];
  }

  List<Widget> buildRootGuidanceContent(WidgetRef ref) {
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return [
      Text(
        "Let's keep it real",
        style: typography.styleHero.copyWith(color: colors.black),
      ),
      Text(
        "Search our guidance and directory to better understand HIV and you.",
        style: typography.styleBody.copyWith(color: colors.black),
      ),
      PositiveListTile(
        title: 'Guidance',
        subtitle: 'View our guidance to get the support you deserve.',
        onTap: () {
          final gc = ref.read(guidanceControllerProvider.notifier);
          gc.loadGuidanceCategories(null);
        },
      ),
      PositiveListTile(
        title: 'Directory',
        subtitle: 'View the companies and charities that are involved with Positive+1 and HIV.',
        onTap: () {
          final gc = ref.read(guidanceControllerProvider.notifier);
          gc.loadDirectoryEntries();
        },
      ),
      PositiveListTile(
        title: 'App Help',
        subtitle: 'Get wider help and information about the Positive+1 app.',
        onTap: () {
          final gc = ref.read(guidanceControllerProvider.notifier);
          gc.loadGuidanceCategories(null);
        },
      ),
    ].spaceWithVertical(kPaddingMedium);
  }
}
