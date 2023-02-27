// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat/stream_chat.dart';

// Project imports:
import 'package:app/extensions/future_extensions.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../gen/app_router.dart';
import '../../services/third_party.dart';

part 'messaging_controller.freezed.dart';
part 'messaging_controller.g.dart';

@freezed
class MessagingControllerState with _$MessagingControllerState {
  const factory MessagingControllerState({
    @Default('') String streamToken,
    @Default(false) bool isBusy,
    required Channel? currentChannel,
  }) = _MessagingControllerState;

  factory MessagingControllerState.initialState() => const MessagingControllerState(currentChannel: null);
}

@Riverpod(keepAlive: true)
class MessagingController extends _$MessagingController {
  StreamSubscription<fba.User?>? userSubscription;

  final StreamController<OwnUser?> userStreamController = StreamController<OwnUser>.broadcast();

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

    await disconnectStreamUser();

    if (user == null) {
      log.i('[MessagingController] onUserChanged() user is null');
      return;
    }

    await connectStreamUser();
  }

  Future<void> onChatChannelSelected(Channel channel) async {
    final log = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    state = state.copyWith(currentChannel: channel);
    log.d('ChatController: onChatChannelSelected');

    await appRouter.push(const ChatRoute());
  }

  Future<void> connectStreamUser() async {
    final fba.FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final log = ref.read(loggerProvider);

    log.i('[MessagingController] connectStreamUser()');
    if (firebaseAuth.currentUser == null) {
      log.e('[MessagingController] connectStreamUser() user is null');
      return;
    }

    if (streamChatClient.wsConnectionStatus == ConnectionStatus.connected) {
      log.e('[MessagingController] connectStreamUser() already connected');
      return;
    }

    log.i('[MessagingController] onUserChanged() user is not null');
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('stream-getToken');
    final HttpsCallableResult? response = await callable.call().failSilently(ref);
    log.i('[MessagingController] onUserChanged() result: $response');

    if (response == null || response.data is! String || response.data.isEmpty) {
      return;
    }

    final String token = response.data;
    final User streamUserRequest = buildUser(firebaseAuth.currentUser!);
    await streamChatClient.connectUser(streamUserRequest, token);

    log.i('[MessagingController] onUserChanged() connected user: ${streamChatClient.state.currentUser}');
    state = state.copyWith(streamToken: token);
    userStreamController.sink.add(streamChatClient.state.currentUser);
  }

  Future<void> disconnectStreamUser() async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final log = ref.read(loggerProvider);

    if (streamChatClient.wsConnectionStatus != ConnectionStatus.connected) {
      log.e('[MessagingController] disconnectStreamUser() not connected');
      return;
    }

    log.i('[MessagingController] disconnectStreamUser() disconnecting user');
    await streamChatClient.disconnectUser();

    state = state.copyWith(streamToken: '');
    userStreamController.sink.add(streamChatClient.state.currentUser);
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
