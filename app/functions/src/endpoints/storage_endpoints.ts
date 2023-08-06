import * as functions from 'firebase-functions';

import { FIREBASE_FUNCTION_INSTANCE_DATA_ONE_INSTANCE } from '../constants/domain';
import { ProfileService } from '../services/profile_service';
import { ProfileJSON } from '../dto/profile';
import { MediaThumbnailJSON } from '../dto/media';
import { DataService } from '../services/data_service';

export namespace StorageEndpoints {
    export const buildThumbnailEntries = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA_ONE_INSTANCE).storage.object().onFinalize(async (event) => {
        functions.logger.info('Checking if thumbnails need to be created');
        const absolutePathParts = event.name?.split('/') || [];

        // Expected folder is /users/${userId}/gallery/thumbnails/${fileName}
        // If the file doesn't match this pattern, we don't need to do anything
        if (absolutePathParts.length < 5) {
            functions.logger.info('Not a gallery image, skipping');
            return;
        }

        const userId = absolutePathParts[1];
        const fileName = absolutePathParts[absolutePathParts.length - 1];
        const isThumbnail = absolutePathParts[absolutePathParts.length - 2] === 'thumbnails';
        const isImage = event.contentType?.startsWith('image') || event.contentType === 'image/jpeg' || event.contentType === 'image/png' || event.contentType === 'image/gif';

        if (!userId || !fileName || !isThumbnail || !isImage) {
            functions.logger.info('Not a gallery image thumbnail, skipping');
            return;
        }

        functions.logger.info(`Updating profile with media thumbnail: ${userId} - ${fileName}`);
        const profile = ProfileService.getProfile(userId) as ProfileJSON;
        if (!profile) {
            functions.logger.info('Profile not found, skipping');
            return;
        }

        // Find the media for the thumbnail, this will be the filename with the thumbnail extension removed (_96x96 etc) (for example, profile_96x96.jpg becomes profile.jpg)
        const media = profile.media || [];
        const mediaIndex = media.findIndex((m) => m.bucketPath === fileName.replace(/_\d+x\d+/, ''));
        const thumbnailWidth = parseInt(fileName.split('_')[1].split('x')[0]) || -1;
        const thumbnailHeight = parseInt(fileName.split('_')[1].split('x')[1]) || -1;

        if (mediaIndex < 0) {
            functions.logger.info('Media not found, skipping');
            return;
        }

        // Get the signed url of the new thumbnail
        const mediaItem = media[mediaIndex];
        const thumbnail = {
            type: 'image',
            bucketPath: event.name || '',
            width: thumbnailWidth,
            height: thumbnailHeight,
        } as MediaThumbnailJSON;

        mediaItem.thumbnails ??= [];
        mediaItem.thumbnails?.push(thumbnail);

        // Replace the media item in the profile
        media[mediaIndex] = mediaItem;

        // Update the profile
        await DataService.updateDocument({
            schemaKey: "users",
            entryId: userId,
            data: {
                media,
            },
        });
    });
}