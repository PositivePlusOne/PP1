import * as functions from "firebase-functions";

import { ProfileStatisicsJSON, profileStatisticsSchemaKey } from "../dto/profile";

import { DataService } from "./data_service";

export namespace ProfileStatisticsService {
    export const REACTION_COUNT_TARGETS = ["like", "post"];

    export function getExpectedKeyFromOptions(user_id: string): string {
        if (!user_id) {
            throw new Error(`Invalid user id: ${user_id} cannot generate expected key.`);
        }

        return `statistics:user:${user_id}`;
    }

    export async function getReactionStatisticsForProfile(userId: string): Promise<ProfileStatisicsJSON> {
        functions.logger.info("Getting profile statistics", { userId });
        const expectedKey = getExpectedKeyFromOptions(userId);
        
        return await DataService.getOrCreateDocument(expectedKey, {
            schemaKey: profileStatisticsSchemaKey,
            entryId: expectedKey,
        }) as ProfileStatisicsJSON;
    }

    export async function updateReactionCountForProfile(userId: string, kind: string, offset: number): Promise<ProfileStatisicsJSON> {
        functions.logger.info(`Updating reaction count for profile`, { userId, kind, offset });
        if (!REACTION_COUNT_TARGETS.includes(kind)) {
            functions.logger.error(`Invalid reaction kind: ${kind}`);
            return {};
        }

        const stats = await getReactionStatisticsForProfile(userId);
        stats.counts ??= {};
        stats.counts[kind] = (stats.counts[kind] ?? 0) + offset;
        functions.logger.info(`Kind: ${kind}, offset: ${offset}, new count: ${stats.counts[kind]}`);

        // This should never happen, but to be safe; lets clamp the value to 0.
        if (stats.counts[kind] < 0) {
            stats.counts[kind] = 0;
        }

        const expectedKey = getExpectedKeyFromOptions(userId);
        functions.logger.info(`Updating profile statistics`, { stats, expectedKey });

        return await DataService.updateDocument({
            schemaKey: profileStatisticsSchemaKey,
            entryId: expectedKey,
            data: stats,
        });
    }
}