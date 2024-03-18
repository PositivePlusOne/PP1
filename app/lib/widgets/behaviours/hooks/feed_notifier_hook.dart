// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';

// Project imports:
import 'package:app/widgets/state/positive_feed_state.dart';

bool useFeedNotifier({
  required PositiveFeedState feedState,
}) {
  return use(FeedNotifierHook(
    feedState: feedState,
  ));
}

class FeedNotifierHook extends Hook<bool> {
  const FeedNotifierHook({
    required this.feedState,
  });

  final PositiveFeedState feedState;

  @override
  HookState<bool, Hook<bool>> createState() {
    return FeedNotifierHookState();
  }
}

class FeedNotifierHookState extends HookState<bool, FeedNotifierHook> {
  @override
  void didUpdateHook(FeedNotifierHook oldHook) {
    final bool hasOldItems = oldHook.feedState.hasNewItems;
    final bool hasNewItems = hook.feedState.hasNewItems;

    if (hasOldItems != hasNewItems) {
      setState(() {});
    }
  }

  @override
  bool build(BuildContext context) {
    return hook.feedState.hasNewItems;
  }
}
