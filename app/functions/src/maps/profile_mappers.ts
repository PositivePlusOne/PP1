import safeJsonStringify from "safe-json-stringify";
import {
  PermissionContext,
  PermissionContextDeterministic,
  PermissionContextPrivate,
} from "../services/enumerations/permission_context";

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
    referenceImages: PermissionContextPrivate,
    accentColor: PermissionContextDeterministic,
    hivStatus: PermissionContextDeterministic,
    admin: PermissionContextPrivate,
  };

  /**
   * Converts a profile to a response based on the relationship
   * @param {any} profile The profile to convert
   * @param {PermissionContext} context The context to the profile
   * @return {string} The profile as a response
   */
  export function convertProfileToResponse(
    profile: any,
    context: PermissionContext,
    { connectionCount = 0, followerCount = 0 }
  ): string {
    const response: any = {};

    //* Copy the properties that are allowed
    for (const property in profile) {
      if (!Object.prototype.hasOwnProperty.call(profile, property)) {
        continue;
      }

      const enforcedRelationship =
        enforcedProperties[property as keyof typeof enforcedProperties];

      const relationshipCheck = context & enforcedRelationship;
      if (relationshipCheck === 0) {
        continue;
      }

      // Check using a bitwise AND to see if the relationship is allowed
      response[property] = profile[property];
    }

    // TODO: Enforce visibility flags on the user profile

    // Add stream profile properties
    response.connectionCount = connectionCount;
    response.followerCount = followerCount;

    return safeJsonStringify(response);
  }
}
