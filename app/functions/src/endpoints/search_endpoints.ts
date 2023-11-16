import * as functions from "firebase-functions";
import safeJsonStringify from "safe-json-stringify";

import { LocalizationsService } from "../services/localizations_service";
import { SystemService } from "../services/system_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA, FIREBASE_FUNCTION_INSTANCE_DATA_256 } from "../constants/domain";
import { SearchService } from "../services/search_service";
import { PositiveSearchIndex } from "../constants/search_indexes";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";

export namespace SearchEndpoints {
  export const getInterests = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
    const locale = data.locale || "en";
    const interests = await LocalizationsService.getDefaultInterests(locale);

    const response = {} as any;
    interests.forEach((value, key) => {
      response[key] = value;
    });

    return safeJsonStringify(response);
  });

  //* Deprecated: Moving to SystemEndpoints.getBuildInformation
  export const getHivStatuses = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
    const locale = data.locale || "en";
    const hivStatuses = await LocalizationsService.getDefaultHivStatuses(locale);

    return safeJsonStringify(hivStatuses);
  });

  //* Deprecated: Moving to SystemEndpoints.getBuildInformation
  export const getGenders = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
    const locale = data.locale || "en";
    const genders = await LocalizationsService.getDefaultGenders(locale);

    return safeJsonStringify(genders);
  });

  //* Deprecated: Moving to SystemEndpoints.getBuildInformation
  export const getTopics = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (_, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);

    functions.logger.info("Getting topics");
    await UserService.verifyAuthenticated(context);

    const app = SystemService.getFlamelinkApp();
    const data = await app.content.get({
      schemaKey: "topics",
    });

    return JSON.stringify(data);
  });

  //* Deprecated: Moving to SystemEndpoints.getBuildInformation
  export const getCompanySectors = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
    const locale = data.locale || "en";
    const companySectors = await LocalizationsService.getDefaultCompanySectors(locale);

    return safeJsonStringify(companySectors);
  });

  export const search = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA_256).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);

    functions.logger.info("Searching data from algolia");
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const page = parseInt(request.data.page) || 0;
    const index = request.data.index || PositiveSearchIndex.USERS;
    const query = request.data.query || "";
    const attributeFilters = request.data.filters || [] as string[];
    const facetFilters = request.data.facetFilters || [] as string[];
    const limit = request.limit || 10;

    functions.logger.info(`Searching for ${query} in ${index}`, {
      structuredData: true,
      page: page,
      limit: limit,
      filters: attributeFilters,
    });

    // Verify index is a valid PositiveSearchIndex
    if (!Object.values(PositiveSearchIndex).includes(index)) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid index");
    }

    const algoliaClient = SearchService.getAlgoliaClient();
    const algoliaIndex = algoliaClient.initIndex(index);
    const searchResults = await SearchService.search(algoliaIndex, query, page, limit, attributeFilters, facetFilters);

    functions.logger.info(`Got search results`, searchResults);

    return buildEndpointResponse(context, {
      sender: uid,
      data: searchResults,
    });
  });
}
