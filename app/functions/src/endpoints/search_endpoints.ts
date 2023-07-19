import * as functions from "firebase-functions";
import safeJsonStringify from "safe-json-stringify";

import { LocalizationsService } from "../services/localizations_service";
import { SystemService } from "../services/system_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { SearchService } from "../services/search_service";
import { PositiveSearchIndex } from "../constants/search_indexes";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";

export namespace SearchEndpoints {
  //* Deprecated: Moving to SystemEndpoints.getBuildInformation
  export const getInterests = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data) => {
    const locale = data.locale || "en";
    const interests = await LocalizationsService.getDefaultInterests(locale);

    const response = {} as any;
    interests.forEach((value, key) => {
      response[key] = value;
    });

    return safeJsonStringify(response);
  });

  //* Deprecated: Moving to SystemEndpoints.getBuildInformation
  export const getHivStatuses = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data) => {
    const locale = data.locale || "en";
    const hivStatuses = await LocalizationsService.getDefaultHivStatuses(locale);

    return safeJsonStringify(hivStatuses);
  });

  //* Deprecated: Moving to SystemEndpoints.getBuildInformation
  export const getGenders = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data) => {
    const locale = data.locale || "en";
    const genders = await LocalizationsService.getDefaultGenders(locale);

    return safeJsonStringify(genders);
  });

  //* Deprecated: Moving to SystemEndpoints.getBuildInformation
  export const getTopics = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (_, context) => {
    functions.logger.info("Getting topics");
    await UserService.verifyAuthenticated(context);

    const app = SystemService.getFlamelinkApp();
    const data = await app.content.get({
      schemaKey: "topics",
    });

    return JSON.stringify(data);
  });

  export const search = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    functions.logger.info("Searching data from algolia");
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const page = parseInt(request.data.page) || 0;
    const index = request.data.index || PositiveSearchIndex.USERS;
    const query = request.data.query || "";
    const filters = request.data.filters || "";
    const limit = request.limit || 10;

    functions.logger.info(`Searching for ${query} in ${index} with page ${page} and limit ${limit} and filters ${filters}`);

    // Verify index is a valid PositiveSearchIndex
    if (!Object.values(PositiveSearchIndex).includes(index)) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid index");
    }

    const algoliaClient = SearchService.getAlgoliaClient();
    const algoliaIndex = algoliaClient.initIndex(index);
    const searchResults = await SearchService.search(algoliaIndex, query, page, limit, filters);

    functions.logger.info(`Got search results`, searchResults);

    return buildEndpointResponse(context, {
      sender: uid,
      data: searchResults,
    });
  });
}
