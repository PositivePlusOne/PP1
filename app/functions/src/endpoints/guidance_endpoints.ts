import * as functions from "firebase-functions";
import { adminApp } from "..";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { CacheService } from "../services/cache_service";
import safeJsonStringify from "safe-json-stringify";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { DataService } from "../services/data_service";

export namespace GuidanceEndpoints {
  export const getGuidanceCategories = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data) => {
    functions.logger.info("Getting guidance categories", { structuredData: true });
    const locale = data.locale ?? "en";
    const parent = data.parent ?? null;
    const guidanceType = data.guidanceType;

    const firestore = adminApp.firestore();
    let query = firestore.collection("fl_content").where("_fl_meta_.schema", "==", "guidanceCategories");
    query = query.where("guidanceType", "==", guidanceType);
    query = query.where("locale", "==", locale);

    const cacheKey = `guidance_categories_${locale}_${guidanceType}_${parent}`;

    const cachedValue = await CacheService.getFromCache(cacheKey);
    if (cachedValue) {
      return safeJsonStringify(cachedValue);
    }

    const snapshot = await query.get();
    const entries = snapshot.docs.map((doc: any) => doc.data());
    functions.logger.info(`Found ${entries.length} guidance categories`, { entries, structuredData: true });

    const filteredEntries = entries.filter((entry: any) => {
      // entry.parent could be an empty array or null
      if (parent) {
        return entry.parent?.id === parent;
      }

      return !entry.parent || entry.parent.length === 0;
    });

    await CacheService.setInCache(cacheKey, filteredEntries);
    return safeJsonStringify(filteredEntries);
  });

  export const getGuidanceArticles = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data: any) => {
      functions.logger.info("Getting guidance articles", { structuredData: true });
      const locale = data.locale || "en";
      const firestore = adminApp.firestore();
      const parent = data.parent ?? null;
      const guidanceType = data.guidanceType ?? "";

      let query = firestore
        .collection("fl_content")
        .where("_fl_meta_.schema", "==", "guidanceArticles")
        .where("locale", "==", locale);

      if (guidanceType) {
        query = query.where("guidanceType", "==", guidanceType);
      }

      if (!parent) {
        query = query.where("parents", "==", []);
      } else {
        const parentRef = firestore.doc(`/fl_content/${parent}`);
        query = query.where("parents", "array-contains", parentRef);
      }

      const cacheKey = `guidanceArticles_${locale}_${guidanceType}_${parent || ""}`;
      const cachedValue = await CacheService.getFromCache(cacheKey);
      if (cachedValue) {
        return safeJsonStringify(cachedValue);
      }

      const rest = await query.get();
      const entries = rest.docs.map((doc: any) => doc.data());

      if (entries.length === 0) {
        return safeJsonStringify([]);
      }

      await CacheService.setInCache(cacheKey, entries);

      return safeJsonStringify(entries);
    });

  // TODO: Update this to paginate later
  export const getGuidanceDirectoryEntries = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data: EndpointRequest, context) => {
    functions.logger.info("Getting directory entires", { structuredData: true });

    const cursor = data.cursor || "";
    const limit = data.limit || 10;
    const cacheKey = `guidanceDirectoryEntries_${cursor}_${limit}`;
    const cachedValue = await CacheService.getFromCache(cacheKey);

    let returnCursor = "";

    if (cachedValue && cachedValue.length > 0) {
      returnCursor = cachedValue[cachedValue.length - 1]._fl_meta_.fl_id;
      return buildEndpointResponse(context, {
        sender: "",
        cursor: returnCursor,
        limit: limit,
        data: [cachedValue],
      });
    }

    const windowData = await DataService.getDocumentWindowRaw({
      schemaKey: "guidanceDirectoryEntries",
      startAfter: cursor,
      limit: limit,
    });

    if (windowData.length === 0) {
      return buildEndpointResponse(context, {
        sender: "",
        cursor: returnCursor,
        limit: limit,
        data: [],
      });
    }

    await CacheService.setInCache(cacheKey, windowData);
    
    returnCursor = windowData[windowData.length - 1]._fl_meta_.fl_id;
    return buildEndpointResponse(context, {
      sender: "",
      cursor: returnCursor,
      limit: limit,
      data: [windowData],
    });
  });
}
