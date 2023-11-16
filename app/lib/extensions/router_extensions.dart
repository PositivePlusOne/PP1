// Project imports:
import 'package:app/gen/app_router.dart';

// Package imports:

// Project imports:

extension RouterExtensions on AppRouter {
  void removeLastOrHome() {
    final bool isLastRoute = stack.length == 1;
    if (isLastRoute) {
      replace(const HomeRoute());
    } else {
      removeLast();
    }
  }
}
