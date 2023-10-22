import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

import { AdminEndpoints } from "./endpoints/admin_endpoints";
import { ProfileEndpoints } from "./endpoints/profile_endpoints";
import { SearchEndpoints } from "./endpoints/search_endpoints";
import { SystemEndpoints } from "./endpoints/system_endpoints";
import { RelationshipEndpoints } from "./endpoints/relationship_endpoints";
import { NotificationEndpoints } from "./endpoints/notification_endpoints";
import { GuidanceEndpoints } from "./endpoints/guidance_endpoints";
import { SearchIndexHandler } from "./handlers/search_index_handler";
import { CacheHandler } from "./handlers/cache_handler";
import { ConversationEndpoints } from "./endpoints/conversation_endpoints";
import { HealthEndpoints } from "./endpoints/health_endpoints";

import { config } from "firebase-functions/v1";
import { StorageEndpoints } from "./endpoints/storage_endpoints";
import { PostEndpoints } from "./endpoints/post_endpoints";
import { ReactionEndpoints } from "./endpoints/reaction_endpoints";
import { QuickActionHandler } from "./handlers/quick_action_handler";
import { EnrichmentEndpoints } from "./endpoints/enrichment_endpoints";

export const adminApp = admin.initializeApp();
export const applicationConfig = config().config;

functions.logger.info("Application config", { applicationConfig });

//* Register handlers for data changes
SearchIndexHandler.register();
CacheHandler.register();
QuickActionHandler.register();

//* System endpoints
exports.admin = AdminEndpoints;
exports.health = HealthEndpoints;
exports.system = SystemEndpoints;

//* Profile endpoints
exports.profile = ProfileEndpoints;
exports.storage = StorageEndpoints;
exports.relationship = RelationshipEndpoints;
exports.notifications = NotificationEndpoints;

//* Content endpoints
exports.search = SearchEndpoints;
exports.guidance = GuidanceEndpoints;
exports.conversation = ConversationEndpoints;
exports.post = PostEndpoints;
exports.reaction = ReactionEndpoints;
exports.enrichment = EnrichmentEndpoints;
