// Dart imports:

// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
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
import 'package:app/extensions/stream_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/chat/components/positive_channel_list_tile.dart';
import 'package:app/widgets/organisms/chat/vms/chat_view_model.dart';

@RoutePage()
class CreateConversationPage extends HookConsumerWidget {
  const CreateConversationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final AppLocalizations locale = AppLocalizations.of(context)!;

    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);
    final String currentUserProfileId = profileControllerState.currentProfile?.flMeta?.id ?? '';

    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final ChatViewModelState chatViewModelState = ref.watch(chatViewModelProvider);

    useLifecycleHook(chatViewModel);

    final CommunitiesControllerState communitiesControllerState = ref.watch(communitiesControllerProvider);

    final Set<String> connectedProfileIds = communitiesControllerState.connectedProfileIds;
    final bool hasConnectedProfiles = connectedProfileIds.isNotEmpty;

    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final List<Profile> connectedProfiles = cacheController.getManyFromCache<Profile>(connectedProfileIds.toList());

    if (chatViewModelState.searchQuery.isNotEmpty) {
      connectedProfiles.removeWhere((Profile profile) => !profile.matchesStringSearch(chatViewModelState.searchQuery));
    }

    final Channel? currentChannel = chatViewModelState.currentChannel;
    if (currentChannel != null) {
      final List<Member> members = currentChannel.state?.members.toList() ?? [];
      final List<String> memberIds = members.map((e) => e.userId ?? '').where((element) => element.isNotEmpty).toList();
      connectedProfiles.removeWhere((Profile profile) => memberIds.contains(profile.flMeta?.id));
    }

    return PositiveScaffold(
      resizeToAvoidBottomInset: false,
      decorations: buildType3ScaffoldDecorations(colors),
      headingWidgets: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kPaddingSmall,
            bottom: kPaddingMedium,
            left: kPaddingMedium,
            right: kPaddingMedium,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
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
                    hintText: locale.shared_search_people_hint,
                    onCancel: () => chatViewModel.setSearchQuery(''),
                    onChange: chatViewModel.setSearchQuery,
                    isEnabled: hasConnectedProfiles,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!hasConnectedProfiles) ...<Widget>[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: kPaddingMedium),
                  AutoSizeText(
                    'You have no connections',
                    maxLines: 2,
                    style: typography.styleHero.copyWith(color: colors.black),
                  ),
                  const SizedBox(height: kPaddingMedium),
                  Text(
                    'To start a conversation you must have a connection within Positive+1',
                    style: typography.styleSubtitle.copyWith(color: colors.black),
                  ),
                  const SizedBox(height: kPaddingMedium),
                ],
              ),
            ),
          ),
        ] else if (hasConnectedProfiles) ...<Widget>[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
            sliver: SliverList.separated(
              itemCount: connectedProfiles.length,
              itemBuilder: (context, index) {
                final Profile profile = connectedProfiles[index];
                final String otherMemberId = profile.flMeta!.id!;
                final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);
                final Channel? channel = getStreamController.getChannelForMembers([currentUserProfileId, otherMemberId]);

                return PositiveChannelListTile(
                  channel: channel,
                  onTap: (_) => chatViewModel.onCurrentChannelMemberSelected(otherMemberId),
                  isSelected: chatViewModelState.selectedMembers.contains(otherMemberId),
                  showProfileTagline: true,
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: kPaddingSmall),
            ),
          ),
        ],
      ],
      trailingWidgets: <Widget>[
        PositiveGlassSheet(
          children: [
            PositiveButton(
              isDisabled: !hasConnectedProfiles || chatViewModelState.selectedMembers.isEmpty,
              colors: colors,
              style: !hasConnectedProfiles ? PositiveButtonStyle.ghost : PositiveButtonStyle.primary,
              label: chatViewModelState.currentChannel != null ? "Add to Conversation" : locale.page_chat_action_start_conversation,
              onTapped: () => chatViewModel.onCurrentChannelMembersConfirmed(context),
              size: PositiveButtonSize.large,
              primaryColor: colors.black,
            ),
          ],
        ),
      ],
    );
  }
}
