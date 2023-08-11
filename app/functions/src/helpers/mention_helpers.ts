import { MentionJSON } from "../dto/mentions";
import * as functions from "firebase-functions";
import { DataService } from "../services/data_service";

export namespace MentionHelpers {
    /**
     * The list of schemas that are supported for mentions
     * Currently only supports user mentions
     */
    export const supportedMentionSchemas = ["user"];

    /**
     * Verifies that the mentions exist
     * @param {MentionJSON[]} mentions The mentions to verify
     * @throws {functions.https.HttpsError} If the mentions do not exist
     */
    export async function verifyMentionsExist(mentions: MentionJSON[]): Promise<void> {
        for (const mention of mentions) {
            const schema = mention.schema;
            const foreignKey = mention.foreignKey;
            if (!schema || !foreignKey) {
                throw new functions.https.HttpsError("invalid-argument", "Mention schema or foreign key is missing");
            }


            const record = DataService.getDocument({
                schemaKey: schema,
                entryId: foreignKey,
            });

            if (!record) {
                throw new functions.https.HttpsError("invalid-argument", "Mention schema or foreign key is missing");
            }
        }
    }

    /**
     * Verifies that the mention schemas are valid
     * @param {MentionJSON[]} mentions The mentions to verify
     * @throws {functions.https.HttpsError} If the mention schemas are invalid
     */
    export function verifyMentionSchemasValid(mentions: MentionJSON[]): void {
        for (const mention of mentions) {
            const schema = mention.schema;
            if (!schema) {
                throw new functions.https.HttpsError("invalid-argument", "Mention schema is missing");
            }

            if (!supportedMentionSchemas.includes(schema)) {
                throw new functions.https.HttpsError("invalid-argument", "Mention schema is not supported");
            }
        }
    }
}