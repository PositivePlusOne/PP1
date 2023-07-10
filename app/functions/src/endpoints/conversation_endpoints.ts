import * as functions from "firebase-functions";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { ConversationService } from "../services/conversation_service";
import { ArchiveMembers, CreateConversationRequest, FreezeChannelRequest, SendEventMessage, UnfreezeChannelRequest } from "../dto/conversation_dtos";
import { UserService } from "../services/user_service";
import safeJsonStringify from "safe-json-stringify";

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
  export const archiveMembers = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data: ArchiveMembers, context) => {
    await UserService.verifyAuthenticated(context);
    const client = ConversationService.getStreamChatInstance();

    for (const member in data.members) {
      await ConversationService.sendEventMessage(
        {
          eventType: "user_removed",
          channelId: data.channelId,
          text: "left the conversation.",
          mentionedUsers: [member],
        },
        client,
        context.auth?.uid || ""
      );
    }

    return ConversationService.archiveMembers(client, data.channelId, data.members);
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
