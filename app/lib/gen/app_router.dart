// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../widgets/organisms/splash/splash_page.dart';

part 'app_router.g.dart';
part 'app_router.gr.dart';

@Riverpod(keepAlive: true)
AppRouter appRouter(AppRouterRef ref) {
  return AppRouter();
}

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route', // Page suffixes are replaced with Route
  routes: [
    AutoRoute(page: SplashPage, initial: true),
  ],
)
class AppRouter extends _$AppRouter {}
