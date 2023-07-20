// Dart imports:

// Dart imports:
import 'dart:math';

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
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/stream_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
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

    final ProfileController profileController = ref.watch(profileControllerProvider.notifier);

    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final ChatViewModelState chatViewModelState = ref.watch(chatViewModelProvider);

    useLifecycleHook(chatViewModel);

    final Iterable<Channel> allChannels = ref.watch(getStreamControllerProvider.select((value) => value.conversationChannelsWithMessages));
    final Channel? currentChannel = chatViewModelState.currentChannel;
    final Iterable<String> currentChannelMembers = currentChannel != null ? [currentChannel].members.userIds : [];
    final List<Channel> displayedChannels = [];

    if (currentChannel != null) {
      displayedChannels.addAll(allChannels.onlyOneOnOneMessages.withValidRelationships.where((element) {
        final String? targetMember = [element].members.userIds.firstWhereOrNull((element) => element != profileController.currentProfileId);
        if (targetMember == null) {
          return false;
        }

        return !currentChannelMembers.contains(targetMember);
      }));
    } else {
      displayedChannels.addAll(allChannels.onlyOneOnOneMessages.withValidRelationships);
    }

    final bool hasValidChannels = displayedChannels.isNotEmpty;
    if (chatViewModelState.searchQuery.isNotEmpty) {
      final List<Channel> searchedChannels = displayedChannels.withProfileTextSearch(chatViewModelState.searchQuery).toList();
      displayedChannels.clear();
      displayedChannels.addAll(searchedChannels);
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
                    isEnabled: hasValidChannels,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!hasValidChannels) ...<Widget>[
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
        ] else if (hasValidChannels) ...<Widget>[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
            sliver: SliverList.separated(
              itemCount: displayedChannels.length,
              itemBuilder: (context, index) {
                final String otherMemberId = (displayedChannels[index].state?.members ?? []).firstWhere((element) => element.userId != profileController.currentProfileId).userId!;
                return PositiveChannelListTile(
                  channel: displayedChannels[index],
                  onTap: () => chatViewModel.onCurrentChannelMemberSelected(otherMemberId),
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
              isDisabled: !hasValidChannels || chatViewModelState.selectedMembers.isEmpty,
              colors: colors,
              style: !hasValidChannels ? PositiveButtonStyle.ghost : PositiveButtonStyle.primary,
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
