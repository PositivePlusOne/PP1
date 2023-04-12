import * as functions from "firebase-functions";

import { Channel, DefaultGenerics, StreamChat } from "stream-chat";

export namespace ConversationService {
  /**
   * Returns a StreamChat instance with the API key and secret.
   * @return {StreamChat<DefaultGenerics>} instance of StreamChat
   */
  export function getStreamInstance(): StreamChat<DefaultGenerics> {
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
   * @param {string} userId the user's ID.
   * @return {string} the user's token.
   * @see https://getstream.io/chat/docs/node/tokens_and_authentication/?language=javascript
   */
  export function getUserToken(userId: string): string {
    functions.logger.info("Creating user token", { userId });
    const streamInstance = getStreamInstance();

    const token = streamInstance.createToken(userId);
    functions.logger.info("User token", { token });

    return token;
  }

  /**
   * Revokes a user's token from GetStream.
   * @param {string} userId the user's ID.
   * @return {Promise<void>} a promise that resolves when the token has been revoked.
   */
  export async function revokeUserToken(userId: string): Promise<void> {
    functions.logger.info("Revoking user token", { userId });
    const streamInstance = getStreamInstance();

    await streamInstance.revokeUserToken(userId);
    functions.logger.info("User token revoked", { userId });
  }

  /**
   * Creates a conversation between the given members.
   * @param {string} sender the sender of the conversation.
   * @param {string[]} members the members of the conversation.
   * @return {Promise<string>} the ID of the conversation.
   */
  export async function createConversation(sender: string, members: string[]): Promise<string> {
    functions.logger.info("Creating conversation", {
      members,
    });

    const streamInstance = getStreamInstance();

    const conversation = streamInstance.channel("messaging", {
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
   * @param {any} profile the profile to get the invitations for.
   * @return {Channel<DefaultGenerics>[]} the list of accepted invitations.
   */
  export async function getAcceptedInvitations(
    profile: any
  ): Promise<Channel<DefaultGenerics>[]> {
    functions.logger.info("Getting accepted invitations", { profile });
    if (
      profile == null ||
      profile._fl_meta_ == null ||
      profile._fl_meta_.docId == null
    ) {
      return [];
    }

    if (
      typeof profile._fl_meta_.docId !== "string" ||
      profile._fl_meta_.docId.length === 0
    ) {
      return [];
    }

    const streamInstance = getStreamInstance();
    let channels: Channel<DefaultGenerics>[] = [];

    try {
      channels = await streamInstance.queryChannels(
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
}
