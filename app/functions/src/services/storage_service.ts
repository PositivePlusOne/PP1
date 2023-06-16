import * as functions from "firebase-functions";

import { adminApp } from "..";
import { UploadType } from "./types/upload_type";

import { v4 as uuidv4 } from "uuid";
import { CacheService } from "./cache_service";
import { ThumbnailType } from "./types/media_type";

export namespace StorageService {
  /**
   * Uploads an image to the storage bucket for a user
   * @param {Buffer} buffer The buffer of the image
   * @param {string} userId The ID of the user
   * @param {any} options The options for the upload
   * @return {Promise<string>} The absolute path to the file in the bucket
   */
  export async function uploadImageForUser(
    buffer: Buffer,
    userId: string,
    options = {
      fileName: "",
      uploadType: UploadType.None,
      extension: "o",
      contentType: "application/octet-stream",
    }
  ): Promise<string> {
    const storage = adminApp.storage();
    const bucket = storage.bucket();

    if (!options.fileName) {
      options.fileName = uuidv4();
    }

    const filePath = `users/${userId}/${options.uploadType}/${options.fileName}.${options.extension}`;
    const file = bucket.file(filePath);

    functions.logger.log(`Removing ${filePath} from cache`);
    await removeMediaLinkFromCache(filePath);

    functions.logger.log(`Uploading image to ${filePath}`);
    await file.save(buffer, {
      contentType: options.contentType,
    });

    return filePath;
  }

  /**
   * Generates a cache key for a media link
   * @param {string} filePath The absolute path to the file in the bucket
   * @param {ThumbnailType} thumbnailType The type of thumbnail to generate
   * @return {string} The cache key
   */
  export function generateCacheKeyForMediaLink(filePath: string, thumbnailType: string): string {
    if (!thumbnailType) {
      return `mediaLink-${filePath}`;
    }

    return `mediaLink-${filePath}-${thumbnailType}`;
  }

  /**
   * Gets the prefix for a thumbnail type
   * @param {ThumbnailType} type The type of thumbnail
   * @return {string} The prefix for the thumbnail
   */
  export function getThumbnailPrefix(type: ThumbnailType): string {
    switch (type) {
      case ThumbnailType.Small:
        return "64x64";
      case ThumbnailType.Medium:
        return "256x256";
      case ThumbnailType.Large:
        return "512x512";
      default:
        return "";
    }
  }

  /**
   * Removes a media link from the cache
   * @param {string} filePath The absolute path to the file in the bucket
   * @return {Promise<void>} A promise that resolves when the media link has been removed from the cache
   */
  export async function removeMediaLinkFromCache(filePath: string): Promise<void> {
    const cacheKey = generateCacheKeyForMediaLink(filePath, "");
    const promises = [CacheService.deleteFromCache(cacheKey)];


    // Loop over potential thumbnail types and remove them from the cache
    for (const thumbnailType in ThumbnailType) {
      if (isNaN(Number(thumbnailType))) {
        const thumbnailCacheKey = generateCacheKeyForMediaLink(filePath, thumbnailType as ThumbnailType);
        const thumbnailPromise = CacheService.deleteFromCache(thumbnailCacheKey);
        promises.push(thumbnailPromise);
      }
    }

    await Promise.all(promises);
  }

  /**
   * Gets the media link for a file in the storage bucket
   * @param {string} filePath The absolute path to the file in the bucket
   * @return {Promise<string>} The media link for the file
   */
  export async function getMediaLinkByPath(filePath: string, thumbnailType: string): Promise<string> {
    const storage = adminApp.storage();
    const bucket = storage.bucket();

    const cacheKey = generateCacheKeyForMediaLink(filePath, thumbnailType);
    const cachedMediaLink = await CacheService.getFromCache(cacheKey);

    if (cachedMediaLink && cachedMediaLink["url"]) {
      functions.logger.log(`Returning cached media link, ${cachedMediaLink}`);
      return cachedMediaLink["url"];
    }

    // Remove the bucket name from the path if it starts with it
    if (filePath.startsWith(bucket.name)) {
      filePath = filePath.substring(bucket.name.length + 1);
    }

    functions.logger.log(`Getting media link for ${filePath}, thumbnail type is ${thumbnailType}`);
    let imagePath = "";

    // Set an expiry date of tomorrow plus 5 minutes (For the cache expiry)
    const expiryDate = new Date();
    expiryDate.setDate(expiryDate.getDate() + 1);
    expiryDate.setMinutes(expiryDate.getMinutes() + 5);

    if (thumbnailType !== ThumbnailType.None) {
      // Get the string value of the thumbnail type
      const splitPath = filePath.split(".");
      splitPath[splitPath.length - 2] += `_${thumbnailType}`;
      const thumbnailPath = splitPath.join(".");

      functions.logger.log(`Using thumbnail type for ${thumbnailType}, path is ${thumbnailPath}`);
      const thumbnailFile = bucket.file(thumbnailPath);
      const thumbnailExists = await thumbnailFile.exists();

      if (thumbnailExists) {
        functions.logger.log(`Thumbnail exists, returning media link, ${thumbnailFile.metadata.mediaLink}`);
        const response = await thumbnailFile.getSignedUrl({
          action: 'read',
          expires: expiryDate,
        });

        imagePath = response[0];

        await CacheService.setInCache(cacheKey, {
          url: imagePath,
        }, 60 * 60 * 24);
      }
    }

    if (!imagePath) {
      const file = bucket.file(filePath);
      const fileExists = await file.exists();
      if (fileExists) {
        functions.logger.log(`File exists, returning media link, ${file.metadata.mediaLink}`);
        const response = await file.getSignedUrl({
          action: 'read',
          expires: expiryDate,
        });

        imagePath = response[0];
        if (thumbnailType === ThumbnailType.None) {
          await CacheService.setInCache(cacheKey, {
            url: imagePath,
          }, 60 * 60 * 24);
        }
      }
    }

    if (!imagePath) {
      return "";
    }

    return imagePath;
  }

  /**
   * Deletes a file from the storage bucket
   * @param {string} filePath The absolute path to the file in the bucket
   * @return {Promise<void>} A promise that resolves when the file is deleted
   */
  export async function deleteFileByPath(filePath: string): Promise<void> {
    const storage = adminApp.storage();
    const bucket = storage.bucket();

    // Remove the bucket name from the path if it starts with it
    if (filePath.startsWith(bucket.name)) {
      filePath = filePath.substring(bucket.name.length + 1);
    }

    const file = bucket.file(filePath);

    if (!(await file.exists())) {
      return;
    }

    await file.delete();
  }
}
