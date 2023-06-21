// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
import '../../../gen/app_router.dart';
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

    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final List<Widget> actions = [];

    if (profileControllerState.userProfile != null) {
      actions.addAll(profileControllerState.userProfile!.buildCommonProfilePageActions());
    }

    return Stack(
      children: [
        PositiveScaffold(
          onWillPopScope: () async {
            final AppRouter router = ref.read(appRouterProvider);
            router.removeLast();
            return false;
          },
          bottomNavigationBar: PositiveNavigationBar(
            mediaQuery: mediaQuery,
            index: NavigationBarIndex.guidance,
          ),
          appBar: const GuidanceSearchBar(),
          headingWidgets: [
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
}

class GuidanceSearchBar extends ConsumerWidget implements PreferredSizeWidget {
  const GuidanceSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final GuidanceController gc = ref.read(guidanceControllerProvider.notifier);

    return SafeArea(
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
              child: PositiveSearchField(hintText: searchHintText(gc.guidanceSection), onSubmitted: gc.onSearch),
            ),
          ],
        ),
      ),
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

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
