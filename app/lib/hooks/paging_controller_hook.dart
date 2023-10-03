// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

void usePagingController({
  required PagingController controller,
  required FutureOr<void> Function(String) listener,
}) {
  return use(PagingControllerHook(
    controller: controller,
    listener: listener,
  ));
}

class PagingControllerHook extends Hook<void> {
  const PagingControllerHook({
    required this.controller,
    required this.listener,
  });

  final PagingController controller;
  final void Function(String) listener;

  @override
  HookState<void, Hook<void>> createState() {
    return PagingControllerHookState();
  }
}

class PagingControllerHookState extends HookState<void, PagingControllerHook> {
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

  void setupListeners() {
    hook.controller.addPageRequestListener(onPageRequest);
  }

  void disposeListeners() {
    hook.controller.removePageRequestListener(onPageRequest);
  }

  void requestPage() {
    final bool isLastPage = hook.controller.nextPageKey == null;
    if (isLastPage) {
      return;
    }

    hook.controller.notifyPageRequestListeners(hook.controller.nextPageKey);
  }

  void onPageRequest(dynamic pageKey) {
    hook.listener(pageKey);
  }

  @override
  void didUpdateHook(PagingControllerHook oldHook) {
    super.didUpdateHook(oldHook);

    if (hook.controller != oldHook.controller) {
      disposeListeners();
      setupListeners();
      requestPage();
    }
  }

  @override
  void build(BuildContext context) {}
}
