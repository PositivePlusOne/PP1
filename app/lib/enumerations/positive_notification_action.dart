enum PositiveNotificationAction {
  none("ACTION_NONE"),
  followed("ACTION_FOLLOWED"),
  unfollowed("ACTION_UNFOLLOWED"),
  blocked("ACTION_BLOCKED"),
  unblocked("ACTION_UNBLOCKED"),
  connectionRequestReceived("ACTION_CONNECTION_REQUEST_RECEIVED"),
  connectionRequestSent("ACTION_CONNECTION_REQUEST_SENT"),
  connectionRequestRejected("ACTION_CONNECTION_REQUEST_REJECTED"),
  connected("ACTION_CONNECTED"),
  disconnected("ACTION_DISCONNECTED"),
  muted("ACTION_MUTED"),
  unmuted("ACTION_UNMUTED"),
  hidden("ACTION_HIDDEN"),
  unhidden("ACTION_UNHIDDEN"),
  reported("ACTION_REPORTED");

  static PositiveNotificationAction fromString(String value) {
    for (PositiveNotificationAction action in PositiveNotificationAction.values) {
      if (action.value == value) {
        return action;
      }
    }

    return PositiveNotificationAction.none;
  }

  bool get isRelationshipChange {
    switch (this) {
      case PositiveNotificationAction.followed:
      case PositiveNotificationAction.unfollowed:
      case PositiveNotificationAction.blocked:
      case PositiveNotificationAction.unblocked:
      case PositiveNotificationAction.connected:
      case PositiveNotificationAction.disconnected:
      case PositiveNotificationAction.muted:
      case PositiveNotificationAction.unmuted:
      case PositiveNotificationAction.hidden:
      case PositiveNotificationAction.unhidden:
        return true;
      default:
        return false;
    }
  }

  const PositiveNotificationAction(this.value);
  final String value;
}
