// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart' as dta;
import 'package:app/extensions/future_extensions.dart';
import 'package:app/providers/activities/activities_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';
import '../../dtos/database/profile/profile.dart';

class PositiveActivityFetchBehaviour extends ConsumerStatefulWidget {
  const PositiveActivityFetchBehaviour({
    required this.activity,
    required this.builder,
    required this.placeholderBuilder,
    required this.errorBuilder,
    this.onErrorLoadingActivity,
    super.key,
  });

  final dynamic activity;
  final Widget Function(
    BuildContext context,
    dta.Activity activity, {
    Profile? publisher,
  }) builder;

  final Widget Function(BuildContext context) placeholderBuilder;
  final Widget Function(BuildContext context) errorBuilder;
  final Future<void> Function(String userId, Object exception)? onErrorLoadingActivity;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PositiveActivityFetchBehaviourState();
}

class _PositiveActivityFetchBehaviourState extends ConsumerState<PositiveActivityFetchBehaviour> {
  late Widget placeholder;
  dta.Activity? activity;
  Profile? publisher;

  bool hasError = false;

  @override
  void initState() {
    placeholder = widget.placeholderBuilder(context);
    WidgetsBinding.instance.addPostFrameCallback(onFirstFrame);
    super.initState();
  }

  Future<void> onFirstFrame(Duration timeStamp) async {
    final logger = ref.read(loggerProvider);
    final ActivitiesController activityController = ref.read(activitiesControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    logger.i('PositiveActivityFetchBehaviour.onFirstFrame()');

    try {
      final String activityId = widget.activity.object ?? '';
      activity = await runWithMutex(() => activityController.getActivity(activityId), key: activityId);

      // Split the sender from the activity (e.g event:$userId)
      final String senderId = widget.activity.actor?.id ?? '';
      publisher = await runWithMutex(() => profileController.getProfile(senderId), key: senderId, rethrowError: false);

      // On activity
      // !. Check for venue, load if needed
      // !. Check for publisher, load if needed

      if (activity == null) {
        throw Exception('Activity not found');
      }
    } catch (ex) {
      hasError = true;
      await widget.onErrorLoadingActivity?.call(widget.activity.object ?? '', ex);
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
      return widget.builder(context, activity!, publisher: publisher);
    }

    return placeholder;
  }
}
