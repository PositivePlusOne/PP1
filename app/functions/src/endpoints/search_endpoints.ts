import * as functions from "firebase-functions";
import safeJsonStringify from "safe-json-stringify";

import { LocalizationsService } from "../services/localizations_service";
import { SystemService } from "../services/system_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

export namespace SearchEndpoints {
  //* Deprecated: Moving to SystemEndpoints.getBuildInformation
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

  //* Deprecated: Moving to SystemEndpoints.getBuildInformation
  export const getHivStatuses = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data) => {
      const locale = data.locale || "en";
      const hivStatuses = await LocalizationsService.getDefaultHivStatuses(
        locale
      );

      return safeJsonStringify(hivStatuses);
    });

  //* Deprecated: Moving to SystemEndpoints.getBuildInformation
  export const getGenders = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data) => {
      const locale = data.locale || "en";
      const genders = await LocalizationsService.getDefaultGenders(locale);

      return safeJsonStringify(genders);
    });

  //* Deprecated: Moving to SystemEndpoints.getBuildInformation
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
