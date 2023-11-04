// Dart imports:

// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/dialogs/positive_communities_dialog.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/chat/components/positive_channel_list_tile.dart';
import 'package:app/widgets/organisms/chat/vms/chat_view_model.dart';
import 'package:app/widgets/state/positive_community_feed_state.dart';

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

    useLifecycleHook(chatViewModel);

    // If we're already in a channel, we want to hide all current members from the list
    final List<String> currentChannelMembers = chatViewModelState.currentChannel?.state?.members.map((e) => e.userId).where((element) => element?.isNotEmpty == true).cast<String>().toList() ?? <String>[];

    return PositiveCommunitiesDialog(
      initialCommunityType: CommunityType.connected,
      mode: CommunitiesDialogMode.select,
      searchTooltip: 'Search Conversations',
      supportedCommunityTypes: <CommunityType>[
        CommunityType.connected,
      ],
      profileDescriptionBuilder: buildProfileDescription,
      selectedProfiles: chatViewModelState.selectedMembers.toList(),
      hiddenProfiles: currentChannelMembers,
      onProfileSelected: (String profileId) => chatViewModel.onCurrentChannelMemberSelected(profileId),
      canCallToAction: true,
      actionLabel: 'Start Chat',
      isEnabled: !chatViewModelState.isBusy,
      onActionPressed: () async => chatViewModel.onCurrentChannelMembersConfirmed(context),
    );
  }
}
