import * as functions from "firebase-functions";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { ConversationService } from "../services/conversation_service";
import { CreateConversationRequest, SendEventMessage } from "../dto/conversation_dtos";
import { UserService } from "../services/user_service";

export namespace ConversationEndpoints {
  export const createConversation = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data: CreateConversationRequest, context) => {
    await UserService.verifyAuthenticated(context);
    const streamChatClient = ConversationService.getStreamChatInstance();
    data.members.push(context.auth?.uid || "");

    const uid = context.auth?.uid || "";
    return ConversationService.createConversation(streamChatClient, uid, data.members);
  });
  /**
   * Sends an event message to a channel such as "_ has left the conversation"
   */
  export const sendEventMessage = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data: SendEventMessage, context) => {
    await UserService.verifyAuthenticated(context);
    const client = ConversationService.getStreamChatInstance();

    return ConversationService.sendEventMessage(data, client, context.auth?.uid || "");
  });
}
