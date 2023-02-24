// Dart imports:
import 'dart:async';

// Package imports:
import 'package:app/providers/user/messaging_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/key_constants.dart';
import '../../../services/third_party.dart';

part 'home_controller.freezed.dart';
part 'home_controller.g.dart';

@freezed
class HomeControllerState with _$HomeControllerState {
  const factory HomeControllerState({
    @Default(false) bool isRefreshing,
  }) = _HomeControllerState;

  factory HomeControllerState.initialState() => const HomeControllerState();
}

@riverpod
class HomeController extends _$HomeController with LifecycleMixin {
  final RefreshController refreshController = RefreshController();

  @override
  HomeControllerState build() {
    return HomeControllerState.initialState();
  }

  Future<void> onRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    refreshController.refreshCompleted();
  }
}
