import * as functions from 'firebase-functions';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { ActivityMappers } from '../../mappers/activity_mappers';
import safeJsonStringify from 'safe-json-stringify';
import { StringHelpers } from '../../helpers/string_helpers';
import { CacheService } from '../../services/cache_service';
import { RelationshipService } from '../../services/relationship_service';

export type EndpointRequest = {
    sender: string;
    cursor: string;
    limit: number;
    data: Record<string, any>;
};

export type EndpointResponse = {
    data: Record<string, any>;
    cursor: string;
    limit: number;
};

// const visibleFlags = user.visibilityFlags;
//         const connectedUser: ConnectedUserDto = {
//           id: user._fl_meta_.fl_id,
//           displayName: user.displayName,
//           accentColor: user.accentColor,
//           profileImage: await StorageService.getMediaLinkByPath(user.profileImage, ThumbnailType.Medium),
//           ...(visibleFlags.includes("birthday") ? { birthday: user.birthday } : {}),
//           ...(visibleFlags.includes("genders") ? { genders: user.genders } : {}),
//           ...(visibleFlags.includes("hiv_status") ? { hivStatus: user.hivStatus } : {}),
//           ...(visibleFlags.includes("interests") ? { interests: user.interests } : {}),
//           ...(visibleFlags.includes("location") ? { place: user.place } : {}),
//         };

export async function buildEndpointResponse(context: functions.https.CallableContext, options = {
    data: [] as Record<string, any>[],
    cursor: "" as string,
    limit: 0 as number,
    sender: "" as string,
}): Promise<any> {
    if (!options.sender) {
        options.sender = context.auth?.uid || "";
    }

    const responseData = {
        data: {} as Record<string, any>,
        cursor: options.cursor,
        limit: options.limit,
    };

    const promises = [] as Promise<any>[];
    for (const data of options.data) {
        const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(data);
        const schema = FlamelinkHelpers.getFlamelinkSchemaFromObject(data);

        // Skip if no flamelink id or schema
        if (!flamelinkId || !schema) {
            continue;
        }

        // Check the schema exists in the response data
        if (!responseData.data[schema]) {
            responseData.data[schema] = [];
        }

        // Check for any known relationships
        if (options.sender && schema !== "relationships") {
            promises.push(RelationshipService.getRelationship([options.sender, flamelinkId]).then((relationship) => {
                if (relationship) {
                    responseData.data.relationships.push(relationship);
                }
            }));
        }

        switch (schema) {
            case "activities":
                break;
            case "users":
                break;
            default:
                // Assume data is open and public
                responseData.data[schema].push(data);
                break;
        }
    }

    await Promise.all(promises);

    return safeJsonStringify(responseData);
}