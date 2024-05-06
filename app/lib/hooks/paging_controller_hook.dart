// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cron/cron.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Project imports:
import 'package:app/extensions/future_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/services/third_party.dart';

void usePagingController({
  required PagingController controller,
  required FutureOr<void> Function(String) onPreviousPage,
  FutureOr<void> Function()? onNextPage,
}) {
  return use(PagingControllerHook(
    controller: controller,
    onPreviousPageRequest: onPreviousPage,
    onNextPagePageRequest: onNextPage,
  ));
}

class PagingControllerHook extends Hook<void> {
  const PagingControllerHook({
    required this.controller,
    required this.onPreviousPageRequest,
    this.onNextPagePageRequest,
  });

  final PagingController controller;
  final FutureOr<void> Function(String) onPreviousPageRequest;
  final FutureOr<void> Function()? onNextPagePageRequest;

  @override
  HookState<void, Hook<void>> createState() {
    return PagingControllerHookState();
  }
}

class PagingControllerHookState extends HookState<void, PagingControllerHook> {
  ScheduledTask? nextPageCheckTask;
  Timer? periodicCheckTimer;

  @override
  void initHook() {
    super.initHook();
    setupListeners();
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  @override
  void didUpdateHook(PagingControllerHook oldHook) {
    super.didUpdateHook(oldHook);

    if (hook.controller == oldHook.controller) {
      return;
    }

    final bool hasListeners = hook.controller.hasListeners;
    final bool isRefreshAction = oldHook.controller.value.status == PagingStatus.ongoing && hook.controller.value.status == PagingStatus.loadingFirstPage;

    // Manually trigger the next page request if the controller has no listeners and the action is a refresh
    if (!hasListeners && isRefreshAction) {
      onPreviousPageRequested("");
    }
  }

  Future<void> setupListeners() async {
    hook.controller.addPageRequestListener(onPreviousPageRequested);

    final FirebaseRemoteConfig remoteConfig = await providerContainer.read(firebaseRemoteConfigProvider.future);
    final int periodicCheckFrequency = remoteConfig.getInt(SystemController.kFirebaseRemoteConfigFeedUpdateCheckFrequencyKey);

    await Future.delayed(Duration(seconds: periodicCheckFrequency));
    periodicCheckTimer = Timer.periodic(Duration(seconds: periodicCheckFrequency), (Timer timer) {
      onNextPageRequested();
    });
  }

  Future<void> disposeListeners() async {
    hook.controller.removePageRequestListener(onPreviousPageRequested);
    await nextPageCheckTask?.cancel();
  }

  void requestPage() {
    final bool isLastPage = hook.controller.nextPageKey == null;
    if (isLastPage) {
      return;
    }

    hook.controller.notifyPageRequestListeners(hook.controller.nextPageKey);
  }

  Future<void> onPreviousPageRequested(dynamic pageKey) async {
    await hook.onPreviousPageRequest(pageKey);
  }

  Future<void> onNextPageRequested() async {
    await hook.onNextPagePageRequest?.call();
  }

  @override
  void build(BuildContext context) {}
}
