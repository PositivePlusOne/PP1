// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/extensions/future_extensions.dart';
import 'package:app/providers/activities/activities_controller.dart';
import 'package:app/services/third_party.dart';

class PositiveActivityFetchBehaviour extends ConsumerStatefulWidget {
  const PositiveActivityFetchBehaviour({
    required this.activityId,
    required this.builder,
    required this.placeholderBuilder,
    required this.errorBuilder,
    super.key,
  }) : assert(activityId.length > 0, 'userId must be a non-empty string');

  final String activityId;
  final Widget Function(BuildContext context, Activity activity) builder;
  final Widget Function(BuildContext context) placeholderBuilder;
  final Widget Function(BuildContext context) errorBuilder;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PositiveActivityFetchBehaviourState();
}

class _PositiveActivityFetchBehaviourState extends ConsumerState<PositiveActivityFetchBehaviour> {
  late Widget placeholder;
  Activity? activity;
  bool hasError = false;

  @override
  void initState() {
    placeholder = widget.placeholderBuilder(context);
    WidgetsBinding.instance.addPostFrameCallback(onFirstFrame);
    super.initState();
  }

  Future<void> onFirstFrame(Duration timeStamp) async {
    if (!mounted) {
      return;
    }

    final logger = ref.read(loggerProvider);
    final ActivitiesController activityController = ref.read(activitiesControllerProvider.notifier);
    logger.i('PositiveActivityFetchBehaviour.onFirstFrame()');

    try {
      activity = await runWithMutex(() => activityController.getActivity(widget.activityId), key: widget.activityId);

      // On activity
      // !. Check for venue, load if needed
      // !. Check for publisher, load if needed

      hasError = activity == null;
    } catch (_) {
      hasError = true;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return widget.errorBuilder(context);
    }

    if (activity != null) {
      return widget.builder(context, activity!);
    }

    return placeholder;
  }
}
