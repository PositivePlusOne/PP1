// Flutter imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/widgets/organisms/home/vms/chat_view_model.dart';
import '../../../../services/third_party.dart';

abstract class StreamChatWrapper implements AutoRouteWrapper {
  Widget get child;

  static Widget wrapTheme(BuildContext context, Widget child) {
    final ThemeData theme = Theme.of(context);

    // final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    return StreamChatTheme(
      data: StreamChatThemeData.fromTheme(theme),
      child: child,
    );
  }

  static Widget wrap(BuildContext context, Widget child) {
    final ChatViewModelState chatViewModelState = providerContainer.read(chatViewModelProvider);
    final StreamChatClient streamChatClient = providerContainer.read(streamChatClientProvider);

    Widget returnChild = child;

    if (chatViewModelState.currentChannel != null) {
      returnChild = StreamChannel(
        channel: chatViewModelState.currentChannel!,
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
