import * as admin from "firebase-admin";

import { ProfileEndpoints } from "./endpoints/profile_endpoints";
import { SearchEndpoints } from "./endpoints/search_endpoints";
import { SecurityEndpoints } from "./endpoints/security_endpoints";
import { StreamEndpoints } from "./endpoints/stream_endpoints";
import { SystemEndpoints } from "./endpoints/system_endpoints";
import { RelationshipEndpoints } from "./endpoints/relationship_endpoints";
import { NotificationEndpoints } from "./endpoints/notification_endpoints";
import { EventEndpoints } from "./endpoints/event_endpoints";
import { DataChangeHandler } from "./handlers/data_change_handler";

export const adminApp = admin.initializeApp();

exports.handlers.data = DataChangeHandler;

exports.events = EventEndpoints;
exports.profile = ProfileEndpoints;
exports.security = SecurityEndpoints;
exports.stream = StreamEndpoints;
exports.search = SearchEndpoints;
exports.system = SystemEndpoints;
exports.relationship = RelationshipEndpoints;
exports.notifications = NotificationEndpoints;