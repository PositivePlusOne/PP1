import * as functions from 'firebase-functions';

import { FlamelinkHelpers } from '../helpers/flamelink_helpers';
import { ProfileMapper } from './profile_mappers';
import { DocumentReference } from 'firebase-admin/firestore';
import { RelationshipService } from '../services/relationship_service';
import { mergeMapOfArrays } from '../helpers/array_helpers';

/**
 * Converts a Flamelink object to a response object.
 * @param {functions.https.CallableContext} context The context of the request
 * @param {string} uid The uid of the user
 * @param {any} obj The object to convert
 * @param {boolean} walk Whether to walk through the object
 * @return {any} The response object
 */
export async function convertFlamelinkObjectToResponse(
    context: functions.https.CallableContext,
    uid: string,
    obj: any,
    responseEntities: any = {},
    walk = true,
): Promise<any> {
    if (obj == null) {
        return responseEntities;
    }

    // Create a copy of the object to avoid modifying the input parameter
    const objCopy = { ...obj };

    // If object is an array, loop through each item.
    if (Array.isArray(objCopy)) {
        for (const item of objCopy) {
            const newResponseEntities = await convertFlamelinkObjectToResponse(context, uid, item, responseEntities, walk);
            responseEntities = mergeMapOfArrays(responseEntities, newResponseEntities);
        }

        return responseEntities;
    }

    const flamelinkSchema = FlamelinkHelpers.getFlamelinkSchemaFromObject(objCopy);
    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(objCopy);

    // Check if the schema and id are empty.
    if (!flamelinkSchema || !flamelinkId) {
        return responseEntities;
    }

    // Check responseEntities for a relationships array.
    if (!responseEntities.relationships) {
        responseEntities.relationships = [];
    }

    // Append the relationship to the object.
    const relationship = await RelationshipService.getRelationship([uid, flamelinkId]);
    responseEntities.relationships.push(relationship);

    // Loop through each property in the object.
    for (const property in objCopy) {
        if (!Object.prototype.hasOwnProperty.call(objCopy, property)) {
            continue;
        }

        if (objCopy[property] instanceof DocumentReference) {
            if (!walk) {
                objCopy[property] = objCopy[property].path || "";
                continue;
            }

            const documentReference = objCopy[property] as DocumentReference;

            try {
                const document = await documentReference.get();

                if (document.exists) {
                    const documentData = document.data();
                    const isValidFlamelinkObject = FlamelinkHelpers.isValidFlamelinkObject(documentData);
                    if (!isValidFlamelinkObject) {
                        continue;
                    }

                    // Convert the flamelink object to a response object.
                    const documentId = FlamelinkHelpers.getFlamelinkIdFromObject(documentData);
                    const newResponseEntities = await convertFlamelinkObjectToResponse(context, uid, documentData, false);
                    responseEntities = mergeMapOfArrays(responseEntities, newResponseEntities);

                    // Set the property to the fl_id.
                    objCopy[property] = documentId;
                }

                // If obj[property] is not a string, then set it to empty.
                if (typeof objCopy[property] !== "string") {
                    objCopy[property] = "";
                }
            } catch (err) {
                console.error(`Failed to get document for property ${property}:`, err);
            }
        }
    }

    switch (flamelinkSchema) {
        case "profiles":
            try {
                const profile = await ProfileMapper.convertFlamelinkObjectToProfile(context, uid, objCopy);
                const profileSchema = FlamelinkHelpers.getFlamelinkSchemaFromObject(profile);
                responseEntities[profileSchema] = profile;
            } catch (err) {
                console.error("Failed to convert flamelink object to profile:", err);
            }
            break;
        default:
            responseEntities[flamelinkSchema] = objCopy;
            break;
    }

    return responseEntities;
}
