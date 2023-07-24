// Dart imports:
import 'dart:math';

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
import 'package:app/dtos/database/chat/archived_member.dart';
import 'package:app/dtos/database/chat/channel_extra_data.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/gen/app_router.dart';
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
import 'package:app/widgets/organisms/chat/vms/chat_view_model.dart';
import 'package:app/widgets/organisms/home/components/stream_chat_wrapper.dart';
import '../../../dtos/system/design_typography_model.dart';

@RoutePage()
class ChatPage extends ConsumerStatefulWidget with StreamChatWrapper {
  const ChatPage({super.key});

  @override
  Widget get child => this;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  Widget buildSendButton({bool isActive = true}) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    return Container(
      width: 38.0,
      height: 38.0,
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
    bool isActive = true,
  }) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    return PositiveButton(
      colors: colors,
      primaryColor: colors.black,
      onTapped: onPressed,
      isActive: isActive,
      label: 'Add attachment',
      tooltip: 'Add an attachment',
      icon: UniconsLine.plus_circle,
      style: PositiveButtonStyle.primary,
      layout: PositiveButtonLayout.iconOnly,
      size: PositiveButtonSize.large,
    );
  }

  @override
  Widget build(BuildContext context) {
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final ChatViewModel viewModel = ref.watch(chatViewModelProvider.notifier);
    final AppRouter router = ref.read(appRouterProvider);

    final User currentStreamUser = StreamChat.of(context).currentUser!;
    final Channel channel = StreamChannel.of(context).channel;

    final List<Member> members = channel.state?.members.where((element) => element.user?.id != null).toList() ?? [];
    final List<Profile> memberProfiles = members.map((e) => cacheController.getFromCache<Profile>(e.userId!)).nonNulls.toList();

    final ChannelExtraData extraData = ChannelExtraData.fromJson(channel.extraData);
    final ArchivedMember? archivedCurrentMember = extraData.archivedMembers?.firstWhereOrNull((element) => element.memberId == currentStreamUser.id);
    final bool isArchived = archivedCurrentMember != null;

    final AppLocalizations locale = AppLocalizations.of(context)!;

    return Theme(
      data: ThemeData(
        colorScheme: const ColorScheme.light(background: Colors.red),
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colors.black,
        ),
      ),
      child: WillPopScope(
        onWillPop: viewModel.onWillPopScope,
        child: Scaffold(
          backgroundColor: colors.colorGray1,
          appBar: _AppBar(
            colors: colors,
            router: router,
            memberProfiles: memberProfiles,
            viewModel: viewModel,
            channel: channel,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: StreamMessageListView(
                  messageFilter: !isArchived ? null : (message) => message.createdAt.isBefore(archivedCurrentMember.dateArchived!),
                  emptyBuilder: (context) {
                    if (members.isEmpty) return const SizedBox();
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
                  },
                  systemMessageBuilder: (context, message) {
                    final isOwnMessage = message.user?.id == currentStreamUser.id;
                    final isLeaveMessage = message.extraData["eventType"] == GetStreamSystemMessageType.userRemoved;
                    final user = message.mentionedUsers.firstOrNull;
                    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
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
                                        message: message.copyWith(
                                          text: isOwnMessage && isLeaveMessage ? locale.page_chat_leave_group_system_message_own : message.text,
                                        ),
                                        messageTheme: StreamMessageThemeData(
                                          avatarTheme: const StreamAvatarThemeData(
                                            constraints: BoxConstraints(maxHeight: kIconLarge, maxWidth: kIconLarge),
                                          ),
                                          messageTextStyle: typography.styleNotification.copyWith(color: colors.colorGray7),
                                          messageBackgroundColor: colors.black.withOpacity(0.05),
                                          messageLinksStyle: typography.styleNotification.copyWith(color: colors.black, fontWeight: FontWeight.bold),
                                        ),
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
                  },
                  messageBuilder: (context, details, messages, defaultMessageWidget) {
                    final controller = StreamMessageInputController(message: details.message);
                    return defaultMessageWidget.copyWith(
                      userAvatarBuilder: (context, user) => buildUserAvatar(user, colors),
                      editMessageInputBuilder: (context, message) {
                        return StreamMessageInput(
                          attachmentButtonBuilder: (context, attachmentButton) => buildAttachmentButton(onPressed: attachmentButton.onPressed),
                          messageInputController: controller,
                          enableActionAnimation: false,
                          sendButtonLocation: SendButtonLocation.inside,
                          activeSendButton: buildSendButton(),
                          idleSendButton: buildSendButton(isActive: false),
                          commandButtonBuilder: (context, commandButton) => const SizedBox(),
                          onMessageSent: (_) => Navigator.of(context).pop(),
                          preMessageSending: (message) {
                            controller.text = message.text ?? "";
                            return message;
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              if (!isArchived) ...<Widget>[
                Container(
                  margin: const EdgeInsets.only(left: kPaddingSmall, right: kPaddingSmall),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: colors.white,
                    borderRadius: BorderRadius.circular(kBorderRadiusMassive),
                  ),
                  child: StreamBuilder<ChannelState>(
                    stream: StreamChannel.of(context).channelStateStream,
                    builder: (context, snapshot) {
                      if (snapshot.data?.channel?.frozen ?? false) return const SizedBox();
                      return StreamChatTheme(
                        data: StreamChatTheme.of(context).copyWith(
                          messageInputTheme: StreamChatTheme.of(context).messageInputTheme.copyWith(enableSafeArea: false),
                        ),
                        child: StreamMessageInput(
                          commandButtonBuilder: (context, commandButton) => const SizedBox.shrink(),
                          attachmentButtonBuilder: (context, attachmentButton) => buildAttachmentButton(onPressed: attachmentButton.onPressed),
                          enableActionAnimation: false,
                          sendButtonLocation: SendButtonLocation.inside,
                          activeSendButton: buildSendButton(),
                          idleSendButton: buildSendButton(isActive: false),
                        ),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: MediaQuery.of(context).padding.bottom + kPaddingSmall),
            ],
          ),
        ),
      ),
    );
  }

  PositiveProfileCircularIndicator buildUserAvatar(User user, DesignColorsModel colors) {
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final Profile? profile = cacheController.getFromCache<Profile>(user.id);
    return PositiveProfileCircularIndicator(profile: profile);
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    required this.colors,
    required this.router,
    required this.memberProfiles,
    required this.viewModel,
    required this.channel,
  });

  final DesignColorsModel colors;
  final AppRouter router;
  final List<Profile> memberProfiles;
  final ChatViewModel viewModel;
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: colors.colorGray1,
      elevation: 0,
      leadingWidth: double.infinity,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          Expanded(child: _AvatarList(members: memberProfiles)),
          const Spacer(),
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
  }) : super(key: key);

  final List<Profile> members;

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
    return Stack(
      children: [
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
                      ),
              ),
            ),
          ),
      ],
    );
  }
}
