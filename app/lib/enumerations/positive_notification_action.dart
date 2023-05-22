enum PositiveNotificationAction {
  none("ACTION_NONE"),
  relationshipUpdated("ACTION_RELATIONSHIP_UPDATED");

  static PositiveNotificationAction fromString(String value) {
    for (PositiveNotificationAction action in PositiveNotificationAction.values) {
      if (action.value == value) {
        return action;
      }
    }

    return PositiveNotificationAction.none;
  }

  const PositiveNotificationAction(this.value);
  final String value;
}
