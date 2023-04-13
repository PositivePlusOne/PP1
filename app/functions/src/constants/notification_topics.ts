export namespace NotificationTopics {
  // The notification has no specific topic, and may be displayed to all users
  export const TOPIC_NONE = "TOPIC_NONE";

  // The notification is sent to all users, and likely will be displayed to all users
  export const TOPIC_SYSTEM = "TOPIC_SYSTEM";

  // The notification is sent to all users involved in connects in their relationships
  export const TOPIC_CONNECTIONS = "TOPIC_CONNECTIONS";
}
