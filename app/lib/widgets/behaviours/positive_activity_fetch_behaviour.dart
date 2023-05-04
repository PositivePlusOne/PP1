// Flutter imports:
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart' as dta;
import 'package:app/extensions/future_extensions.dart';
import 'package:app/providers/activities/activities_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import '../../dtos/database/profile/profile.dart';

class PositiveActivityFetchBehaviour extends ConsumerStatefulWidget {
  const PositiveActivityFetchBehaviour({
    required this.activity,
    required this.builder,
    required this.placeholderBuilder,
    required this.errorBuilder,
    super.key,
  });

  final GenericEnrichedActivity<User, String, String, String> activity;
  final Widget Function(
    BuildContext context,
    dta.Activity activity, {
    Profile? publisher,
  }) builder;

  final Widget Function(BuildContext context) placeholderBuilder;
  final Widget Function(BuildContext context) errorBuilder;

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
    if (!mounted) {
      return;
    }

    final logger = ref.read(loggerProvider);
    final ActivitiesController activityController = ref.read(activitiesControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    logger.i('PositiveActivityFetchBehaviour.onFirstFrame()');

    try {
      final String activityId = widget.activity.object ?? '';
      activity = await runWithMutex(() => activityController.getActivity(activityId), key: activityId);

      // Split the sender from the activity (e.g event:$userId)
      final String senderId = widget.activity.actor?.id ?? '';
      publisher = await runWithMutex(() => profileController.getProfile(senderId), key: senderId);

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
      return widget.builder(context, activity!, publisher: publisher);
    }

    return placeholder;
  }
}
