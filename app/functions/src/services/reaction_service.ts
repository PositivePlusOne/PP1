import * as functions from "firebase-functions";

import { ReactionJSON, reactionSchemaKey } from "../dto/reactions";
import { DataService } from "./data_service";
import { StreamClient, DefaultGenerics, ReactionFilterConditions } from "getstream";
import { ReactionEntryJSON } from "../dto/stream";
import { StreamHelpers } from "../helpers/stream_helpers";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { RelationshipJSON } from "../dto/relationships";
import { ActivityJSON } from "../dto/activities";
import { RelationshipService } from "./relationship_service";
import { RelationshipState } from "./types/relationship_state";
import { ReactionInduividualCommentNotification } from "./builders/notifications/activities/reaction_induividual_comment_notification";
import { ProfileService } from "./profile_service";
import { ProfileJSON, ProfileStatisicsJSON } from "../dto/profile";
import { ProfileStatisticsService } from "./profile_statistics_service";
import { ReactionStatisticsService } from "./reaction_statistics_service";
import { ReactionStatisticsJSON } from "../dto/reaction_statistics";
import { NumberHelpers } from "../helpers/number_helpers";
import { ReactionInduividualLikedNotification } from "./builders/notifications/activities/reaction_induividual_like_notification";
import { ReactionGroupedCommentNotification } from "./builders/notifications/activities/reaction_grouped_comment_notification";
import { ReactionGroupedLikedNotification } from "./builders/notifications/activities/reaction_grouped_liked_notification";
import { MentionJSON } from "../dto/mentions";
import { ReactionMentionNotification } from "./builders/notifications/activities/reaction_mention_notification";

export namespace ReactionService {

    export const VALID_FEEDS = ["user", "timeline", "notification", "tags", "aggregated", "notification_aggregated"];
    export const VALID_REACTIONS = ["like", "bookmark", "comment", "share"];
    export const UNIQUE_REACTIONS = ["like", "bookmark"];

    export function isUniqueReactionKind(kind: string) {
        return UNIQUE_REACTIONS.includes(kind);
    }

    export function getExpectedKeyFromOptions(reaction: ReactionJSON): string {
        const isUnique = isUniqueReactionKind(reaction.kind ?? "");
        if (!isUnique) {
            functions.logger.debug("Reaction is not unique, generating random key");
            return FlamelinkHelpers.generateIdentifier();
        }

        return `reaction:${reaction.kind}:${reaction.activity_id}:${reaction.reaction_id ?? ''}:${reaction.user_id}`;
    }

    export async function verifyReactionKind(kind: string, userId: string, activity: ActivityJSON, relationship: RelationshipJSON): Promise<void> {
        if (!VALID_REACTIONS.includes(kind)) {
            throw new functions.https.HttpsError("invalid-argument", "Invalid reaction kind");
        }

        const publisherId = activity?.publisherInformation?.publisherId || "";
        if (!publisherId) {
            throw new functions.https.HttpsError("not-found", "Activity publisher not found");
        }

        // Skip verification if the user is the publisher
        if (userId === publisherId) {
            return;
        }

        // Check flags on the activity 
        const relationshipStates = RelationshipService.relationshipStatesForEntity(userId, relationship);
        const viewMode = activity?.securityConfiguration?.viewMode || "public";
        const likesMode = activity?.securityConfiguration?.likesMode || "public";
        const commentMode = activity?.securityConfiguration?.commentMode || "public";
        const shareMode = activity?.securityConfiguration?.shareMode || "public";
        const bookmarksMode = activity?.securityConfiguration?.bookmarksMode || "public";

        const isFullyConnected = relationshipStates.has(RelationshipState.sourceConnected) && relationshipStates.has(RelationshipState.targetConnected);
        const isBlocked = relationshipStates.has(RelationshipState.targetBlocked);
        const isFollowing = relationshipStates.has(RelationshipState.sourceFollowed);

        // Check if we are blocked (find targetBlocked in the set of relationship states)
        if (isBlocked) {
            throw new functions.https.HttpsError("permission-denied", "You cannot react to this activity, you are blocked");
        }

        if (viewMode === "private") {
            throw new functions.https.HttpsError("permission-denied", "You cannot react to this activity, view mode is private");
        }

        // Check the different mode flags
        let currentMode = "public";
        switch (kind) {
            case "like":
                currentMode = likesMode;
                break;
            case "comment":
                currentMode = commentMode;
                break;
            case "share":
                currentMode = shareMode;
                break;
            case "bookmark":
                currentMode = bookmarksMode;
                break;
        }

        if (currentMode === "private" || currentMode === "disabled") {
            throw new functions.https.HttpsError("permission-denied", "You cannot react to this activity. The reaction mode is private or disabled");
        }

        // Check if we are following (find sourceFollowed in the set of relationship states)
        if (currentMode == "followers_and_connections" && (!isFollowing || !isFullyConnected)) {
            throw new functions.https.HttpsError("permission-denied", "You cannot react to this activity, you are not following the publisher");
        }

        // Check if we are connected (find sourceConnected in the set of relationship states)
        if (currentMode == "connections" && !isFullyConnected) {
            throw new functions.https.HttpsError("permission-denied", "You cannot react to this activity, you are not connected to the publisher");
        }
    }

    export async function processNotifications(kind: string, userId: string, activity: ActivityJSON, reaction: ReactionJSON, reactionStats: ReactionStatisticsJSON, mentions: MentionJSON[]): Promise<void> {
        functions.logger.info("Processing notifications", { kind, userId, activity });

        const publisherId = activity?.publisherInformation?.publisherId || "";
        const profiles = await ProfileService.getMultipleProfiles([userId, publisherId]);

        const userProfile = profiles.find((profile: ProfileJSON) => profile?._fl_meta_?.fl_id === userId);
        const publisherProfile = profiles.find((profile: ProfileJSON) => profile?._fl_meta_?.fl_id === publisherId);

        if (!userProfile || !publisherProfile) {
            functions.logger.error("Unable to find user or publisher profile", { userId, publisherId, userProfile, publisherProfile });
            return;
        }

        if (userProfile._fl_meta_.fl_id === publisherProfile._fl_meta_.fl_id) {
            functions.logger.info("Cannot send content notifications to yourself", { userId, publisherId, userProfile, publisherProfile });
            return;
        }

        // Use the reaction statistics and the fibbonacci sequence to determine the notification type
        // This is so we don't spam users with notifications for every like, but instead group them together
        // The math is very cursed too, check it out!

        let totalReactionCountOfKind = 0;
        if (reactionStats.counts && reactionStats.counts[kind]) {
            totalReactionCountOfKind = reactionStats.counts[kind];
        }

        const isFibbonacci = NumberHelpers.isFibbonacci(totalReactionCountOfKind);
        if (!isFibbonacci) {
            functions.logger.info("Reaction count is not a fibbonacci number, skipping notification", { userId, publisherId, userProfile, publisherProfile, totalReactionCountOfKind });
            return;
        }

        // Now we need to determine if the count is 1, so we can send a different notification
        const isOne = totalReactionCountOfKind === 1;
        if (isOne) {
            switch (kind) {
                case "comment":
                    await ReactionInduividualCommentNotification.sendNotification(userProfile, publisherProfile, activity, reaction);
                    break;
                case "like":
                    await ReactionInduividualLikedNotification.sendNotification(userProfile, publisherProfile, activity, reaction);
                    break;
                default:
                    break;
            }
        } else {
            switch (kind) {
                case "comment":
                    await ReactionGroupedCommentNotification.sendNotification(publisherProfile, activity, reaction, reactionStats);
                    break;
                case "like":
                    await ReactionGroupedLikedNotification.sendNotification(publisherProfile, activity, reaction, reactionStats);
                    break;
                default:
                    break;
            }
        }

        for (let index = 0; index < mentions.length; index++) {
            const mention = mentions[index];
            const foreignKey = mention.foreignKey;
            if (!foreignKey) {
                continue;
            }

            const mentionedProfile = await ProfileService.getProfile(foreignKey) as ProfileJSON;
            if (!mentionedProfile) {
                continue;
            }

            functions.logger.info(`Sending notification to mentioned user`, { mentionedProfile });
            await ReactionMentionNotification.sendNotification(userProfile, mentionedProfile, activity, reaction);
        }

        functions.logger.info("Finished processing notifications", { kind, userId, activity });
    }

    export function getOriginFromFeedStringAndUserId(feed: string, userId: string): string {
        if (!feed || !userId) {
            throw new Error(`Invalid feed or user ID: ${feed}, ${userId}`);
        }

        // Check the feed is valid
        if (!VALID_FEEDS.includes(feed)) {
            throw new Error(`Invalid feed: ${feed}`);
        }

        // We convert the timeline feed to a user feed as having two feeds for the same user is confusing.
        if (feed === "timeline") {
            feed = "user";
        }

        return `${feed}:${userId}`;
    }

    export async function addReaction(client: StreamClient<DefaultGenerics>, reaction: ReactionJSON): Promise<[ReactionJSON, ReactionStatisticsJSON, ProfileStatisicsJSON, ProfileStatisicsJSON]> {
        if (!reaction.activity_id || !reaction.kind || !reaction.user_id) {
            throw new functions.https.HttpsError("invalid-argument", "Invalid reaction");
        }

        const expectedKey = getExpectedKeyFromOptions(reaction);
        const expectedActivityId = reaction.activity_id;
        const expectedUserId = reaction.user_id;
        const targetUserId = reaction.target_user_id;
        const expectedKind = reaction.kind;

        const reactionEntry = {
            kind: expectedKind,
            activity_id: expectedActivityId,
            source_reaction_id: expectedKey,
            user_id: expectedUserId,
            time: StreamHelpers.getCurrentUnixTimestamp(),
        } as ReactionEntryJSON;

        const response = await client.reactions.add(reaction.kind!, reaction.activity_id!, reactionEntry, {
            userId: reaction.user_id,
        });

        reaction.entry_id = response?.id ?? "";
        if (!reaction.entry_id) {
            throw new functions.https.HttpsError("internal", "Unable to add reaction");
        }

        reaction = await DataService.updateDocument({
            schemaKey: reactionSchemaKey,
            entryId: expectedKey,
            data: {
                ...reaction,
            },
        }) as ReactionJSON;

        const expectedKindReceived = `${expectedKind}_received`;
        const expectedKindGiven = `${expectedKind}_given`;

        const [newReactionStats, newSourceProfileStats, newTargetProfileStats] = await Promise.all([
            ReactionStatisticsService.updateReactionCountForActivity(expectedActivityId, expectedKind, 1),
            ProfileStatisticsService.updateReactionCountForProfile(expectedUserId, expectedKindGiven, 1),
            ProfileStatisticsService.updateReactionCountForProfile(targetUserId || "", expectedKindReceived, 1),
        ]);

        functions.logger.info("Added reaction", { reaction });

        return [reaction, newReactionStats, newSourceProfileStats, newTargetProfileStats];
    }

    export async function getReaction(reactionId: string): Promise<ReactionJSON> {
        return DataService.getDocument({
            schemaKey: reactionSchemaKey,
            entryId: reactionId,
        }) as ReactionJSON;
    }

    export async function updateReaction(reactionId: string, text: string): Promise<ReactionJSON> {
        return DataService.updateDocument({
            schemaKey: reactionSchemaKey,
            entryId: reactionId,
            data: {
                text,
            },
        }) as ReactionJSON;
    }

    export async function deleteReaction(client: StreamClient<DefaultGenerics>, reaction: ReactionJSON): Promise<[ReactionStatisticsJSON, ProfileStatisicsJSON, ProfileStatisicsJSON]> {
        const id = FlamelinkHelpers.getFlamelinkIdFromObject(reaction);
        if (!id || !reaction.activity_id || !reaction.kind || !reaction.user_id) {
            throw new Error(`Invalid reaction: ${JSON.stringify(reaction)}`);
        }

        if (reaction.entry_id) {
            await client.reactions.delete(reaction.entry_id);
        }

        const expectedKindReceived = `${reaction.kind}_received`;
        const expectedKindGiven = `${reaction.kind}_given`;

        const [newReactionStats, newSourceProfileStats, newTargetProfileStats] = await Promise.all([
            ReactionStatisticsService.updateReactionCountForActivity(reaction.activity_id, reaction.kind, -1),
            ProfileStatisticsService.updateReactionCountForProfile(reaction.target_user_id || "", expectedKindReceived, -1),
            ProfileStatisticsService.updateReactionCountForProfile(reaction.user_id, expectedKindGiven, -1),
        ]);

        await DataService.deleteDocument({
            schemaKey: reactionSchemaKey,
            entryId: id,
        });

        functions.logger.info("Deleted reaction", { reaction });
        return [newReactionStats, newSourceProfileStats, newTargetProfileStats];
    }

    export async function listReactionsForActivity(client: StreamClient<DefaultGenerics>, kind: string, activity_id: string, limit = 25, cursor = ""): Promise<ReactionJSON[]> {
        const params: any = {
            activity_id: activity_id,
            kind: kind,
            limit: limit,
            id_lt: cursor,
        } as ReactionFilterConditions;

        const response = await client.reactions.filter(params);
        const results = response.results;
        const reactionIds = results.map((reaction: any) => reaction?.data?.source_reaction_id ?? "").filter((id: string) => id !== "");

        const reactions = await DataService.getBatchDocuments({
            schemaKey: reactionSchemaKey,
            entryIds: reactionIds,
        }) as ReactionJSON[];

        // Remove any null values
        return reactions.filter((reaction: ReactionJSON) => reaction !== null);
    }

    export function buildUniqueReactionKeysForOptions(activityId: string, userId: string): string[] {
        const expectedKeys = [] as string[];

        for (const kind of UNIQUE_REACTIONS) {
            expectedKeys.push(getExpectedKeyFromOptions({
                activity_id: activityId,
                user_id: userId,
                kind: kind,
            } as ReactionJSON));
        }

        return expectedKeys;
    }
}
