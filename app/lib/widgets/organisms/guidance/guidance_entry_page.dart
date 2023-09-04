// Dart imports:
import 'dart:async';

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
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/organisms/guidance/builders/builder.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/profiles/profile_controller.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';

@RoutePage()
class GuidanceEntryPage extends HookConsumerWidget {
  const GuidanceEntryPage({
    required this.entryId,
    this.searchTerm = '',
    super.key,
  });

  final String entryId;
  final String searchTerm;

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

    return PositiveScaffold(
      isBusy: gcs.isBusy,
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQuery,
        index: NavigationBarIndex.guidance,
      ),
      headingWidgets: <Widget>[
        SliverPinnedHeader(
          child: GuidanceSearchBar(
            onSubmitted: gc.onSearch,
            onBackSelected: () => context.router.pop(),
            initialText: searchTerm,
            hintText: searchHintText(gc.guidanceSection),
          ),
        ),
        if (builder != null) ...<Widget>[
          SliverToBoxAdapter(child: builder.build()),
        ],
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
  const GuidanceSearchBar({
    required this.onSubmitted,
    required this.onBackSelected,
    this.initialText = "",
    this.hintText = "",
    this.isEnabled = true,
    super.key,
  });

  final String initialText;
  final String hintText;
  final bool isEnabled;

  final FutureOr<void> Function(String, TextEditingController) onSubmitted;
  final VoidCallback onBackSelected;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  ConsumerState<GuidanceSearchBar> createState() => _GuidanceSearchBarState();
}

class _GuidanceSearchBarState extends ConsumerState<GuidanceSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double topPadding = mediaQuery.padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: kPaddingSmall + topPadding,
        left: kPaddingMedium,
        right: kPaddingMedium,
        bottom: kPaddingSmall,
      ),
      decoration: BoxDecoration(
        color: colors.colorGray1,
      ),
      child: Row(
        children: [
          PositiveButton.appBarIcon(
            colors: colors,
            primaryColor: colors.black,
            icon: UniconsLine.angle_left_b,
            onTapped: widget.onBackSelected,
          ),
          kPaddingExtraSmall.asHorizontalBox,
          Expanded(
            child: PositiveSearchField(
              controller: _controller,
              onSubmitted: (str) => widget.onSubmitted(str, _controller),
              initialText: widget.initialText,
              hintText: widget.hintText,
              isEnabled: widget.isEnabled,
            ),
          ),
        ],
      ),
    );
  }
}
