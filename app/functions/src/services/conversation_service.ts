import * as functions from "firebase-functions";
import { v4 as uuidv4 } from "uuid";

import { Channel, DefaultGenerics, StreamChat } from "stream-chat";

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

    // Check to see if a conversation with exactly the same members already exists.
    const existingConversations = await client.queryChannels(
      {
        members: { $eq: members },
      },
      {},
      {}
    );

    if (existingConversations.length > 0) {
      functions.logger.info("Conversation already exists", {
        conversation: existingConversations[0],
      });

      return existingConversations[0].cid;
    }

    // Generating a uuid for a channel allows users to be added/removed.
    // Channels with only two members should be unique so we dont pass a uuid.
    const uuid = members.length > 2 ? uuidv4() : null;
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
   * Gets a list of accepted invitations for the given profile.
   * @param {StreamChat<DefaultGenerics>} client the StreamChat client.
   * @param {any} profile the profile to get the invitations for.
   * @return {Channel<DefaultGenerics>[]} the list of accepted invitations.
   */
  export async function getAcceptedInvitations(client: StreamChat<DefaultGenerics>, profile: any): Promise<Channel<DefaultGenerics>[]> {
    functions.logger.info("Getting accepted invitations", { profile });
    if (profile == null || profile._fl_meta_ == null || profile._fl_meta_.docId == null) {
      return [];
    }

    if (typeof profile._fl_meta_.docId !== "string" || profile._fl_meta_.docId.length === 0) {
      return [];
    }

    let channels: Channel<DefaultGenerics>[] = [];

    try {
      channels = await client.queryChannels(
        {
          invite: "accepted",
        },
        {},
        { user_id: profile._fl_meta_.docId }
      );
    } catch (error) {
      functions.logger.error("Error getting accepted invitations", { error });
    }

    functions.logger.info("Accepted invitations", { channels });
    return channels;
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
    const streamInstance = getStreamChatInstance();

    // Check any members are empty, and if so, error
    if (members.length === 0 || members.some((m) => m.length === 0)) {
      throw new Error("Members cannot be empty or contain empty strings");
    }

    const profiles = await streamInstance.queryUsers({
      id: { $in: members },
    });

    for (const member of members) {
      functions.logger.info("Verifying Stream chat user exists", { member });
      const profile = profiles.users.find((u) => u.id === member);
      if (profile == null) {
        functions.logger.info("Stream chat user does not exist, creating", {
          member,
        });
        await streamInstance.upsertUsers([
          {
            id: member,
          },
        ]);
      }
    }
  }
}
