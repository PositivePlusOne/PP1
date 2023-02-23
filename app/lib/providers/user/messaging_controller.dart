// Package imports:
import 'dart:convert';

import 'package:app/extensions/json_extensions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat/stream_chat.dart';

import '../../services/third_party.dart';

part 'messaging_controller.freezed.dart';
part 'messaging_controller.g.dart';

@freezed
class MessagingControllerState with _$MessagingControllerState {
  const factory MessagingControllerState({
    @Default('') String streamToken,
    StreamChatClient? streamClient,
  }) = _MessagingControllerState;

  factory MessagingControllerState.initialState() => const MessagingControllerState();
}

@Riverpod(keepAlive: true)
class MessagingController extends _$MessagingController {
  @override
  MessagingControllerState build() {
    return MessagingControllerState.initialState();
  }

  Future<void> updateStreamToken() async {
    final log = ref.read(loggerProvider);

    if (state.streamToken.isNotEmpty) {
      log.i('[MessagingController] updateStreamToken() token already exists');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('stream-getToken');
    final HttpsCallableResult response = await callable.call();
    log.i('[MessagingController] updateStreamToken() result: $response');

    if (response.data is! String || response.data.isEmpty) {
      return;
    }

    final String token = response.data;
    log.i('[MessagingController] updateStreamToken() token: $token');

    state = state.copyWith(streamToken: token);
  }
}
