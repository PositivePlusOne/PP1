// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/future_extensions.dart';
import 'package:app/providers/activities/activities_controller.dart';
import 'package:app/services/third_party.dart';

class PositiveActivityFetchBehaviour extends ConsumerStatefulWidget {
  const PositiveActivityFetchBehaviour({
    required this.activityId,
    required this.builder,
    required this.placeholderBuilder,
    required this.errorBuilder,
    this.onErrorLoadingActivity,
    super.key,
  }) : assert(activityId.length > 0, 'userId must be a non-empty string');

  final String activityId;
  final Widget Function(BuildContext context, Activity activity) builder;
  final Widget Function(BuildContext context) placeholderBuilder;

  final Widget Function(BuildContext context) errorBuilder;
  final Future<void> Function(String activityId, Object exception)? onErrorLoadingActivity;

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
    final logger = ref.read(loggerProvider);
    final ActivitiesController activitiesController = ref.read(activitiesControllerProvider.notifier);

    logger.i('PositiveActivityFetchBehaviour.onFirstFrame()');

    try {
      await runWithMutex(() async {
        activity = await activitiesController.getActivity(widget.activityId);
        logger.i('PositiveActivityFetchBehaviour.onFirstFrame() - activity: $activity');
      }, key: widget.activityId);

      hasError = activity == null;
    } catch (ex) {
      hasError = true;
      await widget.onErrorLoadingActivity?.call(widget.activityId, ex);
    }

    if (mounted) {
      setState(() {});
    }
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
