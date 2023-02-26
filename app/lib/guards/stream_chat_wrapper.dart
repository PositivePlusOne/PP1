// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/providers/user/messaging_controller.dart';
import '../services/third_party.dart';

abstract class StreamChatWrapper implements AutoRouteWrapper {
  Widget get wrapperChild;

  @override
  Widget wrappedRoute(BuildContext context) {
    final MessagingControllerState messagingControllerState = providerContainer.read(messagingControllerProvider);
    final StreamChatClient streamChatClient = providerContainer.read(streamChatClientProvider);

    if (messagingControllerState.currentChannel != null) {
      return StreamChat(
        client: streamChatClient,
        child: StreamChannel(
          channel: messagingControllerState.currentChannel!,
          child: wrapperChild,
        ),
      );
    }

    return StreamChat(
      client: streamChatClient,
      child: wrapperChild,
    );
  }
}
