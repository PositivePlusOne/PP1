import 'dart:async';

import 'package:app/main.dart';
import 'package:app/services/third_party.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void usePageRefreshHook({
  Duration refreshDuration = const Duration(minutes: 1),
}) {
  use(PageRefreshHook(refreshDuration: refreshDuration));
}

class PageRefreshHook extends Hook<void> {
  const PageRefreshHook({
    required this.refreshDuration,
  });

  final Duration refreshDuration;

  @override
  HookState<void, Hook<void>> createState() {
    return PageRebuildHookState();
  }
}

class PageRebuildHookState extends HookState<void, PageRefreshHook> {
  late final Timer _timer;

  @override
  void initHook() {
    final logger = providerContainer.read(loggerProvider);

    _timer = Timer.periodic(hook.refreshDuration, (_) {
      logger.d('Page refresh hook triggered');
      setState(() {});
    });

    super.initHook();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void build(BuildContext context) {}
}
