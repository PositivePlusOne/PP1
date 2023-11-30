import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import { AdminQuickActionJSON } from "../../dto/admin";
import { DataService } from "../data_service";
import { AdminQuickActionService } from "../admin_quick_action_service";

export namespace FixTimestampsAction {
    export async function fixTimestamps(action: AdminQuickActionJSON): Promise<void> {
        functions.logger.log("Fixing timestamps...");

        const firestore = admin.firestore();
        const allDataCollection = firestore.collection("fl_content");

        functions.logger.log("Getting all data...");
        AdminQuickActionService.appendOutput(action, "Getting all data...");
        const allData = await allDataCollection.get();
        const allDataDocs = allData.docs;

        functions.logger.log("Processing all data...");
        AdminQuickActionService.appendOutput(action, "Processing all data...");
        for (const doc of allDataDocs) {
            const data = doc.data();
            const needsMigration = DataService.needsMigration(data);

            if (!needsMigration) {
                continue;
            }

            functions.logger.log(`Migrating ${doc.id}...`);
            const migratedData = DataService.migrateDocument(data);
            await doc.ref.set(migratedData);
        }

        functions.logger.log("Done!");
        AdminQuickActionService.appendOutput(action, "Done!");
        AdminQuickActionService.updateStatus(action, "success");
    }
}