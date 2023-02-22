import * as admin from "firebase-admin";

import { EventEndpoints } from "./endpoints/event_endpoints";
import { ProfileEndpoints } from "./endpoints/profile_endpoints";
import { SecurityEndpoints } from "./endpoints/security_endpoints";
import { StreamEndpoints } from "./endpoints/stream_endpoints";

export const adminApp = admin.initializeApp();

exports.events = EventEndpoints;
exports.profile = ProfileEndpoints;
exports.security = SecurityEndpoints;
exports.stream = StreamEndpoints;
