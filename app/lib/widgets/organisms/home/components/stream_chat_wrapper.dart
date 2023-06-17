// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/organisms/home/vms/chat_view_model.dart';
import '../../../../services/third_party.dart';

abstract class StreamChatWrapper implements AutoRouteWrapper {
  Widget get child;

  static Widget wrap(BuildContext context, Widget child) {
    final ChatViewModelState chatViewModelState = providerContainer.read(chatViewModelProvider);
    final StreamChatClient streamChatClient = providerContainer.read(streamChatClientProvider);
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));
    final locale = AppLocalizations.of(context)!;

    return StreamChat(
      client: streamChatClient,
      streamChatThemeData: StreamChatThemeData(
        colorTheme: StreamColorTheme.light(
          borders: colors.colorGray2,
          overlay: Colors.transparent,
          // appBg: colors.colorGray2,
          accentPrimary: colors.purple,
        ),
        ownMessageTheme: StreamMessageThemeData(
          messageBackgroundColor: colors.teal,
          messageTextStyle: typography.styleNotification.copyWith(color: colors.colorGray7),
          messageLinksStyle: typography.styleNotification.copyWith(color: colors.linkBlue),
        ),
        otherMessageTheme: StreamMessageThemeData(
          avatarTheme: const StreamAvatarThemeData(
            constraints: BoxConstraints(maxHeight: kIconLarge, maxWidth: kIconLarge),
          ),
          messageTextStyle: typography.styleNotification.copyWith(color: colors.colorGray7),
          messageBackgroundColor: colors.black.withOpacity(0.05),
          messageLinksStyle: typography.styleNotification.copyWith(color: colors.linkBlue),
        ),
        messageListViewTheme: StreamMessageListViewThemeData(backgroundColor: colors.colorGray1),
        messageInputTheme: StreamMessageInputThemeData(
          borderRadius: BorderRadius.circular(kBorderRadiusMassive),
          inputTextStyle: typography.styleButtonRegular.copyWith(color: colors.black),
          activeBorderGradient: LinearGradient(colors: [colors.colorGray2, colors.colorGray2]),
          idleBorderGradient: LinearGradient(colors: [colors.colorGray2, colors.colorGray2]),

          inputDecoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingSmallMedium),
            suffixIconConstraints: const BoxConstraints(maxHeight: double.infinity, maxWidth: double.infinity),
            hintText: locale.page_chat_message_hint,
            hintStyle: typography.styleButtonRegular.copyWith(color: colors.black),
          ),
          // borderRadius: BorderRadius.circular(kBorderRadiusMassive),
          elevation: 0,
          // enableSafeArea: false,
        ),
      ),
      child: chatViewModelState.currentChannel != null
          ? StreamChannel(
              channel: chatViewModelState.currentChannel!,
              child: child,
            )
          : child,
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return wrap(context, child);
  }
}
