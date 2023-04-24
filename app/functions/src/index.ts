import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

import { ProfileEndpoints } from "./endpoints/profile_endpoints";
import { SearchEndpoints } from "./endpoints/search_endpoints";
import { SecurityEndpoints } from "./endpoints/security_endpoints";
import { StreamEndpoints } from "./endpoints/stream_endpoints";
import { SystemEndpoints } from "./endpoints/system_endpoints";
import { RelationshipEndpoints } from "./endpoints/relationship_endpoints";
import { NotificationEndpoints } from "./endpoints/notification_endpoints";
// import { EventEndpoints } from "./endpoints/event_endpoints";
import { DataChangeHandler } from "./handlers/data_change_handler";
import { FlamelinkHelpers } from "./helpers/flamelink_helpers";
import { DataHandlerRegistry } from "./handlers/data_handler_registry";
// import { StreamEventSyncHandler } from "./handlers/events/stream_event_sync_handler";

export const adminApp = admin.initializeApp();

// exports.events = EventEndpoints;
exports.profile = ProfileEndpoints;
exports.security = SecurityEndpoints;
exports.stream = StreamEndpoints;
exports.search = SearchEndpoints;
exports.system = SystemEndpoints;
exports.relationship = RelationshipEndpoints;
exports.notifications = NotificationEndpoints;

//* Register all data handlers.
// StreamEventSyncHandler.register();

export const dataChangeHandler = functions.firestore
  .document("fl_content/{documentId}")
  .onWrite(async (change, context) => {
    functions.logger.info("Data change detected", { change, context });
    const changeType = DataChangeHandler.getChangeType(change);
    const beforeData = change.before.exists ? change.before.data() : null;
    const afterData = change.after.exists ? change.after.data() : null;

    const isRecursive = FlamelinkHelpers.arePayloadsEqual(
      beforeData,
      afterData
    );

    if (isRecursive) {
      functions.logger.info("Data change ignored (recursive)", {
        changeType,
      });

      return;
    }

    const schema = DataChangeHandler.getChangeDocumentSchema(
      changeType,
      beforeData,
      afterData
    );

    const id = context.params.documentId;
    if (schema.length === 0 || id.length === 0) {
      functions.logger.info("Data change ignored", {
        changeType,
        schema,
        id,
      });

      return;
    }

    await DataHandlerRegistry.executeChangeHandlers(
      changeType,
      schema,
      id,
      beforeData,
      afterData
    );
  });
