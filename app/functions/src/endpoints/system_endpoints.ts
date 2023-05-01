import * as functions from "firebase-functions";

import { SystemService } from "../services/system_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import {
  getDataChangeSchema,
  getDataChangeType,
} from "../handlers/data_change_type";

import { DataHandlerRegistry } from "../handlers/data_change_handler";
import { LocalizationsService } from "../services/localizations_service";
import { ProfileService } from "../services/profile_service";
import { PermissionsService } from "../services/permissions_service";
import { AuthorizationTarget } from "../services/enumerations/authorization_target";
import { ProfileMapper } from "../maps/profile_mappers";
import safeJsonStringify from "safe-json-stringify";

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
        functions.logger.info(
          "Data change ignored (no change type or schema)",
          {
            changeType,
            schema,
          }
        );

        return;
      }

      const isRecursive = FlamelinkHelpers.arePayloadsEqual(
        beforeData,
        afterData
      );

      if (isRecursive) {
        functions.logger.info("Data change ignored (recursive)", {
          changeType,
        });

        return;
      }

      await DataHandlerRegistry.executeChangeHandlers(
        changeType,
        schema,
        context.params.documentId,
        beforeData,
        afterData
      );
    });

  export const getBuildInformation = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      const locale = data.locale || "en";
      const genders = await LocalizationsService.getDefaultGenders(locale);
      const interests = await LocalizationsService.getDefaultInterests(locale);
      const hivStatuses = await LocalizationsService.getDefaultHivStatuses(
        locale
      );

      const interestResponse = {} as any;
      interests.forEach((value, key) => {
        interestResponse[key] = value;
      });

      let profile = null;
      if (context.auth?.uid) {
        const rawProfileResponse = await ProfileService.getProfile(
          context.auth?.uid
        );

        const permissionContext = PermissionsService.getPermissionContext(
          context,
          AuthorizationTarget.Profile,
          context.auth?.uid
        );

        profile = ProfileMapper.convertProfileToResponse(
          rawProfileResponse,
          permissionContext
        );
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

  export const submitFeedback = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const feedback = data.feedback;

      functions.logger.info("Submitting feedback", { uid, feedback });
      await SystemService.submitFeedback(uid, feedback);

      return JSON.stringify({ success: true });
    });
}
