// Flutter imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/helpers/relationship_helpers.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/providers/user/user_controller.dart';
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
    this.onErrorLoadingProfile,
    super.key,
  }) : assert(userId.length > 0, 'userId must be a non-empty string');

  final String userId;
  final Widget Function(BuildContext context, Profile profile, Relationship? relationship) builder;
  final Widget Function(BuildContext context) placeholderBuilder;

  final Widget Function(BuildContext context) errorBuilder;
  final Future<void> Function(String userId, Object exception)? onErrorLoadingProfile;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PositiveProfileFetchBehaviourState();
}

class _PositiveProfileFetchBehaviourState extends ConsumerState<PositiveProfileFetchBehaviour> {
  late Widget placeholder;

  Profile? profile;
  Relationship? relationship;

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
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    logger.i('PositiveProfileFetchBehaviour.onFirstFrame()');

    try {
      await runWithMutex(() async {
        final profileFuture = profileController.getProfile(widget.userId);
        final relationshipFuture = relationshipController.getRelationship([widget.userId]);

        await Future.wait([profileFuture, relationshipFuture]);

        profile = await profileFuture;
        relationship = await relationshipFuture;
      }, key: widget.userId);

      hasError = profile == null;
    } catch (ex) {
      hasError = true;
      await widget.onErrorLoadingProfile?.call(widget.userId, ex);
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
      return widget.builder(context, profile!, relationship);
    }

    return placeholder;
  }
}
