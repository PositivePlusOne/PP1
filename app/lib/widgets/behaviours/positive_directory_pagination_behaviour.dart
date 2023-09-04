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
import 'package:app/dtos/database/guidance/guidance_directory_entry.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/main.dart';
import 'package:app/services/api.dart';
import 'package:app/services/search_api_service.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/organisms/guidance/guidance_directory.dart';
import '../../services/third_party.dart';

class PositiveDirectoryPaginationBehaviour extends StatefulHookConsumerWidget {
  const PositiveDirectoryPaginationBehaviour({
    this.windowSize = 10,
    this.isBusy = false,
    this.searchTerm = '',
    super.key,
  });

  final int windowSize;
  final bool isBusy;

  final String searchTerm;

  static const String kWidgetKey = 'PositiveDirectoryPaginationBehaviour';

  @override
  ConsumerState<PositiveDirectoryPaginationBehaviour> createState() => _PositiveDirectoryPaginationBehaviourState();
}

class _PositiveDirectoryPaginationBehaviourState extends ConsumerState<PositiveDirectoryPaginationBehaviour> {
  final PagingController<String, GuidanceDirectoryEntry> pagingController = PagingController(firstPageKey: "");
  bool isBusy = false;

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
    logger.i('onRequestPage: $pageKey');

    if (isBusy) {
      logger.i('onRequestPage: isBusy');
      return;
    }

    isBusy = true;

    try {
      final List<GuidanceDirectoryEntry> entries = [];
      String newCursor = '';

      if (widget.searchTerm.isEmpty) {
        final GuidanceApiService apiService = await providerContainer.read(guidanceApiServiceProvider.future);
        final EndpointResponse response = await apiService.getDirectoryEntryWindow(cursor: pageKey);
        final List<GuidanceDirectoryEntry> newEntries = (response.data['guidanceDirectoryEntries'] as List<dynamic>).map((dynamic e) => GuidanceDirectoryEntry.fromJson(e as Map<String, dynamic>)).toList();

        newCursor = response.cursor ?? '';
        entries.addAll(newEntries);
      } else {
        final SearchApiService apiService = await providerContainer.read(searchApiServiceProvider.future);
        final SearchResult<GuidanceDirectoryEntry> response = await apiService.search(
          query: widget.searchTerm,
          fromJson: (json) => GuidanceDirectoryEntry.fromJson(json),
          index: "guidanceDirectoryEntries",
          pagination: Pagination(
            cursor: pageKey,
          ),
        );

        newCursor = response.cursor;
        entries.addAll(response.results);
      }

      if (entries.isEmpty || newCursor.isEmpty) {
        pagingController.appendSafeLastPage(entries);
        return;
      }

      pagingController.appendSafePage(entries, newCursor);
    } catch (e) {
      logger.e(e.toString());
      pagingController.error = e;
    } finally {
      isBusy = false;
    }
  }

  @override
  void didUpdateWidget(PositiveDirectoryPaginationBehaviour oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.searchTerm != widget.searchTerm) {
      pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Widget loadingIndicator = Align(alignment: Alignment.center, child: PositiveLoadingIndicator());
    return PagedSliverList.separated(
      pagingController: pagingController,
      separatorBuilder: (context, index) => const SizedBox(height: kPaddingExtraSmall),
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
    return GuidanceDirectoryTile(
      entry: item,
      isBusy: widget.isBusy || isBusy,
    );
  }
}
