import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

import { ProfileEndpoints } from "./endpoints/profile_endpoints";
import { SearchEndpoints } from "./endpoints/search_endpoints";
import { StreamEndpoints } from "./endpoints/stream_endpoints";
import { SystemEndpoints } from "./endpoints/system_endpoints";
import { RelationshipEndpoints } from "./endpoints/relationship_endpoints";
import { NotificationEndpoints } from "./endpoints/notification_endpoints";
import { ActivitiesEndpoints } from "./endpoints/activities_endpoints";
import { GuidanceEndpoints } from "./endpoints/guidance_endpoints";
import { SearchIndexHandler } from "./handlers/search_index_handler";
import { CacheHandler } from "./handlers/cache_handler";
import { ConversationEndpoints } from "./endpoints/conversation_endpoints";
import { HealthEndpoints } from "./endpoints/health_endpoints";

import { config } from "firebase-functions/v1";
import { StorageEndpoints } from "./endpoints/storage_endpoints";

export const adminApp = admin.initializeApp();
export const applicationConfig = config().config;

functions.logger.info("Application config", { applicationConfig });

//* Register handlers for data changes
SearchIndexHandler.register();
CacheHandler.register();

//* Register endpoints for https onCall functions
exports.health = HealthEndpoints;
exports.activities = ActivitiesEndpoints;
exports.profile = ProfileEndpoints;
exports.stream = StreamEndpoints;
exports.search = SearchEndpoints;
exports.storage = StorageEndpoints;
exports.system = SystemEndpoints;
exports.relationship = RelationshipEndpoints;
exports.notifications = NotificationEndpoints;
exports.guidance = GuidanceEndpoints;
exports.conversation = ConversationEndpoints;
