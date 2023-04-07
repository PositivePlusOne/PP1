import safeJsonStringify from "safe-json-stringify";
import {
  EntityRelationship,
  EntityRelationshipDeterministic,
  EntityRelationshipPrivate,
} from "../services/enumerations/entity_relationship";

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
    id: EntityRelationshipDeterministic,
    displayName: EntityRelationshipDeterministic,
    name: EntityRelationshipPrivate,
    email: EntityRelationshipPrivate,
    phoneNumber: EntityRelationshipPrivate,
    fcmToken: EntityRelationshipPrivate,
    birthday: EntityRelationshipDeterministic,
    interests: EntityRelationshipDeterministic,
    genders: EntityRelationshipDeterministic,
    visibilityFlags: EntityRelationshipPrivate,
    featureFlags: EntityRelationshipPrivate,
    referenceImages: EntityRelationshipPrivate,
    accentColor: EntityRelationshipDeterministic,
    hivStatus: EntityRelationshipDeterministic,
    admin: EntityRelationshipPrivate,
  };

  /**
   * Converts a profile to a response based on the relationship
   * @param {any} profile The profile to convert
   * @param {EntityRelationship} relationship The relationship to the profile
   * @return {string} The profile as a response
   */
  export function convertProfileToResponse(
    profile: any,
    relationship: EntityRelationship,
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

      const relationshipCheck = relationship & enforcedRelationship;
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
