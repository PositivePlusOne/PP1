import * as functions from "firebase-functions";
import { HttpsError } from "firebase-functions/v1/auth";

import { Channel, DefaultGenerics, StreamChat } from "stream-chat";

export namespace StreamService {
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
   * Generates a private channel name for the given profiles.
   * @param {any} uid1 the first profile.
   * @param {any} uid2 the second profile.
   * @return {string} the private channel name.
   */
  export function generatePrivateChannelName(
    uid1: string,
    uid2: string
  ): string {
    if (uid1 < uid2) {
      return `${uid1}-${uid2}`;
    }

    return `${uid2}-${uid1}`;
  }

  /**
   * Gets a list of pending invitations for the given profile.
   * @param {any} profile the profile to get the invitations for.
   * @return {Channel<DefaultGenerics>[]} the list of pending invitations.
   */
  export async function getPendingInvitations(
    profile: any
  ): Promise<Channel<DefaultGenerics>[]> {
    functions.logger.info("Getting pending invitations", { profile });
    const streamInstance = getStreamInstance();
    const userId = profile._fl_meta_.docId;

    if (!userId) {
      return [];
    }

    const channels = await streamInstance.queryChannels(
      {
        invite: "pending",
      },
      {},
      { user_id: userId }
    );

    functions.logger.info("Pending invitations", { channels });
    return channels;
  }

  /**
   * Accepts an invitation for the given channel.
   * @param {string} channelName the name of the channel.
   * @param {any} userProfile the user profile.
   * @return {Channel<DefaultGenerics>} the accepted channel.
   */
  export async function acceptInvitation(
    channelName: string,
    userProfile: any
  ): Promise<Channel<DefaultGenerics>> {
    functions.logger.info("Accepting invitation", { channelName, userProfile });
    const streamInstance = getStreamInstance();
    const uid = userProfile._fl_meta_.docId;

    if (!uid) {
      throw new HttpsError("not-found", "User not found");
    }

    const channels = await streamInstance.queryChannels(
      {
        type: "messaging",
        name: channelName,
      },
      {},
      { user_id: uid }
    );

    //* Check all the channels for pending invitations
    if (channels.length == 0) {
      throw new HttpsError("not-found", "Channel not found");
    }

    const channel = channels[0];
    await channel.acceptInvite();

    return channel;
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
    const streamInstance = getStreamInstance();
    const userId = profile._fl_meta_.docId;

    if (!userId) {
      return [];
    }

    const channels = await streamInstance.queryChannels(
      {
        invite: "accepted",
      },
      {},
      { user_id: userId }
    );

    functions.logger.info("Accepted invitations", { channels });
    return channels;
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
   * Creates a channel for the given profile against a target profile.
   *  @param {string} channelName the channel name.
   * @param {string} senderId the sender's ID.
   * @param {string} receiverId the receiver's ID.
   */
  export async function requestConnection(
    channelName: string,
    senderId: string,
    receiverId: string
  ): Promise<void> {
    const streamInstance = StreamService.getStreamInstance();
    const channelQuery = await streamInstance.queryChannels({
      type: "messaging",
      name: channelName,
    });

    let channel = streamInstance.channel("messaging", channelName, {
      members: [senderId],
    });

    if (channelQuery.length > 0) {
      functions.logger.info("Channel already exists, inviting members", {
        channelName,
      });

      // Check if the sender or receiver is already a member or invited to the channel
      channel = channelQuery[0];
      const members = channel.state.members;
      const memberIds = Object.keys(members);

      if (memberIds.includes(senderId) || memberIds.includes(receiverId)) {
        throw new HttpsError(
          "already-exists",
          "Sender or receiver is already a member of the channel",
          {
            channelName,
            senderId,
            receiverId,
          }
        );
      }

      await channel.inviteMembers([receiverId]);
      return;
    }

    functions.logger.info("Channel does not exist, creating channel", {
      channelName,
    });

    await channel.create();
    await channel.inviteMembers([receiverId]);
  }
}
