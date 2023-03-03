import * as functions from "firebase-functions";

import { Keys } from "../constants/keys";
import { SearchService } from "../services/search_service";
import { SystemService } from "../services/system_service";
import { UserService } from "../services/user_service";

export namespace SearchEndpoints {
  export const getSearchClient = functions
    .runWith({ secrets: [Keys.AlgoliaApiKey, Keys.AlgoliaAppID] })
    .https.onCall(async (_, context) => {
      functions.logger.info("Getting Algolia search client");
      await UserService.verifyAuthenticated(context);

      const apiKey = SearchService.getApiKey();
      const applicationId = SearchService.getApplicationId();

      return {
        apiKey,
        applicationId,
      };
    });
  
    export const getTopics = functions.https.onCall(async (_, context) => {
      functions.logger.info("Getting topics");
      await UserService.verifyAuthenticated(context);

      const app = SystemService.getFlamelinkApp();
      const data = await app.content.get({
        schemaKey: "topics",
      });

      return JSON.stringify(data);
    });
}
