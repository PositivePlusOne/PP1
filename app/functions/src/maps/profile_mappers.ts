import safeJsonStringify from "safe-json-stringify";
import { EntityRelationship } from "../services/enumerations/entity_relationship";

export namespace ProfileMapper {
  export const enforcedProperties = {
    id: EntityRelationship.Owner | EntityRelationship.Admin | EntityRelationship.Connected | EntityRelationship.Following | EntityRelationship.Anonymous,
    displayName: EntityRelationship.Owner | EntityRelationship.Admin | EntityRelationship.Connected | EntityRelationship.Following | EntityRelationship.Anonymous,
    name: EntityRelationship.Owner | EntityRelationship.Admin,
    email: EntityRelationship.Owner | EntityRelationship.Admin,
    phoneNumber: EntityRelationship.Owner | EntityRelationship.Admin,
    fcmToken: EntityRelationship.Owner | EntityRelationship.Admin,
    referenceImages: EntityRelationship.Owner | EntityRelationship.Admin,
    admin: EntityRelationship.Owner | EntityRelationship.Admin,
  };

  export function convertProfileToResponse(
    profile: any,
    relationship: EntityRelationship
  ): string {
    const response: any = {};

    //* Copy the properties that are allowed
    for (const property in profile) {
      const enforcedRelationship =
        enforcedProperties[property as keyof typeof enforcedProperties];

      const relationshipCheck = relationship & enforcedRelationship;
      if (relationshipCheck === 0) {
        continue;
      }

      // Check using a bitwise AND to see if the relationship is allowed
      response[property] = profile[property];
    }

    return safeJsonStringify(response);
  }
}
