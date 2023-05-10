// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../providers/guidance/guidance_controller.dart';
import '../../../providers/profiles/profile_controller.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../molecules/banners/positive_button_banner.dart';
import '../../molecules/layouts/positive_basic_sliver_list.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';

@RoutePage()
class GuidancePage extends ConsumerWidget {
  const GuidancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final GuidanceController guidanceController = ref.read(guidanceControllerProvider.notifier);
    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final List<Widget> actions = [];

    if (profileControllerState.userProfile != null) {
      actions.addAll(profileControllerState.userProfile!.buildCommonProfilePageActions());
    }

    return PositiveScaffold(
      onWillPopScope: guidanceController.onWillPopScope,
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQuery,
        index: NavigationBarIndex.guidance,
      ),
      appBar: PositiveAppBar(
        includeLogoWherePossible: guidanceController.shouldShowLogo,
        applyLeadingandTrailingPadding: true,
        safeAreaQueryData: mediaQuery,
        foregroundColor: colors.black,
        backgroundColor: colors.colorGray1,
        leading: guidanceController.shouldShowBackButton
            ? PositiveButton.appBarIcon(
                colors: colors,
                primaryColor: colors.black,
                icon: UniconsLine.angle_left_b,
                onTapped: guidanceController.onWillPopScope,
              )
            : null,
        trailType: PositiveAppBarTrailType.convex,
        trailing: actions,
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
        const Center(child: CircularProgressIndicator()),
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
      PositiveButtonBanner(
        heading: 'Guidance',
        body: 'View our guidance to get the support you deserve.',
        buttonText: 'View',
        onTapped: () {
          final gc = ref.read(guidanceControllerProvider.notifier);
          gc.loadGuidanceCategories(null);
        },
      ),
      PositiveButtonBanner(
        heading: 'Directory',
        body: 'View the companies and charities that are involved with Positive+1 and HIV.',
        buttonText: 'View',
        onTapped: () {
          final gc = ref.read(guidanceControllerProvider.notifier);
          gc.loadDirectoryEntries();
        },
      ),
      PositiveButtonBanner(
        heading: 'App Help',
        body: 'Get wider help and information about the Positive+1 app.',
        buttonText: 'View',
        onTapped: () {
          final gc = ref.read(guidanceControllerProvider.notifier);
          gc.loadAppHelpCategories(null);
        },
      ),
    ].spaceWithVertical(kPaddingMedium);
  }
}
