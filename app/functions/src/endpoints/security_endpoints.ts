import * as functions from "firebase-functions";
import { SystemService } from "../services/system_service";

export namespace SecurityEndpoints {
  /**
   * Creates user access claims when an access document is created in Firestore
   */
   export const createAccessClaims = functions.firestore
   .document("access/{accessId}")
   .onCreate(async (document, context) => {
     const newValue = document.data();
     const accessId = context.params.accessId;

     console.log(`Assigning new level of ${newValue.level} to ${accessId}`);
     const customClaims = {
       level: newValue.level,
     };

     // Set custom user claims on this update.
     await SystemService.updateUserClaims(accessId, customClaims);
   });

  /**
   * Updates user access claims when an access document is updated in Firestore
   */
  export const updateAccessClaims = functions.firestore
    .document("access/{accessId}")
    .onUpdate(async (change, context) => {
      const newValue = change.after.data();
      const accessId = context.params.accessId;

      console.log(`Assigning new level of ${newValue.level} to ${accessId}`);
      const customClaims = {
        level: newValue.level,
      };

      // Set custom user claims on this update.
      await SystemService.updateUserClaims(accessId, customClaims);
    });
}
