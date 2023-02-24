// Package imports:
import 'dart:async';

import 'package:app/providers/user/profile_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
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
  }) = _MessagingControllerState;

  factory MessagingControllerState.initialState() => const MessagingControllerState();
}

@Riverpod(keepAlive: true)
class MessagingController extends _$MessagingController {
  StreamSubscription<fba.User?>? userSubscription;

  @override
  MessagingControllerState build() {
    return MessagingControllerState.initialState();
  }

  Future<void> setupListeners() async {
    await userSubscription?.cancel();
    onUserChanged(null);

    userSubscription = ref.read(userControllerProvider.notifier).userChangedController.stream.listen(onUserChanged);
  }

  Future<void> onUserChanged(fba.User? user) async {
    final log = ref.read(loggerProvider);

    await disconnectUser();

    if (user == null) {
      log.i('[MessagingController] onUserChanged() user is null');
      return;
    }

    await connectUser(user);
  }

  Future<void> connectUser(fba.User firebaseUser) async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final log = ref.read(loggerProvider);

    log.i('[MessagingController] onUserChanged() user is not null');
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('stream-getToken');
    final HttpsCallableResult response = await callable.call();
    log.i('[MessagingController] onUserChanged() result: $response');

    if (response.data is! String || response.data.isEmpty) {
      return;
    }

    final String token = response.data;
    final User streamUser = buildUser(firebaseUser);

    await streamChatClient.connectUser(streamUser, token);
    log.i('[MessagingController] onUserChanged() connected user: ${streamChatClient.state.currentUser}');

    state = state.copyWith(streamToken: token);
  }

  Future<void> disconnectUser() async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final log = ref.read(loggerProvider);

    if (streamChatClient.wsConnectionStatus == ConnectionStatus.connected) {
      log.i('[MessagingController] disconnectUser() disconnecting user');
      await streamChatClient.disconnectUser();

      state = state.copyWith(streamToken: '');
    }
  }

  User buildUser(fba.User firebaseUser) {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);

    if (streamChatClient.state.currentUser != null) {
      return streamChatClient.state.currentUser!;
    }

    // TODO(ryan): add more fields
    return User(id: firebaseUser.uid, extraData: {
      'name': firebaseUser.displayName,
      'image': firebaseUser.photoURL,
      'email': firebaseUser.email,
    });
  }
}
