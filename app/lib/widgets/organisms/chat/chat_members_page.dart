// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/tiles/positive_chat_member_tile.dart';
import 'package:app/widgets/organisms/chat/vms/chat_view_model.dart';

@RoutePage()
class ChatMembersPage extends HookConsumerWidget {
  const ChatMembersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context)!;
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final ChatViewModelState chatViewModelState = ref.watch(chatViewModelProvider);

    final Channel channel = chatViewModelState.currentChannel!;
    final ProfileController profileController = ref.watch(profileControllerProvider.notifier);
    final CacheController cacheController = ref.watch(cacheControllerProvider);

    final String? currentProfileId = profileController.currentProfileId;
    final List<String> otherUserMemberIds = channel.state!.members.map((e) => e.userId).where((element) => element != currentProfileId).nonNulls.toList();
    final Map<String, Profile> otherUserProfiles = {};

    useLifecycleHook(chatViewModel);

    for (final String userId in otherUserMemberIds) {
      final Profile? profile = cacheController.get(userId);
      if (profile != null) {
        otherUserProfiles[userId] = profile;
      }
    }

    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    //! This must be applied before search
    final bool isOneOnOneConversation = otherUserProfiles.length <= 1;
    String oneOnOneDisplayName = '';

    final bool canUpdateMembers = chatViewModelState.currentChannel?.ownCapabilities.contains("update-channel-members") ?? false;
    final bool canRemoveMembers = canUpdateMembers && !isOneOnOneConversation;

    if (isOneOnOneConversation) {
      final String otherUserId = otherUserProfiles.keys.first;
      final Profile? otherUserProfile = otherUserProfiles[otherUserId];
      oneOnOneDisplayName = otherUserProfile?.displayName ?? '';
    }

    // Apply search
    if (chatViewModelState.searchQuery.isNotEmpty) {
      final String searchQuery = chatViewModelState.searchQuery.toLowerCase();
      otherUserProfiles.removeWhere((key, value) => !value.matchesStringSearch(searchQuery));
    }

    // Check blocked users
    final List<Relationship> relationships = chatViewModel.getCachedMemberRelationships();
    final List<Relationship> blockedRelationships = chatViewModel.getCachedSourceBlockedMemberRelationships(relationships);
    final bool hasSourceBlockedMembers = blockedRelationships.isNotEmpty;

    final bool shouldToggleMembers = !isOneOnOneConversation && canUpdateMembers;

    return PositiveScaffold(
      headingWidgets: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: mediaQuery.padding.top + kPaddingSmall,
            bottom: kPaddingMedium,
            left: kPaddingMedium,
            right: kPaddingMedium,
          ),
          sliver: MultiSliver(
            children: <Widget>[
              ChatMemberHeader(colors: colors, locale: locale, chatViewModel: chatViewModel, isOneOnOneConversation: isOneOnOneConversation),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    if (hasSourceBlockedMembers) ...<Widget>[
                      const SizedBox(height: kPaddingMedium),
                      PositiveHint(
                        label: locale.page_connections_list_blocked_user_notice,
                        icon: UniconsLine.ban,
                        iconColor: colors.black,
                      ),
                    ],
                    const SizedBox(height: kPaddingMedium),
                    for (final keyval in otherUserProfiles.entries) ...<Widget>[
                      PositiveChatMemberTile(
                        profile: keyval.value,
                        currentProfileId: currentProfileId ?? '',
                        relationship: ChatViewModel.getRelationshipForProfile(relationships, keyval.value),
                        onTap: shouldToggleMembers ? (_) => chatViewModel.onCurrentChannelMemberSelected(keyval.value.flMeta!.id!) : (_) => keyval.value.navigateToProfile(),
                        isSelected: chatViewModelState.selectedMembers.contains(keyval.value.flMeta!.id!),
                        displaySelectToggle: shouldToggleMembers,
                      ),
                      kPaddingSmall.asVerticalBox,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      footerWidgets: <Widget>[
        if (oneOnOneDisplayName.isNotEmpty) ...<Widget>[
          Text(
            locale.page_chat_view_members_oto_placeholder,
            textAlign: TextAlign.left,
            style: typography.styleSubtitle.copyWith(color: colors.black),
          ),
          const SizedBox(height: kPaddingSmall),
        ],
        if (canUpdateMembers) ...<Widget>[
          PositiveButton(
            colors: colors,
            primaryColor: colors.black,
            label: locale.page_chat_message_members_add_users,
            isDisabled: isOneOnOneConversation,
            onTapped: () => context.router.push(const CreateConversationRoute()),
          ),
        ],
        if (canRemoveMembers) ...<Widget>[
          PositiveButton(
            colors: colors,
            primaryColor: colors.black,
            label: locale.page_chat_message_members_remove_users,
            isDisabled: chatViewModelState.selectedMembers.isEmpty,
            onTapped: () => chatViewModel.onRemoveMembersFromChannel(context),
          ),
        ],
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          label: locale.page_chat_message_members_continue,
          onTapped: () => context.router.pop(),
        ),
      ].spaceWithVertical(kPaddingSmall),
    );
  }
}

class ChatMemberHeader extends StatelessWidget {
  const ChatMemberHeader({
    super.key,
    required this.colors,
    required this.locale,
    required this.chatViewModel,
    required this.isOneOnOneConversation,
  });

  final DesignColorsModel colors;
  final AppLocalizations locale;
  final ChatViewModel chatViewModel;
  final bool isOneOnOneConversation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        children: <Widget>[
          PositiveButton(
            colors: colors,
            onTapped: () => context.router.pop(),
            icon: UniconsLine.angle_left,
            layout: PositiveButtonLayout.iconOnly,
            size: PositiveButtonSize.medium,
            primaryColor: colors.white,
          ),
          const SizedBox(width: kPaddingMedium),
          Expanded(
            child: PositiveSearchField(
              hintText: locale.page_chat_message_members_search_hint,
              onChange: chatViewModel.setSearchQuery,
              isEnabled: !isOneOnOneConversation,
            ),
          ),
        ],
      ),
    );
  }
}
