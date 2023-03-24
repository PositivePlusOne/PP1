import * as admin from "firebase-admin";

import { ProfileEndpoints } from "./endpoints/profile_endpoints";
import { ProfileNotificationEndpoints } from "./endpoints/profille_notification_endpoints";
import { SearchEndpoints } from "./endpoints/search_endpoints";
import { SecurityEndpoints } from "./endpoints/security_endpoints";
import { StreamEndpoints } from "./endpoints/stream_endpoints";
import { SystemEndpoints } from "./endpoints/system_endpoints";

export const adminApp = admin.initializeApp();

// exports.events = EventEndpoints;
exports.profile = ProfileEndpoints;
exports.profileNotifications = ProfileNotificationEndpoints;
exports.security = SecurityEndpoints;
exports.stream = StreamEndpoints;
exports.search = SearchEndpoints;
exports.system = SystemEndpoints;
