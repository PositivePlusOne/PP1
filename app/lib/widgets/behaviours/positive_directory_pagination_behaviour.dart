// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/guidance/guidance_directory_entry.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/guidance/guidance_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../services/third_party.dart';
import '../organisms/guidance/guidance_directory_page.dart';

class PositiveDirectoryPaginationBehaviour extends StatefulHookConsumerWidget {
  const PositiveDirectoryPaginationBehaviour({
    this.windowSize = 10,
    super.key,
  });

  final int windowSize;

  static const String kWidgetKey = 'PositiveDirectoryPaginationBehaviour';

  @override
  ConsumerState<PositiveDirectoryPaginationBehaviour> createState() => _PositiveDirectoryPaginationBehaviourState();
}

class _PositiveDirectoryPaginationBehaviourState extends ConsumerState<PositiveDirectoryPaginationBehaviour> {
  final PagingController<String, GuidanceDirectoryEntry> pagingController = PagingController(firstPageKey: "");

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  Future<void> setupListeners() async {
    pagingController.addPageRequestListener(onRequestPage);
  }

  Future<void> disposeListeners() async {
    pagingController.removePageRequestListener(onRequestPage);
  }

  Future<void> onRequestPage(String pageKey) async {
    final Logger logger = ref.read(loggerProvider);

    try {
      final GuidanceApiService apiService = await providerContainer.read(guidanceApiServiceProvider.future);
      final EndpointResponse response = await apiService.getDirectoryEntryWindow(cursor: pageKey);
      final List<GuidanceDirectoryEntry> entries = (response.data['guidanceDirectoryEntries'] as List<dynamic>).map((dynamic e) => GuidanceDirectoryEntry.fromJson(e as Map<String, dynamic>)).toList();
      if (entries.isEmpty || response.cursor == null) {
        pagingController.appendSafeLastPage(entries);
        return;
      }

      pagingController.appendSafePage(entries, response.cursor!);
    } catch (e) {
      logger.e(e.toString());
      pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Widget loadingIndicator = GuidanceLoadingIndicator();
    return PagedSliverList.separated(
      pagingController: pagingController,
      separatorBuilder: (context, index) => const SizedBox(height: kPaddingMedium),
      builderDelegate: PagedChildBuilderDelegate<GuidanceDirectoryEntry>(
        animateTransitions: true,
        transitionDuration: kAnimationDurationRegular,
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
        newPageProgressIndicatorBuilder: (context) => loadingIndicator,
        itemBuilder: buildItem,
      ),
    );
  }

  Widget buildItem(BuildContext context, GuidanceDirectoryEntry item, int index) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final AppRouter appRouter = ref.read(appRouterProvider);
    final GuidanceControllerState guidanceControllerState = ref.read(guidanceControllerProvider);

    final String id = item.flMeta?.id ?? '';

    return PositiveTapBehaviour(
      onTap: (_) => appRouter.push(GuidanceDirectoryEntryRoute(guidanceEntryId: id)),
      isEnabled: !guidanceControllerState.isBusy,
      child: Container(
        padding: const EdgeInsets.all(kPaddingMedium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          color: colors.white,
        ),
        child: Row(
          children: <Widget>[
            if (item.logoUrl.isNotEmpty) ...<Widget>[
              PositiveMediaImage(media: Media.fromImageUrl(item.logoUrl), width: kIconHuge, height: kIconHuge),
              const SizedBox(width: kPaddingMedium),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.title, style: typography.styleHeroSmall.copyWith(color: colors.black)),
                  Text(item.description, style: typography.styleSubtitle.copyWith(color: colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
