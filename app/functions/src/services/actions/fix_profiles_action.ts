import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import { AdminQuickActionJSON } from "../../dto/admin";
import { DataService } from "../data_service";
import { AdminQuickActionService } from "../admin_quick_action_service";
import { FlamelinkHelpers } from "../../helpers/flamelink_helpers";

export namespace FixProfilesAction {
    export async function fixProfiles(action: AdminQuickActionJSON): Promise<void> {
        functions.logger.log("Fixing profile data...");

        const firestore = admin.firestore();
        const allDataCollection = firestore.collection("fl_content").where("_fl_meta_.schema", "==", "users");
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);

        if (!actionId) {
            functions.logger.error("No action ID specified");
            AdminQuickActionService.appendOutput(action, "No action ID specified");
            AdminQuickActionService.updateStatus(action, "error");
            return;
        }

        functions.logger.log("Getting all data...");
        AdminQuickActionService.appendOutput(action, "Getting all data...");
        const allData = await allDataCollection.get();
        const allDataDocs = allData.docs;

        functions.logger.log("Processing all data...");
        AdminQuickActionService.appendOutput(action, "Processing all data...");
        for (const doc of allDataDocs) {
            const data = doc.data();
            const flId = FlamelinkHelpers.getFlamelinkIdFromObject(data);
            if (!flId) {
                functions.logger.log(`Skipping ${doc.id}...`);
                continue;
            }

            if (flId === actionId) {
                functions.logger.log(`Skipping ${doc.id} as it is the action itself...`);
                continue;
            }

            const needsMigration = DataService.needsMigration(data);
            if (!needsMigration) {
                continue;
            }

            functions.logger.log(`Migrating ${doc.id}...`);
            const migratedData = await DataService.migrateDocument(data);
            await doc.ref.set(migratedData);
        }

        functions.logger.log("Done!");
        AdminQuickActionService.appendOutput(action, "Done!");
        AdminQuickActionService.updateStatus(action, "success");
    }
}