// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';

// Project imports:

void useFirstRenderHook({
  required VoidCallback callback,
}) {
  return use(FirstRenderHook(
    callback: callback,
  ));
}

class FirstRenderHook extends Hook<void> {
  const FirstRenderHook({
    required this.callback,
  });

  final VoidCallback callback;

  @override
  HookState<void, Hook<void>> createState() {
    return FirstRenderHookState();
  }
}

class FirstRenderHookState extends HookState<void, FirstRenderHook> {
  @override
  void initHook() {
    super.initHook();
    WidgetsBinding.instance.addPostFrameCallback((_) => hook.callback());
  }

  @override
  void build(BuildContext context) {}
}
