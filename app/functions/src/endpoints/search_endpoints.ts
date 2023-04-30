import * as functions from "firebase-functions";
import safeJsonStringify from "safe-json-stringify";

import { LocalizationsService } from "../services/localizations_service";
import { SystemService } from "../services/system_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { SearchService } from "../services/search_service";

export namespace SearchEndpoints {
  export const performSearch = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data) => {
      const query = data.query || "";
      const page = data.page || 0;
      const limit = data.limit || 10;
      const filters = data.filters || {};
      const indexKey = data.index || "activities";

      const searchClient = SearchService.getAlgoliaClient();
      if (!searchClient) {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "Search client is not initialized"
        );
      }

      const index = await SearchService.getIndex(searchClient, indexKey);
      if (!index) {
        return safeJsonStringify({});
      }

      functions.logger.info("Performing search", {
        query,
        page,
        limit,
        filters,
        indexKey,
      });
      
      const response = await SearchService.search(
        index,
        query,
        page,
        limit,
        filters
      );

      return safeJsonStringify(response);
    });

  export const getInterests = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data) => {
      const locale = data.locale || "en";
      const interests = await LocalizationsService.getDefaultInterests(locale);

      const response = {} as any;
      interests.forEach((value, key) => {
        response[key] = value;
      });

      return safeJsonStringify(response);
    });

  export const getHivStatuses = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data) => {
      const locale = data.locale || "en";
      const hivStatuses = await LocalizationsService.getDefaultHivStatuses(
        locale
      );

      return safeJsonStringify(hivStatuses);
    });

  export const getGenders = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data) => {
      const locale = data.locale || "en";
      const genders = await LocalizationsService.getDefaultGenders(locale);

      return safeJsonStringify(genders);
    });

  export const getTopics = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (_, context) => {
      functions.logger.info("Getting topics");
      await UserService.verifyAuthenticated(context);

      const app = SystemService.getFlamelinkApp();
      const data = await app.content.get({
        schemaKey: "topics",
      });

      return JSON.stringify(data);
    });
}
