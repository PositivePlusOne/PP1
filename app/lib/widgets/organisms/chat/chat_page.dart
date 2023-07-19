// Dart imports:
import 'dart:async';
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
import 'package:app/dtos/database/common/media.dart';
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
          appBar: AppBar(
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
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: StreamMessageListView(
                  messageFilter: archivedCurrentMember == null ? null : (message) => message.createdAt.isBefore(archivedCurrentMember.dateArchived!),
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
                          attachmentButtonBuilder: (context, attachmentButton) => _AttachmentButton(colors: colors, onPressed: attachmentButton.onPressed),
                          messageInputController: controller,
                          enableActionAnimation: false,
                          sendButtonLocation: SendButtonLocation.inside,
                          activeSendButton: const _SendButton(disabled: false),
                          idleSendButton: const _SendButton(disabled: true),
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
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
                        data: StreamChatTheme.of(context).copyWith(messageInputTheme: StreamChatTheme.of(context).messageInputTheme.copyWith(enableSafeArea: false)),
                        child: StreamMessageInput(
                          attachmentButtonBuilder: (context, attachmentButton) => _AttachmentButton(colors: colors, onPressed: attachmentButton.onPressed),
                          enableActionAnimation: false,
                          sendButtonLocation: SendButtonLocation.inside,
                          activeSendButton: const _SendButton(key: Key("false"), disabled: false),
                          idleSendButton: const _SendButton(key: Key("true"), disabled: true),
                          commandButtonBuilder: (context, commandButton) => const SizedBox(),
                        ),
                      );
                    }),
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom)
            ],
          ),
        ),
      ),
    );
  }

  PositiveProfileCircularIndicator buildUserAvatar(User user, DesignColorsModel colors) {
    return PositiveProfileCircularIndicator(
      profile: Profile(
        name: user.name,
        accentColor: (user.extraData['accentColor'] as String?) ?? colors.teal.toHex(),
        media: <Media>[],
      ),
    );
  }
}

class _AttachmentButton extends StatelessWidget {
  const _AttachmentButton({
    required this.colors,
    required this.onPressed,
  });

  final DesignColorsModel colors;

  final FutureOr<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return PositiveButton(
      colors: colors,
      primaryColor: colors.black,
      onTapped: onPressed,
      label: 'Add attachment',
      tooltip: 'Add an attachment',
      icon: UniconsLine.plus_circle,
      style: PositiveButtonStyle.primary,
      layout: PositiveButtonLayout.iconOnly,
      size: PositiveButtonSize.large,
    );
  }
}

class _SendButton extends ConsumerWidget {
  const _SendButton({Key? key, required this.disabled}) : super(key: key);

  final bool disabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    const double sendButtonSize = 40.0;
    return Container(
      height: sendButtonSize,
      width: sendButtonSize,
      margin: const EdgeInsets.only(right: kPaddingExtraSmall),
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: disabled ? colors.colorGray2 : colors.black),
      child: Icon(UniconsLine.message, color: colors.white, size: PositiveButton.kButtonIconRadiusRegular),
    );
  }
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
