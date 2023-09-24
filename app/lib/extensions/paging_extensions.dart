// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

extension PagingExtensions on PagingController {
  // Append a page to the current list of items and advance the pageKey.
  // This is useful is used in something like an animated switched list
  void notifyPage(String nextPageKey) {
    appendPage([], nextPageKey);
  }

  void appendSafePage<T>(List<T> newItems, String nextPageKey) {
    if (itemList == null) {
      appendPage(newItems, nextPageKey);
      return;
    }

    final List<T> actualNewItems = newItems.where((T item) => !itemList!.contains(item)).toList();
    final bool hasNewItems = actualNewItems.isNotEmpty;

    if (hasNewItems) {
      appendPage(actualNewItems, nextPageKey);
    } else {
      appendLastPage(actualNewItems);
    }
  }

  void appendSafeLastPage<T>(List<T> newItems) {
    if (newItems.isEmpty) {
      appendLastPage(newItems);
      return;
    }

    final List<T> actualNewItems = newItems.whereType<T>().where((T item) => !(itemList?.contains(item) ?? false)).toList();
    final bool hasNewItems = actualNewItems.isNotEmpty;

    if (hasNewItems) {
      appendLastPage(actualNewItems);
    } else {
      appendLastPage(<T>[]);
    }
  }
}
