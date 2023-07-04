// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/providers/guidance/guidance_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/profiles/profile_controller.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';
import 'guidance_page.dart';

@RoutePage()
class GuidanceEntryPage extends HookConsumerWidget {
  const GuidanceEntryPage({super.key, required this.entryId});

  // TODO(Ted): change to parentId
  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GuidanceControllerState gcs = ref.watch(guidanceControllerProvider);
    final builder = gcs.guidancePageBuilders[entryId];
    final GuidanceController gc = ref.read(guidanceControllerProvider.notifier);

    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final List<Widget> actions = [];

    if (profileControllerState.userProfile != null) {
      actions.addAll(profileControllerState.userProfile!.buildCommonProfilePageActions());
    }

    return Stack(
      children: [
        PositiveScaffold(
          onWillPopScope: gc.onWillPopScope,
          visibleComponents: PositiveScaffoldComponent.onlyHeadingWidgets,
          bottomNavigationBar: PositiveNavigationBar(
            mediaQuery: mediaQuery,
            index: NavigationBarIndex.guidance,
          ),
          headingWidgets: [
            SliverToBoxAdapter(
              child: GuidanceSearchBar(
                hintText: searchHintText(gc.guidanceSection),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    builder!.build(),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (gcs.isBusy) ...[const GuidanceLoadingIndicator()],
      ],
    );
  }

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
}

class GuidanceSearchBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const GuidanceSearchBar({this.hintText = "", super.key});

  final String hintText;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  ConsumerState<GuidanceSearchBar> createState() => _GuidanceSearchBarState();
}

class _GuidanceSearchBarState extends ConsumerState<GuidanceSearchBar> {
  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final GuidanceController gc = ref.read(guidanceControllerProvider.notifier);
    final GuidanceControllerState gcs = ref.read(guidanceControllerProvider);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: kPaddingSmall, left: kPaddingMedium, right: kPaddingMedium),
        child: Row(
          children: [
            PositiveButton.appBarIcon(
              colors: colors,
              primaryColor: colors.black,
              icon: UniconsLine.angle_left_b,
              onTapped: gc.onWillPopScope,
            ),
            kPaddingExtraSmall.asHorizontalBox,
            Expanded(
              child: PositiveSearchField(
                controller: gcs.searchController,
                onSubmitted: gc.onSearch,
                hintText: widget.hintText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
