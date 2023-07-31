// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/molecules/banners/positive_banner.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../providers/guidance/guidance_controller.dart';
import '../../../providers/profiles/profile_controller.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/banners/positive_button_banner.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';

@RoutePage()
class GuidancePage extends ConsumerWidget {
  const GuidancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final GuidanceControllerState state = ref.watch(guidanceControllerProvider);
    final GuidanceController controller = ref.read(guidanceControllerProvider.notifier);

    final ProfileControllerState profileControllerState = ref.read(profileControllerProvider);

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final List<Widget> actions = [];

    if (profileControllerState.currentProfile != null) {
      actions.addAll(profileControllerState.currentProfile!.buildCommonProfilePageActions());
    }

    return Stack(
      children: [
        PositiveScaffold(
          isBusy: state.isBusy,
          bottomNavigationBar: PositiveNavigationBar(
            mediaQuery: mediaQuery,
            index: NavigationBarIndex.guidance,
          ),
          appBar: PositiveAppBar(
            applyLeadingandTrailingPadding: true,
            safeAreaQueryData: mediaQuery,
            foregroundColor: colors.black,
            backgroundColor: colors.colorGray1,
            trailType: PositiveAppBarTrailType.convex,
            trailing: actions,
          ),
          headingWidgets: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  buildRootGuidanceContent(controller),
                ),
              ),
            ),
          ],
        ),
        if (state.isBusy) ...[const GuidanceLoadingIndicator()],
      ],
    );
  }

  List<Widget> buildRootGuidanceContent(GuidanceController controller) {
    final typography = providerContainer.read(designControllerProvider.select((value) => value.typography));
    final colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

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
        bannerDecoration: BannerDecoration.type1,
        onTapped: () {
          controller.selectGuidanceSection(GuidanceSection.guidance);
          controller.loadGuidanceCategories(null);
        },
      ),
      PositiveButtonBanner(
        heading: 'Directory',
        body: 'View the companies and charities that are involved with Positive+1 and HIV.',
        buttonText: 'View',
        bannerDecoration: BannerDecoration.type2,
        onTapped: () {
          controller.selectDirectorySection();
        },
      ),
      PositiveButtonBanner(
        heading: 'App Help',
        body: 'Get wider help and information about the Positive+1 app.',
        buttonText: 'View',
        bannerDecoration: BannerDecoration.type3,
        onTapped: () {
          controller.selectGuidanceSection(GuidanceSection.appHelp);
          controller.loadAppHelpCategories(null);
        },
      ),
    ].spaceWithVertical(kPaddingMedium);
  }
}

class GuidanceLoadingIndicator extends StatelessWidget {
  const GuidanceLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: PositiveLoadingIndicator(),
        ),
      ),
    );
  }
}
