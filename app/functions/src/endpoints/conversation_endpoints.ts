import * as functions from "firebase-functions";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { ConversationService } from "../services/conversation_service";
import { CreateConversationRequest, FreezeChannelRequest, SendEventMessage, UnfreezeChannelRequest } from "../dto/conversations";
import { UserService } from "../services/user_service";
import safeJsonStringify from "safe-json-stringify";
import { ProfileService } from "../services/profile_service";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { SystemService } from "../services/system_service";

export namespace ConversationEndpoints {
  export const createConversation = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data: CreateConversationRequest, context) => {
      const uid = data.senderId || context.auth?.uid || "";
      await SystemService.validateUsingRedisUserThrottle(context);
      await UserService.verifyAuthenticated(context, uid);

      const streamChatClient = ConversationService.getStreamChatInstance();

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
  export const sendEventMessage = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data: SendEventMessage, context) => {
      const uid = data.senderId || context.auth?.uid || "";
      await UserService.verifyAuthenticated(context, uid);
      await SystemService.validateUsingRedisUserThrottle(context);
      const client = ConversationService.getStreamChatInstance();

      return ConversationService.sendEventMessage(data, client, uid);
    });

  /**
   * Archives members from a channel
   */
  export const archiveMembers = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (request: EndpointRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      const uid = await UserService.verifyAuthenticated(context);
      const client = ConversationService.getStreamChatInstance();

      const members = (request.data.members as string[]) || [];
      const channelId = request.data.channelId;
      if (!members || members.length === 0 || !channelId) {
        throw new functions.https.HttpsError("invalid-argument", "Invalid arguments");
      }

      const conversationRole = await ConversationService.getMemberRoleForChannel(uid, channelId);
      const isOwner = conversationRole === "owner";
      const isMember = conversationRole === "member";

      functions.logger.info(`Attempting to archive members`, { members, channelId, uid });
      if (!isOwner && !isMember) {
        throw new functions.https.HttpsError("permission-denied", "You do not have permission to remove members from this conversation");
      }

      // Check if there is only one member left in the channel, including the current user
      const channel = await ConversationService.getChannel(client, channelId);
      if (!channel) {
        throw new functions.https.HttpsError("not-found", "Channel not found");
      }

      const currentMemberKeys = Object.keys(channel?.state.members || {});
      const currentMembers = currentMemberKeys.filter((member) => member !== uid);
      if (currentMembers.length === 1) {
        throw new functions.https.HttpsError("permission-denied", "You cannot remove the last member from a conversation");
      }

      functions.logger.info(`Sending event message to ${channelId}`);
      const memberPromises = members.map(async (member) => {
        functions.logger.info(`Sending event message to ${channelId} for ${member}`);

        const profile = await ProfileService.getProfile(member);
        const message = !profile || !profile.displayName ? "A user" : `@${profile.displayName}`;

        await ConversationService.sendEventMessage(
          {
            eventType: "user_removed",
            channelId: channelId,
            text: `${message} left the conversation.`,
            mentionedUsers: [member],
            senderId: uid,
          },
          client,
          context.auth?.uid || "",
        );
      });

      await Promise.all(memberPromises);

      if (isOwner) {
        functions.logger.info(`Archiving all members ${members} from ${channelId}`);
        await ConversationService.archiveMembers(client, request.data.channelId, request.data.members);
      } else {
        functions.logger.info(`Removing members ${members} from ${channelId}`);
        await ConversationService.archiveMembers(client, request.data.channelId, [uid]);
      }

      return buildEndpointResponse(context, {
        sender: uid,
      });
    });

  /**
   * Freezes a channel
   */
  export const freezeChannel = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data: FreezeChannelRequest, context) => {
      const uid = data.senderId || context.auth?.uid || "";
      await UserService.verifyAuthenticated(context, uid);

      await SystemService.validateUsingRedisUserThrottle(context);
      const client = ConversationService.getStreamChatInstance();

      // TODO(ryan): Add some security here because Arch forgot too? :)

      return ConversationService.freezeChannel(data, client, uid);
    });

  /**
   * Unfreezes a channel
   */
  export const unfreezeChannel = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data: UnfreezeChannelRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      await UserService.verifyAuthenticated(context);
      const client = ConversationService.getStreamChatInstance();

      // TODO(ryan): Add some security here because Arch forgot too? :)

      return ConversationService.unfreezeChannel(data, client);
    });
}
