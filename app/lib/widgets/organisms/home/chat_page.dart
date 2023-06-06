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
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/organisms/home/vms/chat_view_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';
import 'components/stream_chat_wrapper.dart';

@RoutePage()
class ChatPage extends ConsumerStatefulWidget with StreamChatWrapper {
  const ChatPage({super.key});

  @override
  Widget get child => this;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  List<Member>? _members = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getOtherMembers(context).then(
      (value) => setState(() => _members = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final ChatViewModel viewModel = ref.watch(chatViewModelProvider.notifier);
    final channel = StreamChannel.of(context).channel;
    final locale = AppLocalizations.of(context)!;

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
      child: PositiveScaffold(
        // extendBody: true,
        onWillPopScope: viewModel.onWillPopScope,
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
                  onTapped: () {
                    viewModel.removeCurrentChannel();
                    context.router.popUntilRouteWithName(ChatConversationsRoute.name);
                  },
                  icon: UniconsLine.angle_left,
                  layout: PositiveButtonLayout.iconOnly,
                  size: PositiveButtonSize.medium,
                  primaryColor: colors.white,
                ),
              ),
              const SizedBox(width: kPaddingSmall),
              Expanded(
                child: _AvatarList(members: _members),
              ),
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
        headingWidgets: [
          Column(
            children: <Widget>[
              Expanded(
                child: StreamMessageListView(
                  emptyBuilder: (context) {
                    if (_members == null || _members!.isEmpty) return const SizedBox();
                    if (_members!.length >= 2) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(kPaddingMedium),
                          child: Text(locale.page_chat_empty_group),
                        ),
                      );
                    }
                    final otherMember = _members!.firstWhereOrNull((element) => element.user?.id != null && element.user!.id != StreamChat.of(context).currentUser!.id);
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(kPaddingMedium),
                        child: Text(locale.page_chat_empty(otherMember?.user?.name ?? "")),
                      ),
                    );
                  },
                  messageBuilder: (context, details, messages, defaultMessageWidget) {
                    return defaultMessageWidget.copyWith(
                      userAvatarBuilder: (context, user) => PositiveProfileCircularIndicator(
                        profile: Profile(
                          name: user.name,
                          profileImage: user.image ?? '',
                          accentColor: (user.extraData['accentColor'] as String?) ?? colors.teal.toHex(),
                        ),
                      ),
                      editMessageInputBuilder: (_, message) {
                        final controller = StreamMessageInputController(message: message);
                        return StreamMessageInput(
                          attachmentButtonBuilder: (context, attachmentButton) => PositiveButton(
                            colors: colors,
                            primaryColor: colors.black,
                            onTapped: () async => attachmentButton.onPressed(),
                            label: 'Add attachment',
                            tooltip: 'Add an attachment',
                            icon: UniconsLine.plus_circle,
                            style: PositiveButtonStyle.primary,
                            layout: PositiveButtonLayout.iconOnly,
                            size: PositiveButtonSize.large,
                          ),
                          messageInputController: controller,
                          enableActionAnimation: false,
                          sendButtonLocation: SendButtonLocation.inside,
                          activeSendButton: const _SendButton(),
                          idleSendButton: const _SendButton(),
                          commandButtonBuilder: (context, commandButton) => const SizedBox(),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                padding: const EdgeInsets.all(kPaddingExtraSmall),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: colors.white,
                  borderRadius: BorderRadius.circular(kBorderRadiusMassive),
                ),
                child: StreamChatTheme(
                  data: StreamChatTheme.of(context).copyWith(messageInputTheme: StreamChatTheme.of(context).messageInputTheme.copyWith(enableSafeArea: false)),
                  child: StreamMessageInput(
                    attachmentButtonBuilder: (context, attachmentButton) => PositiveButton(
                      colors: colors,
                      primaryColor: colors.black,
                      onTapped: () async => attachmentButton.onPressed(),
                      label: 'Add attachment',
                      tooltip: 'Add an attachment',
                      icon: UniconsLine.plus_circle,
                      style: PositiveButtonStyle.primary,
                      layout: PositiveButtonLayout.iconOnly,
                      size: PositiveButtonSize.large,
                    ),
                    enableActionAnimation: false,
                    sendButtonLocation: SendButtonLocation.inside,
                    activeSendButton: const _SendButton(),
                    idleSendButton: const _SendButton(),
                    commandButtonBuilder: (context, commandButton) => const SizedBox(),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom)
            ],
          ),
        ],
      ),
    );
  }

  Future<List<Member>?> _getOtherMembers(BuildContext context) async {
    try {
      final streamChannel = StreamChannel.of(context);
      final currentUser = StreamChat.of(context).currentUser!;
      final members = await streamChannel.queryMembers();
      return members.where((member) => member.userId != currentUser.id).toList();
    } catch (_) {
      return null;
    }
  }
}

class _SendButton extends ConsumerWidget {
  const _SendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    const double sendButtonSize = 40;
    return Container(
      height: sendButtonSize,
      width: sendButtonSize,
      margin: const EdgeInsets.only(right: kPaddingExtraSmall),
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: colors.black),
      child: Icon(UniconsLine.message, color: colors.white, size: PositiveButton.kButtonIconRadiusRegular),
    );
  }
}

class _AvatarList extends ConsumerWidget {
  final List<Member>? members;
  const _AvatarList({Key? key, required this.members}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    const double avatarOffset = 20;
    if (members == null) {
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
    if (members?.isNotEmpty ?? false) {
      final numAvatars = min(members!.length, 3);
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
                  child: i == 2 && members!.length > 3
                      ? PositiveCircularIndicator(
                          gapColor: colors.white,
                          child: Center(
                            child: Text(
                              "+${members!.length - 2}",
                              style: typography.styleSubtextBold,
                            ),
                          ),
                        )
                      : PositiveProfileCircularIndicator(
                          profile: Profile(
                            accentColor: (members![i].user?.extraData['accentColor'] as String?) ?? colors.teal.toHex(),
                            profileImage: members![i].user?.image ?? "",
                          ),
                          size: avatarOffset,
                        ),
                ),
              ),
            ),
        ],
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: PositiveCircularIndicator(
        gapColor: colors.white,
        child: Center(
          child: Icon(
            UniconsLine.exclamation,
            color: colors.white,
            size: kIconSmall,
          ),
        ),
      ),
    );
  }
}
