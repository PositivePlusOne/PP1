import * as functions from "firebase-functions";
import {Keys} from "../constants/keys";
import {UserService} from "../services/user_service";
import {ProfileService} from "../services/profile_service";
import {StreamService} from "../services/stream_service";

namespace LocationEndoints {

    export const getToken = functions
        .runWith({ secrets: [Keys.StreamApiKey, Keys.StreamApiSecret] })
        .https.onCall(async (_, context) => {
            await UserService.verifyAuthenticated(context);

            const uid = context.auth?.uid || "";
            functions.logger.info("Getting user chat token", { uid });

            const hasCreatedProfile = await ProfileService.hasCreatedProfile(uid);
            if (!hasCreatedProfile) {
                throw new functions.https.HttpsError(
                    "not-found",
                    "User profile not found"
                );
            }

            const userChatToken = StreamService.getUserToken(uid);
            functions.logger.info("User chat token", { userChatToken });

            return userChatToken;
        });
}