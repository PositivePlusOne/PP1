// Package imports:
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

extension PagingExtensions on PagingController {
  void insertItem<T>(
    int index,
    T item, {
    bool Function(T a, T b)? equals,
  }) {
    if (itemList == null) {
      itemList = <T>[item];

      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      notifyListeners();
      return;
    }

    if (equals != null) {
      final bool exists = itemList!.any((dynamic element) => equals(element, item));
      if (exists) {
        return;
      }
    }

    itemList!.insert(index, item);

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    notifyListeners();
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
