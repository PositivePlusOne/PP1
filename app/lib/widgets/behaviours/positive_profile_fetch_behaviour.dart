// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/extensions/future_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';
import '../../dtos/database/profile/profile.dart';

class PositiveProfileFetchBehaviour extends ConsumerStatefulWidget {
  const PositiveProfileFetchBehaviour({
    required this.userId,
    required this.builder,
    required this.placeholderBuilder,
    required this.errorBuilder,
    super.key,
  }) : assert(userId.length > 0, 'userId must be a non-empty string');

  final String userId;
  final Widget Function(BuildContext context, Profile profile) builder;
  final Widget Function(BuildContext context) placeholderBuilder;
  final Widget Function(BuildContext context) errorBuilder;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PositiveProfileFetchBehaviourState();
}

class _PositiveProfileFetchBehaviourState extends ConsumerState<PositiveProfileFetchBehaviour> {
  late Widget placeholder;
  Profile? profile;
  bool hasError = false;

  @override
  void initState() {
    placeholder = widget.placeholderBuilder(context);
    WidgetsBinding.instance.addPostFrameCallback(onFirstFrame);
    super.initState();
  }

  Future<void> onFirstFrame(Duration timeStamp) async {
    final logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    logger.i('PositiveProfileFetchBehaviour.onFirstFrame()');

    try {
      profile = await runWithMutex(() => profileController.getProfile(widget.userId), key: widget.userId);
      hasError = profile == null;
    } catch (_) {
      hasError = true;
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

    if (profile != null) {
      return widget.builder(context, profile!);
    }

    return placeholder;
  }
}
