import * as functions from "firebase-functions";

import { SystemService } from "../services/system_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { getDataChangeSchema, getDataChangeType } from "../handlers/data_change_type";

import { DataHandlerRegistry } from "../handlers/data_change_handler";
import { LocalizationsService } from "../services/localizations_service";
import { ProfileService } from "../services/profile_service";

import safeJsonStringify from "safe-json-stringify";
import { PermissionsService } from "../services/permissions_service";
import { AuthorizationTarget } from "../services/enumerations/authorization_target";
import { ProfileMapper } from "../mappers/profile_mappers";

export namespace SystemEndpoints {
  export const dataChangeHandler = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .firestore.document("fl_content/{documentId}")
    .onWrite(async (change, context) => {
      functions.logger.info("Data change detected", { change, context });
      const beforeData = change.before.exists ? change.before.data() : null;
      const afterData = change.after.exists ? change.after.data() : null;

      const changeType = getDataChangeType(beforeData, afterData);
      const schema = getDataChangeSchema(beforeData, afterData);

      if (!changeType || !schema) {
        functions.logger.info("Data change ignored (no change type or schema)", {
          changeType,
          schema,
        });

        return;
      }

      const isRecursive = FlamelinkHelpers.arePayloadsEqual(beforeData, afterData);

      if (isRecursive) {
        functions.logger.info("Data change ignored (recursive)", {
          changeType,
        });

        return;
      }

      await DataHandlerRegistry.executeChangeHandlers(changeType, schema, context.params.documentId, beforeData, afterData);
    });

  export const getBuildInformation = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    const locale = data.locale || "en";
    const genders = await LocalizationsService.getDefaultGenders(locale);
    const interests = await LocalizationsService.getDefaultInterests(locale);
    const hivStatuses = await LocalizationsService.getDefaultHivStatuses(locale);

    const interestResponse = {} as any;
    interests.forEach((value, key) => {
      interestResponse[key] = value;
    });

    let profile = {};
    const uid = context.auth?.uid || "";

    functions.logger.info("Checking if profile should be loaded", { uid });
    if (typeof uid === "string" && uid.length > 0) {
      const userProfile = await ProfileService.getProfile(uid);
      functions.logger.info("Profile", { profile });

      const profilePermissionContext = PermissionsService.getPermissionContext(context, AuthorizationTarget.Profile, uid);
      const profileJson = await ProfileMapper.convertProfileToResponse(userProfile, profilePermissionContext);

      profile = JSON.parse(profileJson);
    }

    return safeJsonStringify({
      minimumSupportedVersion: 1,
      eventPublisher: "8ypsXl385Jzj2NvHfgCG", // Ryans user for now!
      genders,
      medicalConditions: hivStatuses,
      interests: interestResponse,
      profile,
    });
  });

  export const submitFeedback = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const feedbackType = data.feedbackType || "unknown";
    const reportType = data.reportType || "unknown";
    const content = data.content || "";

    functions.logger.info("Submitting feedback", { uid, feedbackType, reportType, content });
    await SystemService.submitFeedback(uid, feedbackType, reportType, content);

    return JSON.stringify({ success: true });
  });
}
