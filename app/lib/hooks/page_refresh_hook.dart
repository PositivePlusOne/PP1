// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';

void usePageRefreshHook({
  Duration refreshDuration = const Duration(seconds: 10),
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
    _timer = Timer.periodic(hook.refreshDuration, (_) {
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
