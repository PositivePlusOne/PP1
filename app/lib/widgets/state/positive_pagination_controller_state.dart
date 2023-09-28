import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

mixin PositivePaginationControllerState<T> {
  abstract final PagingController<String, T> pagingController;

  String buildCacheKey();
}
