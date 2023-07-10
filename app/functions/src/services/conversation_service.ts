import * as functions from "firebase-functions";
import { v4 as uuidv4 } from "uuid";

import { DefaultGenerics, StreamChat } from "stream-chat";
import { FreezeChannelRequest, SendEventMessage, UnfreezeChannelRequest } from "../dto/conversation_dtos";
import { HttpsError } from "firebase-functions/v1/auth";
import { StringHelpers } from "../helpers/string_helpers";

export namespace ConversationService {
  /**
   * Returns a StreamChat instance with the API key and secret.
   * @return {StreamChat<DefaultGenerics>} instance of StreamChat
   */
  export function getStreamChatInstance(): StreamChat<DefaultGenerics> {
    functions.logger.info("Getting Stream instance", { structuredData: true });

    const apiKey = process.env.STREAM_API_KEY;
    const apiSecret = process.env.STREAM_API_SECRET;

    if (!apiKey || !apiSecret) {
      throw new Error("Missing Stream API key or secret");
    }

    const streamInstance = StreamChat.getInstance(apiKey, apiSecret);
    streamInstance.updateAppSettings({
      enforce_unique_usernames: "no",
    });

    return streamInstance;
  }

  /**
   * Creates a user token for GetStream.
   * @param {StreamChat<DefaultGenerics>} client the StreamChat client.
   * @param {string} userId the user's ID.
   * @return {string} the user's token.
   * @see https://getstream.io/chat/docs/node/tokens_and_authentication/?language=javascript
   */
  export function getUserToken(client: StreamChat<DefaultGenerics>, userId: string): string {
    functions.logger.info("Creating user token", { userId });
    const token = client.createToken(userId);

    functions.logger.info("User token", { token });
    return token;
  }

  /**
   * Revokes a user's token from GetStream.
   * @param {StreamChat<DefaultGenerics>} client the StreamChat client.
   * @param {string} userId the user's ID.
   * @return {Promise<void>} a promise that resolves when the token has been revoked.
   */
  export async function revokeUserToken(client: StreamChat<DefaultGenerics>, userId: string): Promise<void> {
    functions.logger.info("Revoking user token", { userId });
    await client.revokeUserToken(userId);
    functions.logger.info("User token revoked", { userId });
  }

  /**
   * Sends an event message to a channel such as "_ has left the conversation"
   */
  export async function sendEventMessage(data: SendEventMessage, client: StreamChat<DefaultGenerics>, userId: string) {
    const res = await client.queryChannels({
      id: {
        $eq: data.channelId,
      },
    });

    if (res.length == 0) {
      functions.logger.error("No channel found");
      throw new Error("Members cannot be empty or contain empty strings");
    }

    const channel = res[0];
    await channel.sendMessage(
      {
        user_id: userId,
        mentioned_users: data.mentionedUsers,
        text: data.text,
        eventType: data.eventType,
        type: "system",
        silent: true,
      },
      {
        skip_push: true,
      }
    );
  }

  /**
   * Unfreezes a channel
   */
  export async function unfreezeChannel(data: UnfreezeChannelRequest, client: StreamChat<DefaultGenerics>) {
    const res = await client.queryChannels({
      id: {
        $eq: data.channelId,
      },
    });

    if (res.length == 0) {
      functions.logger.error("No channel found");
      throw new Error("Members cannot be empty or contain empty strings");
    }

    const channel = res[0];
    await channel.update({ frozen: false });
  }

  /**
   * Freezes a channel
   */
  export async function freezeChannel(data: FreezeChannelRequest, client: StreamChat<DefaultGenerics>, userId: string) {
    const res = await client.queryChannels({
      id: {
        $eq: data.channelId,
      },
    });

    if (res.length == 0) {
      functions.logger.error("No channel found");
      throw new Error("Members cannot be empty or contain empty strings");
    }

    const channel = res[0];
    await channel.update({ frozen: true });
    await channel.sendMessage(
      {
        user_id: userId,
        text: data.text,
        type: "system",
        silent: true,
        mentioned_users: [data.userId],
      },
      {
        skip_push: true,
      }
    );
  }

  /**
   * Creates a conversation between the given members.
   * @param {StreamChat<DefaultGenerics>} client the StreamChat client.
   * @param {string} sender the sender of the conversation.
   * @param {string[]} members the members of the conversation.
   * @return {Promise<string>} the ID of the conversation.
   */
  export async function createConversation(client: StreamChat<DefaultGenerics>, sender: string, members: string[]): Promise<string> {
    functions.logger.info("Creating conversation", {
      members,
    });

    await verifyMembersExist(client, members);

    // Generating a uuid for a channel allows users to be added/removed.
    // Channels with only two members should be unique so we dont pass a uuid.
    const uuid = members.length == 2 ? StringHelpers.generateDocumentNameFromGuids(members) : uuidv4();
    const conversation = client.channel("messaging", uuid, {
      members,
      created_by_id: sender,
    });

    const createdConversation = await conversation.create();
    functions.logger.info("Conversation created", {
      conversation: createdConversation,
    });

    return createdConversation.channel.id;
  }

  /**
   * Verifies that the given members exist in Stream Chat.
   * Creates the members if they don't exist.
   * @param {StreamChat<DefaultGenerics>} client the StreamChat client.
   * @param {string[]} members the members to check.
   * @return {Promise<void>} a promise that resolves when the members have been verified.
   */
  export async function verifyMembersExist(client: StreamChat<DefaultGenerics>, members: string[]): Promise<void> {
    functions.logger.info("Verifying users exist", { members });

    // Check any members are empty, and if so, error
    if (members.length === 0 || members.some((m) => m.length === 0)) {
      throw new Error("Members cannot be empty or contain empty strings");
    }

    const profiles = await client.queryUsers({
      id: { $in: members },
    });

    for (const member of members) {
      functions.logger.info("Verifying Stream chat user exists", { member });
      const profile = profiles.users.find((u) => u.id === member);
      if (profile == null) {
        functions.logger.info("Stream chat user does not exist, creating", {
          member,
        });
        
        await client.upsertUsers([
          {
            id: member,
          },
        ]);
      }
    }
  }

  /**
   * Archives members within the given channel
   * @param {StreamChat<DefaultGenerics>} client the StreamChat client.
   * @param {string} channelId the channel to action.
   * @param {string[]} members the members to archive.
   * @return {Promise<void>} a promise that resolves when the members have been archived.
   */
  export async function archiveMembers(client: StreamChat<DefaultGenerics>, channelId: string, members: string[]): Promise<void> {
    functions.logger.info("Archiving channel members", { members });

    const channels = await client.queryChannels({
      id: {
        $eq: channelId,
      },
    });

    if (channels.length == 0) {
      throw new HttpsError("not-found", "Channel not found");
    }

    // Group chats get assigned a unique channel id.
    // There should only be one channel with the given id.
    const channel = channels[0];

    const archivedMembers = members.map((memberId) => ({
      member_id: memberId,
      date_archived: new Date().toISOString(),
      last_message_id: channel.lastMessage().id,
    }));

    await channel.updatePartial({ set: { archived_members: archivedMembers } });
  }
}
