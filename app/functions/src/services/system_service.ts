import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

import { adminApp } from "..";
import flamelink from "flamelink";
import { SlackService } from "./slack_service";
import { ProfileJSON } from "../dto/profile";

export namespace SystemService {
  let flamelinkApp: flamelink.app.App;

  /**
 * Lazy loads a Flamelink app instance.
 *
 * @returns {Promise<flamelink.app.App>} A promise that resolves with a Flamelink app instance.
 */
  export function getFlamelinkApp(): flamelink.app.App {
    // Check if the Flamelink app instance has already been loaded.
    if (typeof flamelinkApp === "undefined") {
      // Initialize the Flamelink app instance.
      functions.logger.info("Initializing Flamelink app instance");
      flamelinkApp = flamelink({
        firebaseApp: adminApp,
        dbType: "cf",
        precache: false,
        env: "production", // We use multiple Firebase projects, so this is always production.
      });
    }

    // Return the Flamelink app instance.
    return flamelinkApp;
  }

  /**
   * Verifies the application passed a valid context through to the function.
   * This is used to verify the AppCheck integrity of the caller.
   * @param {functions.https.CallableContext} context The context from a https onCall function
   */
  export async function verifyAppCheck(context: functions.https.CallableContext): Promise<void> {
    functions.logger.info("Verifying app check");
    if (context.app == undefined) {
      throw new functions.https.HttpsError("failed-precondition", "The function must be called from an App Check verified app.");
    }
  }

  /**
   * Gets the bytes from a URL.
   * @param {string} url The URL to get the bytes from.
   * @returns {Promise<ArrayBuffer>} A promise that resolves with the bytes from the URL.
   */
  export async function getBytesFromUrl(url: string): Promise<ArrayBuffer> {
    functions.logger.info(`Getting bytes from URL: ${url}`);
    const response = await fetch(url);
    if (!response.ok) {
      throw new functions.https.HttpsError("not-found", `Failed to get bytes from URL: ${url}`);
    }

    const buffer = await response.arrayBuffer();
    functions.logger.info(`Got ${buffer.byteLength} bytes from URL: ${url}`);

    return buffer;
  }

  /**
   * Updates user access claims in Firebase Authentication.
   * @param {string} accessId The user access ID
   * @param {CustomUserClaims} customClaims The new claims for the user
   */
  export async function updateUserClaims(accessId: string, customClaims: object | null): Promise<void> {
    functions.logger.info(`Updating user claims in Firebase Authentication for ${accessId} to ${JSON.stringify(customClaims)}`);

    const adminAuth = admin.auth();
    const userRecord = await adminAuth.getUser(accessId);

    // Check if the claims have changed.
    if (!customClaims || JSON.stringify(userRecord.customClaims) === JSON.stringify(customClaims)) {
      return;
    }

    await admin.auth().setCustomUserClaims(accessId, customClaims);
  }

  export async function validateUsingRedisUserThrottle(context: functions.https.CallableContext): Promise<boolean> {
    // const endpoint = context.rawRequest.originalUrl;
    // const ipAddr = context.rawRequest.ip;

    // // Limit to 10 times in one minute.
    // const throttleKey = `throttle_${endpoint}_${ipAddr}`;
    // let throttleValue = await CacheService.get(throttleKey);
    // if (!throttleValue) {
    //   throttleValue = 0;
    // }

    // throttleValue++;
    // await CacheService.setInCache(throttleKey, throttleValue, 60);

    // if (throttleValue > 10) {
    //   functions.logger.warn(`Throttling ${endpoint} for ${ipAddr}`);
    //   throw new functions.https.HttpsError("failed-precondition", "Too many requests.");
    // }

    return true;
  }

  /**
   * Submits feedback from the user to the database.
   * @param {string} profile The user ID of the user submitting the feedback.
   * @param {string} feedbackType The type of feedback being submitted.
   * @param {string} reportType The type of report being submitted.
   * @param {string} content The content of the feedback.
   */
  export async function submitFeedback(profile: ProfileJSON, feedbackType: string, reportType: string, content: string): Promise<void> {
    functions.logger.info("Submitting feedback", { profile, feedbackType, reportType, content });
    await getFlamelinkApp().content.add({
      schemaKey: "feedback",
      data: {
        createdBy: profile._fl_meta_?.fl_id,
        feedbackType,
        reportType,
        content,
      },
    });

    // If content is a json string, parse it and send it to slack; converting all camelCase keys to Pascal Case.
    // We do not await this because we do not want to block the response to the user.
    let slackContent = `Feedback type: ${feedbackType}\n${content}`;

    if (content.startsWith("{")) {
      try {
        const parsedContent = JSON.parse(content);
        let newSlackContent = "";

        // Loop through all keys and values and append them to the slack content.
        for (const key in parsedContent) {
          const value = parsedContent[key];
          const pascalSpacedKey = key.replace(/([A-Z])/g, " $1");
          const pascalSpacedKeyWithUpperCase = pascalSpacedKey.charAt(0).toUpperCase() + pascalSpacedKey.slice(1);

          newSlackContent += `${pascalSpacedKeyWithUpperCase}: ${value}\n`;
        }

        slackContent = newSlackContent;
      } catch (err) {
        functions.logger.error("Failed to parse content", { err });
      }
    }

    SlackService.postToChannelAsMember(profile, SlackService.feedbackChannel, slackContent);
  }
}
