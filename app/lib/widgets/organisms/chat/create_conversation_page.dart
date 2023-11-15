// Dart imports:

// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/chat_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/widgets/molecules/dialogs/positive_communities_dialog.dart';
import 'package:app/widgets/organisms/chat/vms/chat_view_model.dart';

@RoutePage()
class CreateConversationPage extends HookConsumerWidget {
  const CreateConversationPage({Key? key}) : super(key: key);

  // Make it so that the community dialog can display an empty state
  // SliverPadding(
  //           padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
  //           sliver: SliverToBoxAdapter(
  //             child: Column(
  //               children: [
  //                 const SizedBox(height: kPaddingMedium),
  //                 AutoSizeText(
  //                   localisations.page_chat_empty_connections_title,
  //                   maxLines: 2,
  //                   style: typography.styleHero.copyWith(color: colors.black),
  //                 ),
  //                 const SizedBox(height: kPaddingMedium),
  //                 Text(
  //                   localisations.page_chat_empty_connections_body,
  //                   style: typography.styleSubtitle.copyWith(color: colors.black),
  //                 ),
  //                 const SizedBox(height: kPaddingMedium),
  //               ],
  //             ),
  //           ),
  //         ),

  // We might eventually want to show the last message here or something
  String buildProfileDescription(Profile? profile) {
    return '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final ChatViewModelState chatViewModelState = ref.watch(chatViewModelProvider);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    useLifecycleHook(chatViewModel);

    // If we're already in a channel, we want to hide all current members from the list
    final List<String> currentChannelMembers = chatViewModelState.currentChannel?.state?.members.map((e) => e.userId).where((element) => element?.isNotEmpty == true).cast<String>().toList() ?? <String>[];

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    ref.watch(profileControllerProvider.select((value) => value.currentProfile));

    final bool isManagedProfile = profileController.isCurrentlyManagedProfile;

    // By default, we want to show the current user as a member of the channel
    int currentChannelMemberCount = 1;
    if (currentChannelMembers.isNotEmpty) {
      currentChannelMemberCount = currentChannelMembers.length;
    }

    return PositiveCommunitiesDialog(
      initialCommunityType: isManagedProfile ? CommunityType.followers : CommunityType.connected,
      mode: CommunitiesDialogMode.select,
      searchTooltip: isManagedProfile ? localizations.page_chat_label_search_followers : localizations.page_chat_label_search_connections,
      displayManagementTooltipIfAvailable: false,
      supportedCommunityTypes: <CommunityType>[
        if (isManagedProfile) ...[
          CommunityType.followers,
        ] else ...[
          CommunityType.connected,
        ],
      ],
      profileDescriptionBuilder: buildProfileDescription,
      selectedProfiles: chatViewModelState.selectedMembers.toList(),
      maximumSelectedProfiles: (kMaximumChatParticipants - currentChannelMemberCount).clamp(0, kMaximumChatParticipants),
      hiddenProfiles: currentChannelMembers,
      onProfileSelected: (String profileId) => chatViewModel.onCurrentChannelMemberSelected(profileId),
      canCallToAction: chatViewModelState.selectedMembers.isNotEmpty,
      actionLabel: localizations.page_chat_action_start_conversation,
      isEnabled: !chatViewModelState.isBusy,
      onActionPressed: () async => chatViewModel.onCurrentChannelMembersConfirmed(context),
    );
  }
}
