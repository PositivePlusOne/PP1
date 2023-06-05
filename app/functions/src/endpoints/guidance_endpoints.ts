import * as functions from "firebase-functions";
import { adminApp } from "..";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

export namespace GuidanceEndpoints {
  export const getGuidanceCategories = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data) => {
    functions.logger.info("Getting guidance categories", { structuredData: true });
    functions.logger.info(data);
    const locale = data.locale ?? "en";
    const parent = data.parent ?? null;
    const guidanceType = data.guidanceType;

    const firestore = adminApp.firestore();
    let query = firestore.collection("fl_content").where("_fl_meta_.schema", "==", "guidanceCategories").where("guidanceType", "==", guidanceType).where("locale", "==", locale);

    if (parent == null) {
      query = query.where("parent", "==", null);
    } else {
      const parentRef = firestore.doc(`/fl_content/${parent}`);
      query = query.where("parent", "==", parentRef);
    }

    const rest = await query.get();
    return JSON.stringify(rest.docs.map((doc) => doc.data()));
  });

  export const getGuidanceArticles = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data) => {
      functions.logger.info("Getting guidance articles", { structuredData: true });
      functions.logger.info(data);
      const locale = data.locale || "en";
      const firestore = adminApp.firestore();
      const parent = data.parent ?? null;
      const guidanceType = data.guidanceType;

      let query = firestore
        .collection("fl_content")
        .where("_fl_meta_.schema", "==", "guidanceArticles")
        .where("guidanceType", "==", guidanceType)
        .where("locale", "==", locale);

      if (parent == null) {
        query = query.where("parents", "==", []);
      } else {
        const parentRef = firestore.doc(`/fl_content/${parent}`);
        query = query.where("parents", "array-contains", parentRef);
      }

      const rest = await query.get();
      return JSON.stringify(rest.docs.map((doc) => doc.data()));
    });

  export const getGuidanceDirectoryEntries = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data) => {
    functions.logger.info("Getting directory entires", { structuredData: true });
    functions.logger.info(data);
    const resp = await adminApp.firestore().collection("fl_content").where("_fl_meta_.schema", "==", "guidanceDirectoryEntries").get();
    return JSON.stringify(resp.docs.map((doc) => doc.data()));
  });
}
