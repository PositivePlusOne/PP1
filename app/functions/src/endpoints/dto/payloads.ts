import * as functions from 'firebase-functions';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import safeJsonStringify from 'safe-json-stringify';
import { CacheService } from '../../services/cache_service';
import { RelationshipService } from '../../services/relationship_service';
import { Activity, ActivityJSON, activitySchemaKey } from '../../dto/activities';
import { Profile, ProfileJSON, profileSchemaKey } from '../../dto/profile';
import { Relationship, relationshipSchemaKey } from '../../dto/relationships';
import { Tag, tagSchemaKey } from '../../dto/tags';
import { TagsService } from '../../services/tags_service';
import { ProfileService } from '../../services/profile_service';
import { Media, MediaThumbnail, MediaType } from '../../dto/media';
import { adminApp } from '../..';
import { ThumbnailType } from '../../services/types/media_type';
import { StorageService } from '../../services/storage_service';

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

export async function buildEndpointResponse(context: functions.https.CallableContext, {
    sender,
    data = [],
    seedData = {},
    cursor = "",
    limit = 0,
}: {
    data?: Record<string, any>[];
    seedData?: Record<string, any>;
    cursor?: string;
    limit?: number;
    sender: string;
}): Promise<string> {
    functions.logger.info(`Building endpoint response for ${context.rawRequest.url}.`, {
        sender,
        data,
        seedData,
        cursor,
        limit,
    });

    const responseData = {
        cursor: cursor,
        limit: limit,
        data: seedData,
    } as EndpointResponse;

    const promises = [] as Promise<any>[];
    for (const obj of data) {
        const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(obj);
        const schema = FlamelinkHelpers.getFlamelinkSchemaFromObject(obj);

        // Skip if no flamelink id or schema
        if (!flamelinkId || !schema) {
            continue;
        }

        if (responseData.data[schema] === undefined) {
            responseData.data[schema] = [];
        }

        switch (schema) {
            case activitySchemaKey:
                promises.push(injectActivityIntoEndpointResponse(sender, obj, responseData));
                break;
            case profileSchemaKey:
                promises.push(injectProfileIntoEndpointResponse(sender, obj, responseData));
                break;
            case relationshipSchemaKey:
                functions.logger.debug(`Injecting relationship into endpoint response.`, { sender, obj, responseData });
                responseData.data[schema].push(new Relationship(obj));
                break;
            case tagSchemaKey:
                functions.logger.debug(`Injecting tag into endpoint response.`, { sender, obj, responseData });
                responseData.data[schema].push(new Tag(obj));
                break;
            default:
                functions.logger.error(`Cannot handle schema in response ${schema}.`);
                break;
        }
    }

    await Promise.all(promises);

    return safeJsonStringify(responseData);
}

export async function injectActivityIntoEndpointResponse(sender: string, data: any, responseData: EndpointResponse): Promise<void> {
    functions.logger.debug(`Injecting activity into endpoint response.`, { sender, data, responseData });

    const activity = new Activity(data as ActivityJSON);
    const presenterId = activity.publisherInformation?.foreignKey;
    const promises = [] as Promise<any>[];

    if (presenterId && presenterId !== sender) {
        promises.push(ProfileService.getProfile(presenterId).then((profile) => {
            if (profile) {
                responseData.data.users.push(profile);
            }
        }));

        promises.push(RelationshipService.getRelationship([presenterId, sender]).then((relationship) => {
            if (relationship) {
                responseData.data.relationships.push(relationship);
            }
        }));
    }

    for (const tag of activity.enrichmentConfiguration?.tags || []) {
        promises.push(TagsService.getTag(tag).then((tag) => {
            if (tag) {
                responseData.data.tags.push(tag);
            }
        }));
    }

    await Promise.all(promises);

    responseData.data.activities.push(activity);
}

export async function injectProfileIntoEndpointResponse(sender: string, data: any, responseData: EndpointResponse): Promise<void> {
    functions.logger.debug(`Injecting profile into endpoint response.`, { sender, data, responseData });

    const profile = new Profile(data as ProfileJSON);
    const profileId = profile._fl_meta_?.id || "";
    const hasSender = sender && sender.length > 0;
    const isSenderProfile = hasSender && profileId === sender;
    const promises = [] as Promise<any>[];

    if (!isSenderProfile) {
        profile.removePrivateData();
        profile.removeFlaggedData();
    }

    if (!isSenderProfile && hasSender) {
        promises.push(RelationshipService.getRelationship([profileId, sender]).then((relationship) => {
            if (relationship) {
                responseData.data.relationships.push(relationship);
            }
        }));
    }

    for (const media of profile.media || []) {
        if (media.type !== MediaType.bucket_path) {
            continue;
        }

        promises.push(resolveBucketPathFromMedia(media));
    }

    await Promise.all(promises);

    responseData.data.users.push(profile);
}

export async function resolveBucketPathFromMedia(data: Media): Promise<void> {
    const bucketPath = data.url || "";
    if (!bucketPath || bucketPath.indexOf("/") === -1) {
        return;
    }

    const cacheKey = CacheService.generateCacheKey({
        schemaKey: 'media',
        entryId: bucketPath,
    });

    const cachedData = await CacheService.getFromCache(cacheKey);
    if (cachedData) {
        data.url = cachedData.url;
        data.thumbnails = cachedData.thumbnails;
        return;
    }

    const storage = adminApp.storage();
    const bucket = storage.bucket();
    const file = bucket.file(bucketPath);

    const expiryDate = new Date();
    expiryDate.setDate(expiryDate.getDate() + 1);
    expiryDate.setMinutes(expiryDate.getMinutes() + 5);

    // Check if file exists
    const [exists] = await file.exists();
    if (!exists) {
        return;
    }

    const [metadata] = await file.getMetadata();
    const url = await file.getSignedUrl({
        action: 'read',
        expires: expiryDate,
    }).then((urls) => urls[0]);

    const thumbnails = [] as MediaThumbnail[];
    const fileName = file.name.split('/').pop() || "";
    const fileNameWithoutExtension = fileName.split('.').shift() || "";
    const fileNameExtension = fileName.split('.').pop() || "";
    const folderPath = bucketPath.split('/').slice(0, -1).join('/');
    const thumbnailPromises = [] as Promise<any>[];

    if (metadata.contentType?.startsWith('image/')) {
        // Loop over the ThumbnailType enum
        for (const thumbnailType in ThumbnailType) {
            const fileSuffix = StorageService.getThumbnailSuffix(thumbnailType as ThumbnailType);
            const thumbnailSize = StorageService.getThumbnailSize(thumbnailType as ThumbnailType);
            const thumbnailFileName = `${fileNameWithoutExtension}${fileSuffix}.${fileNameExtension}`;
            const thumbnailFilePath = `${folderPath}/${thumbnailFileName}`;
            const thumbnailFile = bucket.file(thumbnailFilePath);

            // Check if file exists
            const [thumbnailExists] = await thumbnailFile.exists();
            if (!thumbnailExists) {
                continue;
            }

            thumbnailPromises.push(thumbnailFile.getSignedUrl({
                action: 'read',
                expires: expiryDate,
            }).then((urls) => urls[0]).then((thumbnailUrl) => {
                thumbnails.push({
                    width: thumbnailSize,
                    height: thumbnailSize,
                    url: thumbnailUrl,
                });
            }));
        }
    }

    await Promise.all(thumbnailPromises);

    data.url = url;
    data.thumbnails = thumbnails;

    await CacheService.setInCache(cacheKey, data, 60 * 60 * 24);
}