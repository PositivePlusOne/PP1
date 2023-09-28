// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

extension PagingExtensions on PagingController {
  void update() {
    value = PagingState(
      itemList: itemList,
      error: null,
      nextPageKey: nextPageKey,
    );
  }

  // Append a page to the current list of items and advance the pageKey.
  // This is useful is used in something like an animated switched list
  void notifyPage(String nextPageKey) {
    appendPage([], nextPageKey);
  }

  void appendSafePage(List<dynamic> newItems, String nextPageKey) {
    if (itemList == null) {
      appendPage(newItems, nextPageKey);
      return;
    }

    final List<dynamic> actualNewItems = newItems.where((dynamic item) => !itemList!.contains(item)).toList();
    final bool hasNewItems = actualNewItems.isNotEmpty;

    if (hasNewItems) {
      appendPage(actualNewItems, nextPageKey);
    } else {
      appendLastPage(actualNewItems);
    }
  }

  void appendSafeLastPage<T>(List<T> newItems) {
    if (newItems.isEmpty) {
      appendLastPage(<T>[]);
      return;
    }

    final List<T> actualNewItems = newItems.where((dynamic item) => item is T && !(itemList?.contains(item) ?? false)).toList();
    final bool hasNewItems = actualNewItems.isNotEmpty;

    if (hasNewItems) {
      appendLastPage(actualNewItems);
    } else {
      appendLastPage(<T>[]);
    }
  }
}
