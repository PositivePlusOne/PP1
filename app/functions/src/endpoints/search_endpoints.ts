import * as functions from "firebase-functions";

import { Keys } from "../constants/keys";
import { UserService } from "../services/user_service";
import { SearchService } from "../services/search_service";

export namespace SearchEndpoints {
    export const getAPIKey = functions.runWith({ secrets: [Keys.AlgoliaApiKey] }).https.onCall(async (_, context) => {
        await UserService.verifyAuthenticated(context);
        return SearchService.getApiKey();
      });
}