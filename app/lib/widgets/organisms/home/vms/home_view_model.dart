// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

part 'home_view_model.freezed.dart';
part 'home_view_model.g.dart';

@freezed
class HomeViewModelState with _$HomeViewModelState {
  const factory HomeViewModelState({
    @Default(false) bool isRefreshing,
  }) = _HomeViewModelState;

  factory HomeViewModelState.initialState() => const HomeViewModelState();
}

@riverpod
class HomeViewModel extends _$HomeViewModel with LifecycleMixin {
  final RefreshController refreshController = RefreshController();

  @override
  HomeViewModelState build() {
    return HomeViewModelState.initialState();
  }

  Future<void> onRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    refreshController.refreshCompleted();
  }

  Future<void> onChatSelected() async {
    final Logger log = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);

    log.d('HomeViewModel: onChatSelected');
    await router.push(const ChatListRoute());
  }
}
