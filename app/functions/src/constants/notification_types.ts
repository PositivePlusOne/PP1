export namespace NotificationTypes {
  // The notification is sent immediately to the user and will not be stored in the database
  export const TYPE_DEFAULT = "TYPE_DEFAULT";

  // The notification is stored in the database and will be sent when the user opens the app
  export const TYPE_STORED = "TYPE_STORED";

  // The notification is sent immediately to the user, but the user will not be notified
  export const TYPE_DATA = "TYPE_DATA";
}
