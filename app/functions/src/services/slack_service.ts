import * as functions from "firebase-functions";

import axios from "axios";

import { v1 as uuidv1 } from "uuid";
import { ProfileJSON } from "../dto/profile";
import { StringHelpers } from "../helpers/string_helpers";
import { SystemService } from "./system_service";
import { ProfileService } from "./profile_service";
import { RelationshipService } from "./relationship_service";
import { adminApp } from "..";

export namespace SlackService {
    export const chatEndpoint = "https://slack.com/api/chat.postMessage";
    export const feedbackChannel = "user-feedback";

    // This doesn't expire, and since the source is limited to those within PP1 and this code is serverside.
    // I am happy to leave this here for now because it's not a security risk.
    export const oauthToken = "xoxb-4607503833062-6056871474150-XNtWLSSSymvxUtc8qPUD6v0I";

    export const verifySigningSecret = async function(request: functions.https.Request): Promise<void> {
        const slackSigningSecret = process.env.SLACK_SIGNING_SECRET;
        if (!slackSigningSecret) {
            throw new functions.https.HttpsError("permission-denied", "Slack signing secret not set");
        }

        const headers = request.headers || {};
        functions.logger.info("Verifying Slack signing secret", { headers });

        const timestamp = headers['x-slack-request-timestamp'] as string || "";
        const signature = headers['x-slack-signature'] as string || "";

        if (!timestamp || !signature) {
            throw new functions.https.HttpsError("permission-denied", "Slack signature not set");
        }

        const hmac = StringHelpers.generateHmac(slackSigningSecret);
        const [version, hash] = signature.split('=');

        hmac.update(`${version}:${timestamp}:${request.rawBody}`);

        // Remove when done debugging
        functions.logger.info("Slack signature", { hmac, hash, signature, timestamp, slackSigningSecret });

        if (hmac.digest('hex') !== hash) {
            functions.logger.error("Slack signature does not match");
            throw new functions.https.HttpsError("permission-denied", "Slack signature does not match");
        }
    };

    export const postToChannelAsMember = async function(sender: ProfileJSON, channelId: string, message: string): Promise<void> {
        functions.logger.info("Posting message to Slack");

        const displayName = StringHelpers.asHandle(sender.displayName || 'Anonymous');
        const uid = sender._fl_meta_?.fl_id || 'unknown';

        const actualMessage = `Message from ${displayName}: (${uid})\n${message}`;

        try {
            const res = await axios.post(chatEndpoint, {
                channel: channelId,
                text: actualMessage,
            }, { headers: { authorization: `Bearer ${oauthToken}` } });
    
            functions.logger.info("Posted message to Slack", { res });
        } catch (err) {
            functions.logger.error("Failed to post message to Slack", { err });
        }
    };

    export const postRawToChannel = async function(channelId: string, message: string): Promise<void> {
        functions.logger.info("Posting message to Slack");

        try {
            const res = await axios.post(chatEndpoint, {
                channel: channelId,
                text: message,
            }, { headers: { authorization: `Bearer ${oauthToken}` } });
    
            functions.logger.info("Posted message to Slack", { res });
        } catch (err) {
            functions.logger.error("Failed to post message to Slack", { err });
        }
    };

    export const handleCreateProfileCommand = async function(commandParts: string[], slackChannel: string) {
        const name = commandParts.length > 0 ? commandParts[0] : null;
        const displayName = commandParts.length > 1 ? commandParts[1] : null;
        const isOrganisation = commandParts.length > 2 ? commandParts[2].toLowerCase() === "true" : false;
        const ownerDisplayName = commandParts.length > 3 ? commandParts[3] : null;

        const flamelinkApp = SystemService.getFlamelinkApp();
        const firestore = adminApp.firestore();

        await postRawToChannel(slackChannel, "Attempting to create new profile");
        
        if (!name || !displayName) {
            await postRawToChannel(slackChannel, "Please provide a name and display name for the new profile");
            return;
        }

        const newProfile = {
            name,
            displayName,
            featureFlags: {
            },
        } as ProfileJSON;

        const querySnapshot = await firestore.collection("fl_content").where("displayName", "==", displayName).get();
        if (querySnapshot.size > 0) {
            await postRawToChannel(slackChannel, `A profile with the display name ${displayName} already exists`);
            return;
        }

        const uuid = uuidv1();
        await flamelinkApp.content.add({
            schemaKey: "users",
            entryId: uuid,
            data: newProfile,
          });

          // Notify slack with the new user
          await postRawToChannel(slackChannel, `Created new profile with id ${uuid} - display name ${displayName}`);

          if (isOrganisation) {
            await ProfileService.updateFeatureFlags(uuid, ["organisation"]);
            await postRawToChannel(slackChannel, `Added organisation flag to ${uuid}`);
          }

          if (ownerDisplayName) {
            const ownerProfile = await ProfileService.getProfileByDisplayName(ownerDisplayName);
            if (!ownerProfile) {
                await postRawToChannel(slackChannel, `Could not find owner profile with display name ${ownerDisplayName}`);
                return;
            }

            const ownerId = ownerProfile._fl_meta_.fl_id;
            const userIds = [ownerId, uuid];
            const relationship = await RelationshipService.getRelationship(userIds);

            await RelationshipService.manageRelationship(ownerId, relationship, true);
            await postRawToChannel(slackChannel, `Added ${uuid} to ${ownerId}'s profile as a child`);
          }

          await postRawToChannel(slackChannel, `All done!`);
    };
}