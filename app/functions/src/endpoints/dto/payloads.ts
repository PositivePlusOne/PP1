import * as functions from 'firebase-functions';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import safeJsonStringify from 'safe-json-stringify';
import { RelationshipService } from '../../services/relationship_service';
import { Activity, ActivityJSON, activitySchemaKey } from '../../dto/activities';
import { Profile, ProfileJSON, profileSchemaKey } from '../../dto/profile';
import { Relationship, relationshipSchemaKey } from '../../dto/relationships';
import { Tag, tagSchemaKey } from '../../dto/tags';
import { TagsService } from '../../services/tags_service';
import { ProfileService } from '../../services/profile_service';
import { Media, MediaJSON, MediaThumbnailJSON } from '../../dto/media';
import { adminApp } from '../..';
import { ThumbnailTypes } from '../../services/types/media_type';
import { StorageService } from '../../services/storage_service';
import { CacheService } from '../../services/cache_service';

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
        data: {
            ...seedData,
            "activities": [],
            "users": [],
            "relationships": [],
            "tags": [],
        },
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

    const newMedia = [] as Media[];
    for (const media of activity.media || []) {
        functions.logger.debug(`Resolving media bucket path.`, { sender, media, responseData });
        if (media.type !== "bucket_path") {
            newMedia.push(media);
            continue;
        }

        promises.push(resolveBucketPathFromMedia(media).then((media) => {
            newMedia.push(new Media(media));
        }));
    }

    await Promise.all(promises);

    activity.media = newMedia;

    responseData.data.activities.push(activity);
}

export async function injectProfileIntoEndpointResponse(sender: string, data: any, responseData: EndpointResponse): Promise<void> {
    functions.logger.debug(`Injecting profile into endpoint response.`, { sender, data, responseData });

    const profile = new Profile(data as ProfileJSON);
    const profileId = profile._fl_meta_?.fl_id || "";
    const hasSender = sender && sender.length > 0;
    const isSenderProfile = hasSender && profileId === sender;
    const promises = [] as Promise<any>[];

    if (!isSenderProfile) {
        functions.logger.debug(`Removing private data from profile.`, { sender, profileId, responseData });
        profile.removePrivateData();
        profile.removeFlaggedData();
    }

    if (profileId && sender && profileId !== sender) {
        functions.logger.debug(`Resolving profile relationship.`, { sender, profileId, responseData });
        promises.push(RelationshipService.getRelationship([profileId, sender]).then((relationship) => {
            if (relationship) {
                responseData.data.relationships.push(relationship);
            }
        }));
    }

    const newMedia = [] as Media[];
    for (const media of profile.media || []) {
        functions.logger.debug(`Resolving media bucket path.`, { sender, media, responseData });
        if (media.type !== "bucket_path") {
            newMedia.push(media);
            continue;
        }

        promises.push(resolveBucketPathFromMedia(media).then((media) => {
            newMedia.push(new Media(media));
        }));
    }

    await Promise.all(promises);

    profile.media = newMedia;

    responseData.data.users.push(profile);
}

export async function resolveBucketPathFromMedia(data: MediaJSON): Promise<MediaJSON> {
    let bucketPath = data.path || "";
    if (!bucketPath || bucketPath.indexOf("/") === -1) {
        functions.logger.debug(`Cannot resolve bucket path from media.`, { data });
        return data;
    }

    if (bucketPath.indexOf("/") === 0) {
        bucketPath = bucketPath.substring(1);
    }

    if (bucketPath.indexOf("gs://") === 0) {
        bucketPath = bucketPath.replace("gs://", "");
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
        functions.logger.debug(`Cannot resolve bucket path from media.`, { data });
        return data;
    }

    const [metadata] = await file.getMetadata();
    functions.logger.debug(`Resolved bucket path from media.`, { data, metadata });

    const cacheKey = `bucket_paths:${bucketPath}`;
    let url = await CacheService.getFromCache(cacheKey);

    if (!url) {
        functions.logger.debug(`Getting signed url for media ${bucketPath}.`);
        url = await file.getSignedUrl({
            action: 'read',
            expires: expiryDate,
        }).then((urls) => urls[0]);

        await CacheService.setInCache(cacheKey, url);
    } else {
        functions.logger.debug(`Getting cached url for media ${bucketPath}.`);
    }

    const thumbnailPromises = [] as Promise<MediaThumbnailJSON | undefined>[];
    for (const type of ThumbnailTypes) {
        const fileSuffix = StorageService.getThumbnailSuffix(type);
        if (!fileSuffix) {
            functions.logger.debug(`Cannot get thumbnail suffix for type ${type}.`);
            continue;
        }

        const thumbnailFilePath = bucketPath.replace(/(\.[\w\d_-]+)$/i, `${fileSuffix}$1`);
        const thumbnailFile = bucket.file(thumbnailFilePath);
        functions.logger.debug(`Checking if thumbnail ${thumbnailFilePath} exists.`);

        // Create a promise for this iteration
        const thumbnailPromise = async () => {
            const [thumbnailExists] = await thumbnailFile.exists();
            if (!thumbnailExists) {
                return;
            }

            const thumbnailCacheKey = `bucket_paths:${thumbnailFilePath}`;
            let thumbnailUrl = await CacheService.getFromCache(thumbnailCacheKey);

            if (!thumbnailUrl) {
                functions.logger.debug(`Getting signed url for thumbnail ${thumbnailFilePath}.`);
                thumbnailUrl = await thumbnailFile.getSignedUrl({
                    action: 'read',
                    expires: expiryDate,
                }).then((urls) => urls[0]);

                await CacheService.setInCache(thumbnailCacheKey, thumbnailUrl);
            }

            return {
                type: type,
                url: thumbnailUrl,
            };
        };

        // Schedule the promise to be run asynchronously
        thumbnailPromises.push(thumbnailPromise());
    }

    // Wait for all promises to resolve
    const thumbnails = await Promise.all(thumbnailPromises);

    data.url = url;
    data.thumbnails = thumbnails.filter((e) => e !== undefined) as MediaThumbnailJSON[];

    return data;
}