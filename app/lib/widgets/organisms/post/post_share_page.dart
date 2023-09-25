// Flutter imports:
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/content/sharing_controller.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/molecules/dialogs/positive_communities_dialog.dart';

@RoutePage()
class PostSharePage extends StatefulHookConsumerWidget {
  const PostSharePage({
    required this.activity,
    required this.origin,
    super.key,
  });

  final Activity activity;
  final String origin;

  @override
  ConsumerState<PostSharePage> createState() => _PostSharePageState();
}

class _PostSharePageState extends ConsumerState<PostSharePage> {
  final List<String> selectedCommunityIds = <String>[];
  bool isBusy = false;

  Future<void> onShareSelected(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final SharingController sharingController = ref.read(sharingControllerProvider.notifier);

    final AppRouter appRouter = ref.read(appRouterProvider);
    if (selectedCommunityIds.isEmpty) {
      logger.w('No communities selected');
      return;
    }

    setStateIfMounted(callback: () => isBusy = true);

    try {
      await sharingController.shareViaConnectionChat(context, widget.activity, widget.origin, selectedCommunityIds);
      appRouter.removeLast();

      Future<void>.delayed(kAnimationDurationDebounce, () {
        ScaffoldMessenger.of(appRouter.navigatorKey.currentContext!).showSnackBar(PositiveSnackBar(content: const Text("Post shared successfully")));
      });
    } finally {
      isBusy = false;
      setStateIfMounted();
    }
  }

  void onProfileSelected(String id) {
    final bool containsProfile = !selectedCommunityIds.contains(id);
    if (selectedCommunityIds.length >= 5 && containsProfile) {
      ScaffoldMessenger.of(context).showSnackBar(PositiveErrorSnackBar(text: 'You can only share to 5 people at a time'));
      return;
    }

    if (containsProfile) {
      selectedCommunityIds.add(id);
      setStateIfMounted();
      return;
    }

    selectedCommunityIds.remove(id);
    setStateIfMounted();
  }

  @override
  Widget build(BuildContext context) {
    return PositiveCommunitiesDialog(
      supportedCommunityTypes: const [CommunityType.connected],
      selectedCommunityType: CommunityType.connected,
      actionLabel: 'Share',
      onActionPressed: () => onShareSelected(context),
      isEnabled: !isBusy,
      canCallToAction: selectedCommunityIds.isNotEmpty,
      mode: CommunitiesDialogMode.select,
      selectedProfiles: selectedCommunityIds,
      onProfileSelected: onProfileSelected,
    );
  }
}
