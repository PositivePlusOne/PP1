import * as functions from "firebase-functions";

import { DefaultGenerics, StreamChat } from "stream-chat";
import { Keys } from "../constants/keys";

export namespace StreamService {
  /**
   * Returns a StreamChat instance with the API key and secret.
   * @return {StreamChat<DefaultGenerics>} instance of StreamChat
   */
  export function getStreamInstance(): StreamChat<DefaultGenerics> {
    functions.logger.info("Getting Stream instance", { structuredData: true });
    return StreamChat.getInstance(Keys.streamApiKey, Keys.streamApiSecret);
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
}
