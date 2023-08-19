// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

extension PagingExtensions on PagingController {
  void appendSafePage<T>(List<T> newItems, String nextPageKey) {
    final List<T> actualNewItems = newItems.where((T item) => !itemList!.contains(item)).toList();
    final bool hasNewItems = actualNewItems.isNotEmpty;

    if (hasNewItems) {
      appendPage(actualNewItems, nextPageKey);
    } else {
      appendLastPage(actualNewItems);
    }
  }
}
