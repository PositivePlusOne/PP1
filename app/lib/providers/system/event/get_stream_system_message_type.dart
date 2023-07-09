enum GetStreamSystemMessageType {
  userRemoved("user_removed"),
  userAdded("user_added"),
  channelFrozen("channel_frozen"),
  channelUnfrozen("channel_unfrozen");

  final String eventType;

  const GetStreamSystemMessageType(this.eventType);

  String toJson() {
    return eventType;
  }
}
