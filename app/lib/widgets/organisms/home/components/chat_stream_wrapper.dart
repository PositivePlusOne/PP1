// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/main.dart';
import '../../../../providers/user/messaging_controller.dart';
import '../../../../services/third_party.dart';

abstract class ChatStreamWrapper implements AutoRouteWrapper {
  Widget get child;

  static Widget wrapTheme(BuildContext context, Widget child) {
    final ThemeData theme = Theme.of(context);

    return StreamChatTheme(
      data: StreamChatThemeData(
        brightness: theme.brightness,
      ),
      child: child,
    );
  }

  static Widget wrap(BuildContext context, Widget child) {
    final MessagingControllerState messagingControllerState = providerContainer.read(messagingControllerProvider);
    final StreamChatClient streamChatClient = providerContainer.read(streamChatClientProvider);

    Widget returnChild = child;

    if (streamChatClient.wsConnectionStatus == ConnectionStatus.connected && messagingControllerState.currentChannel != null) {
      returnChild = StreamChannel(
        channel: messagingControllerState.currentChannel!,
        child: returnChild,
      );
    }

    returnChild = StreamChat(
      client: streamChatClient,
      child: returnChild,
    );

    return wrapTheme(context, returnChild);
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return wrap(context, child);
  }
}
