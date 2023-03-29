import * as functions from "firebase-functions";
import safeJsonStringify from "safe-json-stringify";

import { Keys } from "../constants/keys";
import { LocalizationsService } from "../services/localizations_service";
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

  export const getInterests = functions.https.onCall(async (data) => {
    const locale = data.locale || "en";
    const interests = await LocalizationsService.getDefaultInterests(locale);

    const response = {} as any;
    interests.forEach((value, key) => {
      response[key] = value;
    });

    return safeJsonStringify(response);
  });

  export const getHivStatuses = functions.https.onCall(async (data) => {
    const locale = data.locale || "en";
    const hivStatuses = await LocalizationsService.getDefaultHivStatuses(
      locale
    );

    return safeJsonStringify(hivStatuses);
  });

  export const getGenders = functions.https.onCall(async (data) => {
    const locale = data.locale || "en";
    const genders = await LocalizationsService.getDefaultGenders(locale);

    return safeJsonStringify(genders);
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
