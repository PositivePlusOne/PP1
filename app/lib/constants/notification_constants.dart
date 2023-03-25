// No action will be taken when the user taps the notification
const String kActionNavigationNone = "ACTION_NAVIGATION_NONE";

// The action will push the new screen onto the navigation stack, keeping the current screen
const String kActionNavigationPush = "ACTION_NAVIGATION_PUSH";

// The action will push the new screen onto the navigation stack, replacing the current screen
const String kActionNavigationReplace = "ACTION_NAVIGATION_REPLACE";

// The action will replace the current navigation stack with the new stack
const String kActionNavigationReplaceAll = "ACTION_NAVIGATION_REPLACE_ALL";

// The action will reload the users profile, if the user is logged in
const String kActionResyncConnections = "ACTION_RESYNC_CONNECTIONS";

// The action will pop the users current screen from the navigation stack
const String kActionNavigationPop = "ACTION_NAVIGATION_POP";

// The notification is sent immediately to the user and will not be stored in the database
const String kTypeDefault = "TYPE_DEFAULT";

// The notification is stored in the database and will be sent when the user opens the app
const String kTypeStored = "TYPE_STORED";

// The notification is sent immediately to the user, but the user will not be notified
const String kTypeData = "TYPE_DATA";

// The notification has no specific topic, and may be displayed to all users
const String kTopicNone = "TOPIC_NONE";

// The notification is sent to all users, and likely will be displayed to all users
const String kTopicSystem = "TOPIC_SYSTEM";
