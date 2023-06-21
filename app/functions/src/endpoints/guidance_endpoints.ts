import * as functions from "firebase-functions";
import { adminApp } from "..";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { CacheService } from "../services/cache_service";

export namespace GuidanceEndpoints {
  export const getGuidanceCategories = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data) => {
    functions.logger.info("Getting guidance categories", { structuredData: true });
    functions.logger.info(data);
    const locale = data.locale ?? "en";
    const parent = data.parent ?? null;
    const guidanceType = data.guidanceType;

    const firestore = adminApp.firestore();
    let query = firestore.collection("fl_content").where("_fl_meta_.schema", "==", "guidanceCategories").where("guidanceType", "==", guidanceType).where("locale", "==", locale);
    let cacheKey = `guidanceCategories_${locale}_${guidanceType}`;

    if (parent == null) {
      query = query.where("parent", "==", null);
    } else {
      const parentRef = firestore.doc(`/fl_content/${parent}`);
      query = query.where("parent", "==", parentRef);
      cacheKey = `guidanceCategories_${locale}_${guidanceType}_${parent}`;
    }

    const cachedValue = await CacheService.getFromCache(cacheKey);
    if (cachedValue) {
      return JSON.stringify(cachedValue);
    }

    const snapshot = await query.get();
    const entries = snapshot.docs.map((doc) => doc.data());
    await CacheService.setInCache(cacheKey, entries);
    
    return JSON.stringify(entries);
  });

  export const getGuidanceArticles = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data) => {
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
        return JSON.stringify(cachedValue);
      }

      const rest = await query.get();
      const entries = rest.docs.map((doc) => doc.data());
      await CacheService.setInCache(cacheKey, entries);
      
      return JSON.stringify(entries);
    });

  // TODO: Update this to paginate later
  export const getGuidanceDirectoryEntries = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data) => {
    functions.logger.info("Getting directory entires", { structuredData: true });
    const cacheKey = `guidanceDirectoryEntries`;
    const cachedValue = await CacheService.getFromCache(cacheKey);
    if (cachedValue) {
      return JSON.stringify(cachedValue);
    }

    const resp = await adminApp.firestore().collection("fl_content").where("_fl_meta_.schema", "==", "guidanceDirectoryEntries").get();
    const entries = resp.docs.map((doc) => doc.data());
    await CacheService.setInCache(cacheKey, entries);
    
    return JSON.stringify(entries);
  });
}
