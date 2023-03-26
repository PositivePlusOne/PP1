import * as functions from "firebase-functions";

import { LocalizationsService } from "../services/localizations_service";
import { SystemService } from "../services/system_service";
import { UserService } from "../services/user_service";

export namespace SystemEndpoints {
    export const getDefaultInterests = functions.https.onCall(async (data) => {
        const locale = data.locale || "en";
        return LocalizationsService.getDefaultInterests(locale);
    });

    export const submitFeedback = functions.https.onCall(async (data, context) => {
        await UserService.verifyAuthenticated(context);
        
        const uid = context.auth?.uid || "";
        const feedback = data.feedback;

        functions.logger.info("Submitting feedback", { uid, feedback });
        await SystemService.submitFeedback(uid, feedback);

        return JSON.stringify({ success: true });
    });
}
