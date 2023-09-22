// Flutter imports:
import 'package:app/gen/app_router.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:app/constants/country_constants.dart';

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
