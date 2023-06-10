import safeJsonStringify from "safe-json-stringify";
import * as functions from "firebase-functions";

import { PermissionContext, PermissionContextOpen, PermissionContextPrivate } from "../services/enumerations/permission_context";

import { StorageService } from "../services/storage_service";
import { PermissionsService } from "../services/permissions_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";

import { adminApp } from "..";

export namespace ProfileMapper {
  /**
   * The properties that are displayed based on the relationship
   * @example
   * ```ts
   * const enforcedRelationship = enforcedProperties[property as keyof typeof enforcedProperties];
   * const relationshipCheck = relationship & enforcedRelationship;
   * if (relationshipCheck === 0) {
   *  continue;
   * }
   * ```
   */
  export const enforcedProperties = {
    _fl_meta_: PermissionContextOpen,
    id: PermissionContextOpen,
    email: PermissionContextPrivate,
    phoneNumber: PermissionContextPrivate,
    fcmToken: PermissionContextPrivate,
    name: PermissionContextPrivate,
    displayName: PermissionContextOpen,
    birthday: PermissionContextOpen,
    interests: PermissionContextOpen,
    genders: PermissionContextOpen,
    hivStatus: PermissionContextOpen,
    location: PermissionContextOpen,
    locationSkipped: PermissionContextPrivate,
    referenceImage: PermissionContextPrivate,
    profileImage: PermissionContextOpen,
    accentColor: PermissionContextOpen,
    biography: PermissionContextOpen,
    visibilityFlags: PermissionContextPrivate,
    managers: PermissionContextPrivate,
    featureFlags: PermissionContextPrivate,
    admin: PermissionContextPrivate,
  };

  /**
   * Converts a flamelink object to a profile
   * @param {any} profile The profile to convert
   * @param {PermissionContext} context The context to the profile
   * @return {string} The profile as a response
   */
  export async function convertFlamelinkObjectToProfile(context: functions.https.CallableContext, uid: string, profile: any): Promise<any> {
    const response: any = {};

    // const authorizationTarget = PermissionsService.getAuthorizationTarget(profile);
    const permissionContext = PermissionsService.getPermissionContext(context, profile, uid);

    // Get the target users flamelink ID
    const targetId = FlamelinkHelpers.getFlamelinkIdFromObject(profile);
    if (!targetId) {
      functions.logger.error("Missing target ID", {
        structuredData: true,
      });

      return;
    }

    // Check the target user exists
    // Change this to remove index on profile deletion
    const user = await adminApp.auth().getUser(targetId);
    if (!user) {
      return;
    }

    //* Copy the properties that are allowed
    const propertiePromises = [] as Promise<any>[];
    for (const property in profile) {
      if (!Object.prototype.hasOwnProperty.call(profile, property)) {
        continue;
      }

      const enforcedRelationship = enforcedProperties[property as keyof typeof enforcedProperties];
      const relationshipCheck = permissionContext & enforcedRelationship;
      if (relationshipCheck === 0) {
        continue;
      }

      if (!profile[property]) {
        continue;
      }

      switch (property) {
        case "profileImage":
        case "referenceImage":
          propertiePromises.push(
            StorageService.getMediaLinkByPath(profile[property]).then((link) => {
              response[property] = link;
            }),
          );
          break;
        default:
          response[property] = profile[property];
          break;
      }
    }

    await Promise.all(propertiePromises);

    return response;
  }

  /**
   * Converts a profile to a response based on the relationship
   * @param {any} profile The profile to convert
   * @param {PermissionContext} context The context to the profile
   * @return {string} The profile as a response
   */
  export async function convertProfileToResponse(profile: any, context: PermissionContext): Promise<string> {
    const response: any = {};

    //* Copy the properties that are allowed
    for (const property in profile) {
      if (!Object.prototype.hasOwnProperty.call(profile, property)) {
        continue;
      }

      const enforcedRelationship = enforcedProperties[property as keyof typeof enforcedProperties];
      const relationshipCheck = context & enforcedRelationship;
      if (relationshipCheck === 0) {
        continue;
      }

      if (!profile[property]) {
        continue;
      }

      switch (property) {
        case "profileImage":
        case "referenceImage":
          response[property] = await StorageService.getMediaLinkByPath(profile[property]);
          break;
        default:
          response[property] = profile[property];
          break;
      }
    }

    return safeJsonStringify(response);
  }
}
