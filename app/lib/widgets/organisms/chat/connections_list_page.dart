// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/home/vms/chat_view_model.dart';
import 'package:app/widgets/organisms/profile/dialogs/add_to_conversation_dialog.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/content/connections_controller.dart';
import 'package:app/providers/content/conversation_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/atoms/input/remove_focus_wrapper.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/chat/components/connections_list.dart';
import 'package:app/widgets/organisms/chat/components/empty_connections_list.dart';
import 'package:app/widgets/organisms/chat/vms/connections_list_view_model.dart';

@RoutePage()
class ConnectionsListPage extends ConsumerStatefulWidget {
  const ConnectionsListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConnectionsListPage> createState() => _ConnectionsListPageState();
}

class _ConnectionsListPageState extends ConsumerState<ConnectionsListPage> {
  @override
  void initState() {
    super.initState();
    ref.refresh(connectedUsersControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final ChatViewModelState chatViewModelState = ref.read(chatViewModelProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final locale = AppLocalizations.of(context)!;
    final double decorationBoxSize = min(MediaQuery.of(context).size.height / 2, 400);

    return RemoveFocusWrapper(
      child: PositiveScaffold(
        headingWidgets: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + kPaddingSmall,
              // bottom: kPaddingSmall,
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
                      onCancel: () => ref.read(connectedUsersControllerProvider.notifier).resetSearch(),
                      onSubmitted: (val) async => ref.read(connectedUsersControllerProvider.notifier).searchConnections(val),
                      onChange: (val) async => ref.read(connectedUsersControllerProvider.notifier).searchConnections(val),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final connectedUsers = ref.watch(connectedUsersControllerProvider).value?.filteredUsers;
              if (connectedUsers?.isNotEmpty ?? false) {
                return SliverPadding(
                  padding: const EdgeInsets.only(top: kPaddingMedium),
                  sliver: ConnectionsList(connectedUsers: connectedUsers!),
                );
              }

              return const SliverToBoxAdapter(
                child: EmptyConnectionsList(),
              );
            },
          ),
        ],
        decorationWidget: Consumer(
          builder: (context, ref, child) {
            final connectedUsers = ref.watch(connectedUsersControllerProvider);
            if (connectedUsers.value?.users.isEmpty ?? true) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: decorationBoxSize,
                  ),
                  child: Stack(
                    children: <Widget>[
                      ...buildType3ScaffoldDecorations(colors),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
        footerWidgets: [
          Consumer(
            builder: (context, ref, child) {
              final selectedUsers = ref.watch(connectionsListViewModelProvider).selectedUsers;
              return PositiveButton(
                isDisabled: selectedUsers.isEmpty,
                colors: colors,
                style: PositiveButtonStyle.primary,
                label: chatViewModelState.currentChannel != null ? "Add to Conversation" : locale.page_chat_action_start_conversation,
                onTapped: () {
                  if (chatViewModelState.currentChannel != null) {
                    PositiveDialog.show(
                      context: context,
                      dialog: const AddToConversationDialog(),
                    );
                  } else {
                    ref.read(conversationControllerProvider.notifier).createConversation(selectedUsers.map((e) => e.id).toList());
                  }
                },
                size: PositiveButtonSize.large,
                primaryColor: colors.black,
              );
            },
          ),
        ],
      ),
    );
  }
}
