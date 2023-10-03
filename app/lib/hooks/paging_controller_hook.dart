// Flutter imports:
import 'dart:async';

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

  void setupListeners() {
    hook.controller.addPageRequestListener((dynamic pageKey) {
      hook.listener(pageKey.toString());
    });
  }

  @override
  void build(BuildContext context) {}
}
