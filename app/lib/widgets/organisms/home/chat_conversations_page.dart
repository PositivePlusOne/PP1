// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/widgets/organisms/chat/vms/chat_view_model.dart';
import 'package:app/widgets/organisms/home/components/conversation_list_tile.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/chat/channel_extra_data.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';
import 'components/empty_chat_list_placeholder.dart';
import 'components/stream_chat_wrapper.dart';

@RoutePage()
class ChatConversationsPage extends HookConsumerWidget with StreamChatWrapper {
  const ChatConversationsPage({super.key});

  @override
  Widget get child => this;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final ChatViewModelState chatViewModelState = ref.watch(chatViewModelProvider);
    final GetStreamController getStreamController = ref.watch(getStreamControllerProvider.notifier);

    useLifecycleHook(chatViewModel);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final List<Channel> channels = getStreamController.validRelationshipChannelsWithMessages.toList();

    final bottomNav = PositiveNavigationBar(
      mediaQuery: mediaQuery,
      index: NavigationBarIndex.chat,
    );

    return PositiveScaffold(
      onWillPopScope: chatViewModel.onWillPopScope,
      bottomNavigationBar: bottomNav,
      decorations: [
        if (channels.isEmpty) ...buildType3ScaffoldDecorations(colors),
      ],
      headingWidgets: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: mediaQuery.padding.top + kPaddingSmall,
            // bottom: kPaddingSmall,
            left: kPaddingMedium,
            right: kPaddingMedium,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                PositiveButton(
                  colors: colors,
                  primaryColor: colors.teal,
                  onTapped: () async {
                    context.router.push(const CreateConversationRoute());
                  },
                  label: 'Create Conversation',
                  tooltip: 'Create Conversation',
                  icon: UniconsLine.comment_edit,
                  style: PositiveButtonStyle.primary,
                  layout: PositiveButtonLayout.iconOnly,
                  size: PositiveButtonSize.medium,
                ),
                const SizedBox(width: kPaddingMedium),
                Expanded(
                  child: PositiveSearchField(
                    onSubmitted: chatViewModel.onSearchSubmitted,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (channels.isEmpty) ...<Widget>[
          SliverFillRemaining(
            child: ListView.separated(
              itemCount: channels.length,
              separatorBuilder: (context, index) => const SizedBox(height: kPaddingSmall),
              itemBuilder: (context, index) {
                return ConversationListTile(channel: channels[index]);
              },
            ),
          ),
        ] else ...<Widget>[
          const SliverToBoxAdapter(
            child: EmptyChatListPlaceholder(),
          ),
        ],
      ],
    );
  }
}
