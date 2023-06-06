import * as functions from "firebase-functions";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { ProfileMapper } from "./profile_mappers";
import { RelationshipService } from "../services/relationship_service";
import { StringHelpers } from "../helpers/string_helpers";
import { adminApp } from "..";

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
    functions.logger.log("Object is null or has been visited, returning responseEntities.", { obj, visited });
    return responseEntities;
  }

  if (maxDepth > 0 && currentDepth > maxDepth) {
    functions.logger.log("Max depth reached, returning responseEntities.", { obj, visited });
    return responseEntities;
  }

  visited.add(obj);

  // If object is an array, create a Promise for each item.
  if (Array.isArray(obj)) {
    const promises = obj.map(async (item) => {
      functions.logger.log("Array detected, converting item to response.");
      return await convertFlamelinkObjectToResponse(context, uid, item, responseEntities, walk, visited, maxDepth, currentDepth + 1);
    });

    // Wait for all Promises to resolve.
    await Promise.all(promises);

    // Return the array of responses.
    return responseEntities;
  }

  // Loop through each property in the object.
  for (const property in obj) {
    if (!Object.prototype.hasOwnProperty.call(obj, property)) {
      functions.logger.log("Property does not exist, continuing.");
      continue;
    }

    // Check if the property is an object. If not, continue.
    if (typeof obj[property] !== "object" || obj[property] === null) {
      functions.logger.log("Property is not an object, continuing.");
      continue;
    }

    // If property is a DocumentReference, fetch the document.
    if (obj[property]._firestore !== undefined && obj[property]._firestore !== null) {
      functions.logger.log("Property is a DocumentReference, getting the document.");
      const path = obj[property].path || "";

      if (!path) {
        functions.logger.log("Path is empty, setting property to empty string.");
        obj[property] = obj[property].path || "";
        continue;
      }

      try {
        if (!walk) {
          functions.logger.log("Walk is false, setting property to path.");
          obj[property] = path;
          continue;
        }

        functions.logger.log("Walk is true, getting document from path.", { path });
        const document = await adminApp.firestore().doc(path).get();
        if (document.exists) {
          const documentData = document.data();
          const documentRecord = { ...documentData } as Record<string, any>;

          const isValidFlamelinkObject = FlamelinkHelpers.isValidFlamelinkObject(documentData);
          if (!isValidFlamelinkObject) {
            obj[property] = document.id || "";
            continue;
          }

          // Convert the flamelink object to a response object.
          const documentId = FlamelinkHelpers.getFlamelinkIdFromObject(documentData);
          promises.push(convertFlamelinkObjectToResponse(context, uid, documentRecord, responseEntities, walk, visited, maxDepth, currentDepth + 1));

          // Set the property to the fl_id.
          obj[property] = documentId;
        }
      } catch (err) {
        console.error(`Failed to get document for property:`, err);
        obj[property] = "";
      }
    } else {
      // If the property is a nested object, recursively walk through it.
      promises.push(convertFlamelinkObjectToResponse(context, uid, obj[property], responseEntities, walk, visited, maxDepth, currentDepth + 1));
    }
  }
  
  await Promise.all(promises);

  const flamelinkSchema = FlamelinkHelpers.getFlamelinkSchemaFromObject(obj);
  const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(obj);

  functions.logger.log("Flamelink schema and id detected.", { obj, flamelinkSchema, flamelinkId });

  // Check if the schema and id are empty.
  if (!flamelinkSchema || !flamelinkId) {
    functions.logger.log("Schema or id is empty, returning responseEntities.", obj);
    return responseEntities;
  }

  // Checks relationships for the object.
  functions.logger.log("Checking relationships for the object.");
  if (!responseEntities["relationships"] || !Array.isArray(responseEntities["relationships"])) {
    functions.logger.log("Relationships does not exist, creating it.");
    responseEntities["relationships"] = [];
  }

  // Append the relationship to the object if it does not exist.
  const members = [uid, flamelinkId];
  const relationshipName = StringHelpers.generateDocumentNameFromGuids(members);

  // Check if the relationship already exists.
  if (relationshipName.length > 0 && !responseEntities["relationships"].find((r: any) => FlamelinkHelpers.getFlamelinkIdFromObject(r) === relationshipName) && uid !== flamelinkId) {
    functions.logger.log("Relationship does not exist, appending it.");
    const relationship = await RelationshipService.getRelationship(members);
    responseEntities["relationships"].push(relationship);
  }

  // Create the schema array if it does not exist.
  if (!responseEntities[flamelinkSchema] || !Array.isArray(responseEntities[flamelinkSchema])) {
    functions.logger.log("Schema does not exist, creating it.", { flamelinkSchema });
    responseEntities[flamelinkSchema] = [];
  }

  // Convert the flamelink object to a response object if required
  functions.logger.log("Converting the flamelink object to a response object.");
  switch (flamelinkSchema) {
    case "users":
      try {
        const overrideObj = await ProfileMapper.convertFlamelinkObjectToProfile(context, uid, obj);
        responseEntities[flamelinkSchema].push(overrideObj);
      } catch (err) {
        functions.logger.error(`Failed to convert flamelink object to profile:`, err);
      }
      break;
    default:
      functions.logger.log("Schema not found, returning responseEntities.", { flamelinkSchema, obj });
      responseEntities[flamelinkSchema].push(obj);
      break;
  }

  visited.delete(obj);

  return responseEntities;
}
