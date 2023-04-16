import safeJsonStringify from "safe-json-stringify";
import {
  PermissionContext,
  PermissionContextDeterministic,
  PermissionContextPrivate,
} from "../services/enumerations/permission_context";

import { defaultRelationshipFlags } from "../services/types/relationship_flags";
import { StorageService } from "../services/storage_service";

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
    id: PermissionContextDeterministic,
    displayName: PermissionContextDeterministic,
    name: PermissionContextPrivate,
    email: PermissionContextPrivate,
    phoneNumber: PermissionContextPrivate,
    fcmToken: PermissionContextPrivate,
    birthday: PermissionContextDeterministic,
    interests: PermissionContextDeterministic,
    genders: PermissionContextDeterministic,
    visibilityFlags: PermissionContextPrivate,
    featureFlags: PermissionContextPrivate,
    referenceImage: PermissionContextPrivate,
    profileImage: PermissionContextDeterministic,
    accentColor: PermissionContextDeterministic,
    hivStatus: PermissionContextDeterministic,
    admin: PermissionContextPrivate,
    location: PermissionContextDeterministic,
    locationSkipped: PermissionContextPrivate,
  };

  /**
   * Converts a profile to a response based on the relationship
   * @param {any} profile The profile to convert
   * @param {PermissionContext} context The context to the profile
   * @return {string} The profile as a response
   */
  export async function convertProfileToResponse(
    profile: any,
    context: PermissionContext,
    { connectionCount = 0, followerCount = 0, relationshipFlags = defaultRelationshipFlags }
  ): Promise<string> {
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
    
    response.connectionCount = connectionCount;
    response.followerCount = followerCount;
    response.relationship = relationshipFlags;

    return safeJsonStringify(response);
  }
}
