import * as functions from "firebase-functions";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { ConversationService } from "../services/conversation_service";
import { CreateConversationRequest, FreezeChannelRequest, SendEventMessage, UnfreezeChannelRequest } from "../dto/conversations";
import { UserService } from "../services/user_service";
import safeJsonStringify from "safe-json-stringify";
import { ProfileService } from "../services/profile_service";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";

export namespace ConversationEndpoints {
  export const createConversation = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data: CreateConversationRequest, context) => {
    await UserService.verifyAuthenticated(context);
    const streamChatClient = ConversationService.getStreamChatInstance();
    const uid = context.auth!.uid;

    const members = data.members || [];
    if (!members.includes(uid)) {
      data.members.push(uid);
    }

    const conversationId = await ConversationService.createConversation(streamChatClient, uid, members);
    return safeJsonStringify({ conversationId });
  });
  /**
   * Sends an event message to a channel such as "_ has left the conversation"
   */
  export const sendEventMessage = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data: SendEventMessage, context) => {
    await UserService.verifyAuthenticated(context);
    const client = ConversationService.getStreamChatInstance();

    return ConversationService.sendEventMessage(data, client, context.auth?.uid || "");
  });

  /**
   * Archives members from a channel
   */
  export const archiveMembers = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context);
    const client = ConversationService.getStreamChatInstance();

    const members = (request.data.members as string[]) || [];
    const channelId = request.data.channelId;
    if (!members || members.length === 0 || !channelId) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid arguments");
    }

    functions.logger.info(`Attempting to archive members`, { members, channelId, uid });

    const conversationRole = await ConversationService.getMemberRoleForChannel(uid, channelId);
    if (conversationRole === "none") {
      throw new functions.https.HttpsError("permission-denied", "You are not a member of this conversation");
    }

    functions.logger.info(`Sending event message to ${channelId}`);
    const memberPromises = members.map(async (member) => {
      functions.logger.info(`Sending event message to ${channelId} for ${member}`);
      
      const profile = await ProfileService.getProfile(member);
      const message = !profile || !profile.displayName ? "A user" : `@${profile.displayName}`;

      const isMemberCurrentUser = member === uid;
      const hasOwnerRole = conversationRole === "owner";
      if (!isMemberCurrentUser && !hasOwnerRole) {
        throw new functions.https.HttpsError("permission-denied", "You do not have permission to remove members from this conversation");
      }

      await ConversationService.sendEventMessage(
        {
          eventType: "user_removed",
          channelId: channelId,
          text: `${message} left the conversation.`,
          mentionedUsers: [member],
        },
        client,
        context.auth?.uid || ""
      );
    });

    await Promise.all(memberPromises);

    functions.logger.info(`Archiving members ${members} from ${channelId}`);
    await ConversationService.archiveMembers(client, request.data.channelId, request.data.members);

    return buildEndpointResponse(context, {
      sender: uid,
    });
  });

  /**
   * Freezes a channel
   */
  export const freezeChannel = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data: FreezeChannelRequest, context) => {
    await UserService.verifyAuthenticated(context);
    const client = ConversationService.getStreamChatInstance();

    return ConversationService.freezeChannel(data, client, context.auth?.uid || "");
  });

  /**
   * Unfreezes a channel
   */
  export const unfreezeChannel = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data: UnfreezeChannelRequest, context) => {
    await UserService.verifyAuthenticated(context);
    const client = ConversationService.getStreamChatInstance();

    return ConversationService.unfreezeChannel(data, client);
  });
}
