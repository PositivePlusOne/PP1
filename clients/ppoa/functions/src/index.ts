import * as admin from "firebase-admin";

import { SecurityEndpoints } from "./endpoints/security_endpoints";
import { UserEndpoints } from "./endpoints/user_endpoints";

admin.initializeApp();

exports.security = SecurityEndpoints;
exports.user = UserEndpoints;