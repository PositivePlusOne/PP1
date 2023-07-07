// Dart imports:
import 'dart:async';

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
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/organisms/guidance/builders/builder.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/profiles/profile_controller.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';
import 'guidance_page.dart';

@RoutePage()
class GuidanceEntryPage extends HookConsumerWidget {
  const GuidanceEntryPage({
    required this.entryId,
    super.key,
  });

  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GuidanceControllerState gcs = ref.watch(guidanceControllerProvider);
    final GuidanceController gc = ref.read(guidanceControllerProvider.notifier);
    final CacheController cc = ref.read(cacheControllerProvider.notifier);
    final ContentBuilder? builder = cc.getFromCache(entryId);

    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final List<Widget> actions = [];

    if (profileControllerState.currentProfile != null) {
      actions.addAll(profileControllerState.currentProfile!.buildCommonProfilePageActions());
    }

    return Stack(
      children: [
        PositiveScaffold(
          bottomNavigationBar: PositiveNavigationBar(
            mediaQuery: mediaQuery,
            index: NavigationBarIndex.guidance,
          ),
          headingWidgets: [
            SliverToBoxAdapter(
              child: GuidanceSearchBar(
                onSubmitted: gc.onSearch,
                onChange: gc.onSearchTextChanged,
                onBackSelected: () => context.router.pop(),
                hintText: searchHintText(gc.guidanceSection),
              ),
            ),
            if (builder != null) ...<Widget>[
              SliverToBoxAdapter(child: builder.build()),
            ],
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

class GuidanceSearchBar extends ConsumerWidget implements PreferredSizeWidget {
  const GuidanceSearchBar({
    required this.onSubmitted,
    required this.onBackSelected,
    required this.onChange,
    this.hintText = "",
    super.key,
  });

  final String hintText;

  final FutureOr<void> Function(String) onSubmitted;
  final FutureOr<void> Function(String) onChange;
  final VoidCallback onBackSelected;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: kPaddingSmall, left: kPaddingMedium, right: kPaddingMedium, bottom: kPaddingMassive),
        child: Row(
          children: [
            PositiveButton.appBarIcon(
              colors: colors,
              primaryColor: colors.black,
              icon: UniconsLine.angle_left_b,
              onTapped: onBackSelected,
            ),
            kPaddingExtraSmall.asHorizontalBox,
            Expanded(
              child: PositiveSearchField(
                onSubmitted: onSubmitted,
                onChange: onChange,
                hintText: hintText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
