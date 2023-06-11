import * as functions from "firebase-functions";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { ProfileMapper } from "./profile_mappers";
import { RelationshipService } from "../services/relationship_service";
import { StringHelpers } from "../helpers/string_helpers";
import { ActivityMappers } from "./activity_mappers";

/**
 * Converts a Flamelink object to a response object.
 * @param {functions.https.CallableContext} context The context of the request
 * @param {string} uid The uid of the user
 * @param {Record<string, any>} obj The object to convert
 * @param {Record<string, any[]>} responseEntities The response object
 * @param {boolean} walk Whether to walk through the object
 * @param {Set<any>} visited Set of visited objects (for circular reference detection)
 * @return {Record<string, any[]>} The response object
 */
export async function convertFlamelinkObjectToResponse(context: functions.https.CallableContext, uid: string, obj: Record<string, any>, responseEntities: Record<string, any> = {}, walk = true, visited = new Set(), maxDepth = 5, currentDepth = 0): Promise<Record<string, any>> {
  const promises = [] as Promise<any>[];
  if (obj == null || visited.has(obj)) {
    return responseEntities;
  }

  if (maxDepth > 0 && currentDepth > maxDepth) {
    return responseEntities;
  }

  visited.add(obj);

  // If object is an array, create a Promise for each item.
  if (Array.isArray(obj)) {
    const promises = obj.map(async (item) => {
      return await convertFlamelinkObjectToResponse(context, uid, item, responseEntities, walk, visited, maxDepth, currentDepth + 1);
    });

    // Wait for all Promises to resolve.
    await Promise.all(promises);

    // Return the array of responses.
    return responseEntities;
  }

  // Check if the object is an object.
  if (typeof obj !== "object" || !Object.keys(obj).length) {
    return responseEntities;
  }

  functions.logger.log("Attempting to convert a potential flamelink object to response.", { obj, responseEntities, walk, visited, maxDepth, currentDepth });

  // Loop through each property in the object.
  for (const property in obj) {
    if (!Object.prototype.hasOwnProperty.call(obj, property)) {
      continue;
    }

    // Check if the property is an object. If not, continue.
    if (typeof obj[property] !== "object" || obj[property] === null) {
      continue;
    }

    // References are resolved later in the response mappers
    if (obj[property]._firestore !== undefined && obj[property]._firestore !== null) {
      continue;
    }

    promises.push(convertFlamelinkObjectToResponse(context, uid, obj[property], responseEntities, walk, visited, maxDepth, currentDepth + 1));
  }

  await Promise.all(promises);

  const flamelinkSchema = FlamelinkHelpers.getFlamelinkSchemaFromObject(obj);
  const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(obj);

  // Check if the schema and id are empty.
  if (!flamelinkSchema || !flamelinkId) {
    return responseEntities;
  }

  // Checks relationships for the object.
  if (!responseEntities["relationships"] || !Array.isArray(responseEntities["relationships"])) {
    responseEntities["relationships"] = [];
  }

  // Append the relationship to the object if it does not exist.
  const members = [uid, flamelinkId];
  const relationshipName = StringHelpers.generateDocumentNameFromGuids(members);

  // Create a list of promises to store the futures which mux the relationship lookup and the object conversion.
  const relationshipPromises = [] as Promise<any>[];

  // Check if the relationship already exists.
  if (relationshipName.length > 0 && !responseEntities["relationships"].find((r: any) => FlamelinkHelpers.getFlamelinkIdFromObject(r) === relationshipName) && uid !== flamelinkId) {
    const relationshipPromise = RelationshipService.getRelationship(members)
      .then((relationship) => {
        if (relationship) {
          responseEntities["relationships"].push(relationship);
        }
      })
      .catch((err) => {
        console.error(`Failed to get relationship for members: ${members}`, err);
      });

    relationshipPromises.push(relationshipPromise);
  }

  // Create the schema array if it does not exist.
  if (!responseEntities[flamelinkSchema] || !Array.isArray(responseEntities[flamelinkSchema])) {
    responseEntities[flamelinkSchema] = [];
  }

  // Convert the flamelink object to a response object if required
  switch (flamelinkSchema) {
    case "users":
      relationshipPromises.push(ProfileMapper.convertFlamelinkObjectToProfile(context, uid, obj).then((profile) => {
        if (profile) {
          responseEntities[flamelinkSchema].push(profile);
        }
      }).catch(() => null));
      break;
    case "activities":
      relationshipPromises.push(ActivityMappers.mutateResponseEntitiesWithActivity(context, uid, obj, responseEntities, walk, visited, maxDepth, currentDepth));
      break;
    default:
      responseEntities[flamelinkSchema].push(obj);
      break;
  }

  visited.delete(obj);

  return Promise.all(relationshipPromises).then(() => responseEntities);
}
