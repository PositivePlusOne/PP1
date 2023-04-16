export namespace NotificationActions {
  // When no action is required
  export const ACTION_NONE = "ACTION_NONE";
  
  // When an entity has been followed as part of a relationship
  export const ACTION_FOLLOWED = "ACTION_FOLLOWED";

  // When an entity has been unfollowed as part of a relationship
  export const ACTION_UNFOLLOWED = "ACTION_UNFOLLOWED";

  // When an entity has been blocked as part of a relationship
  export const ACTION_BLOCKED = "ACTION_BLOCKED";

  // When an entity has been unblocked as part of a relationship
  export const ACTION_UNBLOCKED = "ACTION_UNBLOCKED";

  // When an entity has been requested to be connected as part of a relationship
  export const ACTION_CONNECTION_REQUEST_RECEIVED =
    "ACTION_CONNECTION_REQUEST_RECEIVED";

  // When an entity has been requested to be connected as part of a relationship
  export const ACTION_CONNECTION_REQUEST_SENT =
    "ACTION_CONNECTION_REQUEST_SENT";

  // When an entity has been rejected a connection request as part of a relationship
  export const ACTION_CONNECTION_REQUEST_REJECTED =
    "ACTION_CONNECTION_REQUEST_REJECTED";

  // When an entity has been connected as part of a relationship
  export const ACTION_CONNECTED = "ACTION_CONNECTED";

  // When an entity has been disconnected as part of a relationship
  export const ACTION_DISCONNECTED = "ACTION_DISCONNECTED";

  // When an entity has been muted as part of a relationship
  export const ACTION_MUTED = "ACTION_MUTED";

  // When an entity has been unmuted as part of a relationship
  export const ACTION_UNMUTED = "ACTION_UNMUTED";

  // When an entity has been hidden as part of a relationship
  export const ACTION_HIDDEN = "ACTION_HIDDEN";

  // When an entity has been unhidden as part of a relationship
  export const ACTION_UNHIDDEN = "ACTION_UNHIDDEN";

  // When an entity has been reported as part of a relationship
  export const ACTION_REPORTED = "ACTION_REPORTED";
}
