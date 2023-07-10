// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
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
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/chat/components/positive_channel_list_tile.dart';
import 'package:app/widgets/organisms/chat/vms/chat_view_model.dart';

@RoutePage()
class CreateConversationPage extends HookConsumerWidget {
  const CreateConversationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final ChatViewModelState chatViewModelState = ref.watch(chatViewModelProvider);
    final GetStreamControllerState getStreamControllerState = ref.watch(getStreamControllerProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final ProfileController profileController = ref.watch(profileControllerProvider.notifier);
    final locale = AppLocalizations.of(context)!;

    final List<Channel> validChannels = getStreamControllerState.channels.onlyOneOnOneMessages.withValidRelationships;
    final Channel? currentChannel = validChannels.firstWhereOrNull((element) => element.id == chatViewModelState.currentChannel!.id);
    final List<String> currentChannelMembers = currentChannel != null ? [currentChannel].membersIds : [];

    // Get the Channels which do not contain the current user or the current channel members
    final List<Channel> filteredChannels = validChannels.where((element) {
      final String? targetMember = [element].membersIds.firstWhereOrNull((element) => element != profileController.currentProfileId);
      if (targetMember == null) {
        return false;
      }

      return !currentChannelMembers.contains(targetMember);
    }).toList();

    useLifecycleHook(chatViewModel);

    return PositiveScaffold(
      decorations: [
        // Only show if no members
        if (filteredChannels.isEmpty) ...buildType3ScaffoldDecorations(colors),
      ],
      headingWidgets: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kPaddingMedium,
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
                    onCancel: chatViewModel.resetChatMembersSearchQuery,
                    onChange: chatViewModel.setChatMembersSearchQuery,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList.separated(
          itemCount: filteredChannels.length,
          itemBuilder: (context, index) {
            final String otherMemberId = (filteredChannels[index].state?.members ?? []).firstWhere((element) => element.userId != profileController.currentProfileId).userId!;
            return PositiveChannelListTile(
              channel: filteredChannels[index],
              onTap: () => chatViewModel.onCurrentChannelMemberSelected(otherMemberId),
              isSelected: chatViewModelState.currentChannelSelectedMembers.contains(otherMemberId),
              showProfileTagline: true,
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: kPaddingMedium),
        ),
      ],
      footerWidgets: [
        PositiveButton(
          isDisabled: chatViewModelState.currentChannelSelectedMembers.isEmpty,
          colors: colors,
          style: PositiveButtonStyle.primary,
          label: chatViewModelState.currentChannel != null ? "Add to Conversation" : locale.page_chat_action_start_conversation,
          onTapped: () => chatViewModel.onCurrentChannelMembersConfirmed(context),
          size: PositiveButtonSize.large,
          primaryColor: colors.black,
        ),
      ],
    );
  }
}
