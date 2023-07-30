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
import 'package:app/main.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import '../../services/third_party.dart';

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

      pagingController.appendPage(entries, response.cursor);
    } catch (e) {
      logger.e(e.toString());
      pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Widget loadingIndicator = PositiveLoadingIndicator();
    return PagedSliverList.separated(
      pagingController: pagingController,
      separatorBuilder: (context, index) => const SizedBox(height: kPaddingMedium),
      builderDelegate: PagedChildBuilderDelegate<GuidanceDirectoryEntry>(
        animateTransitions: true,
        itemBuilder: (_, item, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: kPaddingMedium),
            child: Container(
              color: Colors.red,
              child: Text(item.title),
            ),
          );
        },
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
        newPageProgressIndicatorBuilder: (context) => loadingIndicator,
      ),
    );
  }
}
