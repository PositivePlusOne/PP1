import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelsUpdatedEvent {
  final List<Channel> channels;
  ChannelsUpdatedEvent(this.channels);
}
