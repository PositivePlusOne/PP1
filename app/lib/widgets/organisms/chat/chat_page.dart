// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/chat/archived_member.dart';
import 'package:app/dtos/database/chat/channel_extra_data.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/chat_extensions.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/profile_helpers.dart';
import 'package:app/hooks/page_refresh_hook.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/event/get_stream_system_message_type.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/tiles/positive_profile_list_tile.dart';
import 'package:app/widgets/organisms/chat/vms/chat_view_model.dart';
import 'package:app/widgets/organisms/home/components/stream_chat_wrapper.dart';
import '../../../dtos/system/design_typography_model.dart';

@RoutePage()
class ChatPage extends HookConsumerWidget with StreamChatWrapper {
  const ChatPage({super.key});

  static const double kShadeBaseHeight = 90.0;

  @override
  Widget get child => this;

  Widget buildEmptyChatList(BuildContext context, List<Member> members, List<Profile> memberProfiles, AppLocalizations locale) {
    if (members.isEmpty) {
      return const SizedBox();
    }

    if (members.length > 2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(kPaddingMedium),
          child: Text(locale.page_chat_empty_group),
        ),
      );
    }

    if (members.length == 2) {
      final Member? otherMember = members.firstWhereOrNull((element) => element.user?.id != null && element.user!.id != StreamChat.of(context).currentUser!.id);
      final Profile? otherMemberProfile = memberProfiles.firstWhereOrNull((element) => element.flMeta?.id == otherMember?.user?.id);
      final String handle = otherMemberProfile?.displayName.asHandle ?? otherMember?.user?.name ?? "";

      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(kPaddingMedium),
          child: Text(
            locale.page_chat_empty_person(handle),
          ),
        ),
      );
    }

    final otherMember = members.firstWhereOrNull((element) => element.user?.id != null && element.user!.id != StreamChat.of(context).currentUser!.id);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(kPaddingMedium),
        child: Text(locale.page_chat_empty(otherMember?.user?.name ?? "")),
      ),
    );
  }

  String buildMessageText(bool isOwnMessage, bool isLeaveMessage, String messageText, AppLocalizations locale) {
    if (isOwnMessage && isLeaveMessage) {
      return locale.page_chat_leave_group_system_message_own;
    }

    String returnMessageText = messageText;
    returnMessageText = returnMessageText.replaceAll(RegExp(r'pp1://'), 'https://');
    return returnMessageText;
  }

  Widget buildSystemMessage(BuildContext context, Message message, DesignColorsModel colors, DesignTypographyModel typography, AppLocalizations locale, User currentStreamUser) {
    final isOwnMessage = message.user?.id == currentStreamUser.id;
    final isLeaveMessage = message.extraData["eventType"] == GetStreamSystemMessageType.userRemoved;
    final user = message.mentionedUsers.firstOrNull;
    final String messageText = buildMessageText(isOwnMessage, isLeaveMessage, message.text ?? '', locale);

    return Padding(
      padding: const EdgeInsets.only(left: kPaddingSmall, right: kPaddingSmall, top: kPaddingSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(kBorderRadiusMassive),
            ),
            padding: const EdgeInsets.all(kPaddingSmall),
            child: Row(
              children: [
                if (user != null)
                  PositiveProfileCircularIndicator(
                    profile: Profile(
                      name: user.name,
                      accentColor: (user.extraData['accentColor'] as String?) ?? colors.teal.toHex(),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                    child: Align(
                      alignment: isOwnMessage ? Alignment.center : Alignment.centerLeft,
                      child: StreamMessageText(
                        onLinkTap: onLinkTap,
                        message: message.copyWith(text: messageText),
                        messageTheme: buildStreamMessageThemeData(typography, colors),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: kPaddingExtraSmall),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: kPaddingSmall),
              child: Text(
                Jiffy.parseFromDateTime(message.createdAt.toLocal()).jm,
                style: StreamChatTheme.of(context).ownMessageTheme.createdAtStyle,
              ),
            ),
          ),
          const SizedBox(height: kPaddingExtraSmall),
        ],
      ),
    );
  }

  void onLinkTap(String url) {
    Uri uri = Uri.parse(url);

    if (uri.host == 'positiveplusone.com') {
      uri = uri.replace(scheme: 'pp1');
    }

    final String fullPath = uri.toString();
    fullPath.attemptToLaunchURL();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final ChatViewModel viewModel = ref.watch(chatViewModelProvider.notifier);
    final AppRouter router = ref.read(appRouterProvider);

    final User currentStreamUser = StreamChat.of(context).currentUser!;
    final Channel channel = StreamChannel.of(context).channel;

    final List<Member> members = channel.state?.members.where((element) => element.user?.id != null).toList() ?? [];
    final List<Profile> memberProfiles = members.map((e) => cacheController.get<Profile>(e.userId!)).nonNulls.toList();

    final ChannelExtraData extraData = ChannelExtraData.fromJson(channel.extraData);
    final ArchivedMember? archivedCurrentMember = extraData.archivedMembers?.firstWhereOrNull((element) => element.memberId == currentStreamUser.id);
    final bool isArchived = archivedCurrentMember != null;

    // Get blocked members
    final List<Relationship> relationships = viewModel.getCachedMemberRelationships();
    final List<Relationship> blockedRelationships = viewModel.getCachedSourceBlockedMemberRelationships(relationships);

    final AppLocalizations locale = AppLocalizations.of(context)!;

    usePageRefreshHook();

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final ThemeData themeData = ThemeData(
      colorScheme: const ColorScheme.light(background: Colors.red),
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.black,
      ),
    );

    return Theme(
      data: themeData,
      child: WillPopScope(
        onWillPop: viewModel.onWillPopScope,
        child: PositiveScaffold(
          visibleComponents: PositiveScaffoldComponent.onlyHeadingWidgets,
          headingWidgets: <Widget>[
            SliverPinnedHeader(
              child: _AppBar(
                colors: colors,
                router: router,
                memberProfiles: memberProfiles,
                viewModel: viewModel,
                channel: channel,
                blockedMemberRelationships: blockedRelationships,
              ),
            ),
            SliverStack(
              children: <Widget>[
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom + kShadeBaseHeight),
                    child: StreamMessageListView(
                      showFloatingDateDivider: false,
                      showScrollToBottom: false,
                      messageFilter: !isArchived ? null : (message) => message.createdAt.isBefore(archivedCurrentMember.dateArchived!),
                      emptyBuilder: (context) => buildEmptyChatList(context, members, memberProfiles, locale),
                      systemMessageBuilder: (context, message) => buildSystemMessage(context, message, colors, typography, locale, currentStreamUser),
                      messageBuilder: (context, details, messages, defaultMessageWidget) => buildMessage(
                        context,
                        viewModel,
                        details,
                        messages,
                        defaultMessageWidget,
                        colors,
                        currentStreamUser.id,
                      ),
                    ),
                  ),
                ),
                if (!isArchived) ...<Widget>[
                  SliverPositioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: kShadeBaseHeight + mediaQuery.padding.bottom,
                    child: const PositiveNavigationBarShade(),
                  ),
                  SliverPositioned(
                    left: 0,
                    right: 0,
                    bottom: mediaQuery.padding.bottom + kPaddingSmall,
                    child: MessageInputContainer(colors: colors),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

StreamMessageThemeData buildStreamMessageThemeData(DesignTypographyModel typography, DesignColorsModel colors, {bool isMyMessage = false}) {
  final TextStyle chatTextStyle = TextStyle(
    fontFamily: 'AlbertSans',
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: colors.colorGray7,
  );

  return StreamMessageThemeData(
    avatarTheme: const StreamAvatarThemeData(
      constraints: BoxConstraints(maxHeight: kIconLarge, maxWidth: kIconLarge),
    ),
    messageBackgroundColor: isMyMessage ? colors.teal : colors.black.withOpacity(0.05),
    messageTextStyle: isMyMessage ? chatTextStyle.copyWith(color: colors.black) : chatTextStyle,
    messageLinksStyle: isMyMessage ? chatTextStyle.copyWith(color: colors.black) : chatTextStyle,
  );
}

StreamMessageThemeData buildStreamBottomRowThemeData(DesignTypographyModel typography, DesignColorsModel colors) {
  return StreamMessageThemeData(
    messageTextStyle: typography.styleButtonBold,
  );
}

Widget buildMessage(BuildContext context, ChatViewModel viewModel, MessageDetails details, List<Message> messages, StreamMessageWidget defaultMessageWidget, DesignColorsModel colors, String currentProfileId) {
  final bool isMyMessage = details.isMyMessage;
  final bool isOnlyEmoji = details.message.text?.isOnlyEmoji ?? false;
  final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));
  final StreamMessageThemeData themeData = buildStreamMessageThemeData(typography, colors, isMyMessage: isMyMessage);
  final StreamMessageThemeData bottomRowThemeData = buildStreamBottomRowThemeData(typography, colors);

  return StreamMessageWidget(
    messageTheme: themeData,
    onMessageTap: (message) => message.handleMessageTapped(context),
    bottomRowBuilderWithDefaultWidget: (context, message, widget) => widget.copyWith(
      messageTheme: bottomRowThemeData,
      showTimeStamp: false,
      usernameBuilder: (context, message) => isMyMessage
          ? ChatSelfUsernameRow(typography: typography, colors: colors, message: message)
          : ChatMemberUsernameRow(
              typography: typography,
              colors: colors,
              message: message,
              relationship: viewModel.getRelationshipForMessage(message),
              currentProfileId: currentProfileId,
            ),
    ),
    message: details.message,
    reverse: isMyMessage,
    padding: const EdgeInsets.all(8),
    showSendingIndicator: false,
    borderRadiusGeometry: BorderRadius.only(
      topLeft: const Radius.circular(16),
      bottomLeft: isMyMessage ? const Radius.circular(16) : const Radius.circular(2),
      topRight: const Radius.circular(16),
      bottomRight: isMyMessage ? const Radius.circular(2) : const Radius.circular(16),
    ),
    textPadding: EdgeInsets.symmetric(
      vertical: 8,
      horizontal: isOnlyEmoji ? 0 : 16.0,
    ),
    showUserAvatar: isMyMessage ? DisplayWidget.gone : DisplayWidget.show,
    userAvatarBuilder: isMyMessage
        ? null
        : (context, user) => _buildUserAvatar(
              user,
              colors,
              viewModel.getRelationshipForMessage(details.message),
            ),
  );
}

class ChatSelfUsernameRow extends StatelessWidget {
  const ChatSelfUsernameRow({
    required this.typography,
    required this.colors,
    required this.message,
    super.key,
  });

  final DesignColorsModel colors;
  final DesignTypographyModel typography;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          Jiffy.parseFromDateTime(message.createdAt.toLocal()).jm,
          style: typography.styleSubtext.copyWith(color: colors.colorGray3),
        ),
        const SizedBox(width: kPaddingExtraSmall),
      ],
    );
  }
}

class ChatMemberUsernameRow extends StatelessWidget {
  const ChatMemberUsernameRow({
    required this.typography,
    required this.colors,
    required this.message,
    required this.relationship,
    required this.currentProfileId,
    super.key,
  });

  final DesignColorsModel colors;
  final DesignTypographyModel typography;
  final Message message;

  final Relationship? relationship;
  final String currentProfileId;

  @override
  Widget build(BuildContext context) {
    bool hasSourceBlocked = false;
    if (relationship != null && currentProfileId.isNotEmpty) {
      final Set<RelationshipState> states = relationship!.relationshipStatesForEntity(currentProfileId);
      hasSourceBlocked = states.contains(RelationshipState.sourceBlocked);
    }

    return Row(
      children: <Widget>[
        if (hasSourceBlocked)
          Padding(
            padding: const EdgeInsets.only(right: kPaddingExtraSmall),
            child: Icon(
              UniconsLine.ban,
              size: kIconExtraSmall,
              color: colors.colorGray3,
            ),
          ),
        Expanded(
          child: Text(
            message.user?.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: typography.styleSubtext.copyWith(color: colors.colorGray3),
          ),
        ),
        const SizedBox(width: kPaddingExtraSmall),
        Text(
          Jiffy.parseFromDateTime(message.createdAt.toLocal()).jm,
          style: typography.styleSubtext.copyWith(color: colors.colorGray3),
        ),
        const SizedBox(width: kPaddingExtraSmall),
      ],
    );
  }
}

PositiveProfileCircularIndicator _buildUserAvatar(User user, DesignColorsModel colors, Relationship? relationship) {
  final CacheController cacheController = providerContainer.read(cacheControllerProvider);
  final Profile? profile = cacheController.get<Profile>(user.id);
  // we have the ID of the user we are showing the icon for (has this target user been blocked)
  bool isTargetBlocked = false;
  if (relationship != null && user.id.isNotEmpty) {
    final Set<RelationshipState> states = relationship.relationshipStatesForEntity(user.id);
    isTargetBlocked = states.contains(RelationshipState.targetBlocked);
  }
  // returning the icon (with a black border if they have been blocked)
  return PositiveProfileCircularIndicator(
    profile: profile,
    ringColorOverride: isTargetBlocked ? Colors.black : null,
  );
}

class MessageInputContainer extends StatelessWidget {
  const MessageInputContainer({
    super.key,
    required this.colors,
  });

  final DesignColorsModel colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: kPaddingSmall, right: kPaddingSmall),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(kBorderRadiusMassive),
        border: Border.all(
          color: colors.colorGray1,
          width: kBorderThicknessSmall,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(
        kPaddingSmallMedium - 9 - kBorderThicknessSmall,
      ), //? Subtract the hard coded 8 padding as found in streamchats message input (round to 9 for sub pixel clipping)
      child: const MessageInput(),
    );
  }
}

Widget buildSendButton({bool isActive = true}) {
  final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
  return Container(
    width: kPaddingExtraLarge,
    height: kPaddingExtraLarge,
    margin: const EdgeInsets.only(right: 5.0),
    child: IgnorePointer(
      ignoring: true,
      child: PositiveButton(
        colors: colors,
        onTapped: () {},
        isActive: false,
        size: PositiveButtonSize.medium,
        style: PositiveButtonStyle.primary,
        layout: PositiveButtonLayout.iconOnly,
        icon: UniconsLine.message,
      ),
    ),
  );
}

Widget buildAttachmentButton({
  required VoidCallback onPressed,
  required BuildContext context,
  bool isActive = true,
}) {
  final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
  final AppLocalizations localisations = AppLocalizations.of(context)!;

  return Align(
    alignment: Alignment.centerLeft,
    child: PositiveButton(
      colors: colors,
      primaryColor: colors.black,
      onTapped: onPressed,
      isActive: isActive,
      label: localisations.page_chat_add_attachment,
      tooltip: localisations.page_chat_add_attachment,
      icon: UniconsLine.plus_circle,
      style: PositiveButtonStyle.primary,
      layout: PositiveButtonLayout.iconOnly,
      borderWidth: kBorderThicknessNone,
      size: PositiveButtonSize.large,
    ),
  );
}

class MessageInput extends ConsumerWidget {
  const MessageInput({
    super.key,
  });

  Widget buildUserMentionsTile(
    BuildContext context,
    User user,
    CacheController cacheController,
    DesignTypographyModel typography,
    DesignColorsModel colors,
  ) {
    // we want to display the details about the actual target user rather than just letting the class
    // show user IDs. So we need to get the profile data instead of the user ID
    final Profile? targetProfile = cacheController.get(user.id);
    // then return the nice display of this user
    return Container(
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(PositiveProfileListTile.kProfileTileBorderRadius),
      ),
      padding: const EdgeInsets.all(kPaddingSmall),
      child: Row(
        children: <Widget>[
          PositiveProfileCircularIndicator(profile: targetProfile, size: kIconHuge),
          const SizedBox(width: kPaddingSmall),
          Expanded(
            child: Text(
              getSafeDisplayNameFromProfile(targetProfile),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: typography.styleTitle.copyWith(color: colors.colorGray7),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));
    return StreamBuilder<ChannelState>(
      stream: StreamChannel.of(context).channelStateStream,
      builder: (context, snapshot) {
        if (snapshot.data?.channel?.frozen ?? false) return const SizedBox();
        return StreamChatTheme(
          data: StreamChatTheme.of(context).copyWith(
            messageInputTheme: StreamChatTheme.of(context).messageInputTheme.copyWith(
                  enableSafeArea: false,
                  inputBackgroundColor: Colors.white,
                ),
          ),
          child: StreamMessageInput(
            commandButtonBuilder: (context, commandButton) => const SizedBox.shrink(),
            attachmentButtonBuilder: (context, attachmentButton) => buildAttachmentButton(onPressed: attachmentButton.onPressed, context: context),
            enableActionAnimation: false,
            sendButtonLocation: SendButtonLocation.inside,
            activeSendButton: buildSendButton(),
            idleSendButton: buildSendButton(isActive: false),
            userMentionsTileBuilder: (ctx, user) => buildUserMentionsTile(ctx, user, cacheController, typography, colors),
          ),
        );
      },
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    required this.colors,
    required this.router,
    required this.memberProfiles,
    required this.viewModel,
    required this.channel,
    this.blockedMemberRelationships = const [],
  });

  final DesignColorsModel colors;
  final AppRouter router;
  final List<Profile> memberProfiles;
  final ChatViewModel viewModel;
  final Channel channel;

  final List<Relationship> blockedMemberRelationships;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: colors.colorGray1,
      elevation: 0,
      leadingWidth: double.infinity,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: kPaddingMedium),
            child: PositiveButton(
              colors: colors,
              onTapped: router.pop,
              icon: UniconsLine.angle_left,
              layout: PositiveButtonLayout.iconOnly,
              size: PositiveButtonSize.medium,
              primaryColor: colors.white,
            ),
          ),
          const SizedBox(width: kPaddingSmall),
          Expanded(
            flex: 3,
            child: _AvatarList(
              members: memberProfiles,
              blockedMemberRelationships: blockedMemberRelationships,
            ),
          ),
          const SizedBox(width: kPaddingSmall),
          if (blockedMemberRelationships.isNotEmpty) ...<Widget>[
            Expanded(
              flex: 3,
              child: PositiveHint(
                label: '${blockedMemberRelationships.length} blocked',
                icon: UniconsLine.ban,
                iconColor: colors.black,
              ),
            ),
            const SizedBox(width: kPaddingSmall),
          ],
          const Expanded(child: SizedBox.shrink()),
          PositiveButton(
            colors: colors,
            primaryColor: colors.teal,
            onTapped: () => viewModel.onChatModalRequested(context, '', channel),
            icon: UniconsLine.ellipsis_h,
            size: PositiveButtonSize.medium,
            layout: PositiveButtonLayout.iconOnly,
          ),
          const SizedBox(width: kPaddingMedium),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AvatarList extends ConsumerWidget {
  const _AvatarList({
    Key? key,
    required this.members,
    this.blockedMemberRelationships = const [],
  }) : super(key: key);

  final List<Profile> members;
  final List<Relationship> blockedMemberRelationships;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final ProfileController profileController = ref.watch(profileControllerProvider.notifier);

    const double avatarOffset = 20;

    final String? currentProfileId = profileController.currentProfileId;
    final List<Profile> filteredMembers = members.where((member) => member.flMeta?.id != currentProfileId).toList();

    if (filteredMembers.isEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: PositiveCircularIndicator(
          gapColor: colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: PositiveLoadingIndicator(
                color: colors.white,
              ),
            ),
          ),
        ),
      );
    }

    final numAvatars = min(filteredMembers.length, 3);
    const double targetWidth = 40 * 3 - (avatarOffset * 2);

    return SizedBox(
      width: targetWidth,
      child: Stack(
        children: <Widget>[
          for (var i = 0; i < numAvatars; i++)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: kPaddingMedium * i),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: i == 2 && filteredMembers.length > 3
                      ? PositiveCircularIndicator(
                          gapColor: colors.white,
                          child: Center(
                            child: Text(
                              "+${filteredMembers.length - 2}",
                              style: typography.styleSubtextBold,
                            ),
                          ),
                        )
                      : PositiveProfileCircularIndicator(
                          profile: filteredMembers[i],
                          size: avatarOffset,
                          // if the profile has a relationship in the list of blocked relationships (are blocked)
                          // so show a black ring around their profile image
                          ringColorOverride: ChatViewModel.getRelationshipForProfile(blockedMemberRelationships, filteredMembers[i]) != null ? Colors.black : null,
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
