import * as admin from "firebase-admin";

import { SecurityEndpoints } from "./endpoints/security_endpoints";
import { UserEndpoints } from "./endpoints/user_endpoints";
import { EventEndpoints } from "./endpoints/event_endpoints";

export const adminApp = admin.initializeApp();

exports.security = SecurityEndpoints;
exports.user = UserEndpoints;
exports.events = EventEndpoints;
