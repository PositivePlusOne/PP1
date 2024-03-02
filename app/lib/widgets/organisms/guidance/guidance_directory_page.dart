// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/helpers/profile_helpers.dart';
import 'package:app/widgets/behaviours/positive_directory_pagination_behaviour.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/guidance/guidance_entry_page.dart';
import '../../../providers/guidance/guidance_controller.dart';
import '../../../providers/profiles/profile_controller.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';

@RoutePage()
class GuidanceDirectoryPage extends ConsumerWidget {
  const GuidanceDirectoryPage({super.key});

  String searchHintText(GuidanceSection? gs) {
    switch (gs) {
      case GuidanceSection.guidance:
        return 'Search Guidance';
      case GuidanceSection.directory:
        return 'Search Directory';
      case GuidanceSection.appHelp:
        return 'Search Help';
      default:
        return 'Search';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final GuidanceControllerState state = ref.watch(guidanceControllerProvider);
    final GuidanceController controller = ref.read(guidanceControllerProvider.notifier);

    final ProfileControllerState profileControllerState = ref.read(profileControllerProvider);

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final List<Widget> actions = [];

    if (profileControllerState.currentProfile != null) {
      actions.addAll(buildCommonProfilePageActions());
    }

    return PositiveScaffold(
      isBusy: state.isBusy,
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQuery,
        index: NavigationBarIndex.guidance,
      ),
      headingWidgets: [
        SliverPinnedHeader(
          child: GuidanceSearchBar(
            onSubmitted: controller.onSearch,
            onBackSelected: () => context.router.pop(),
            isEnabled: !state.isBusy,
            initialText: '',
            hintText: searchHintText(controller.guidanceSection),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium, top: kPaddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Directory',
                  style: typography.styleHero.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingMedium),
                Text(
                  'Find companies and charities that are helping to support people impacted by HIV.',
                  style: typography.styleSubtitle.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingMedium),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
          sliver: PositiveDirectoryPaginationBehaviour(isBusy: state.isBusy),
        ),
      ],
    );
  }
}
