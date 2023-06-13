import * as functions from "firebase-functions";

import { adminApp } from "..";
import { UploadType } from "./types/upload_type";

import { v4 as uuidv4 } from "uuid";

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

    functions.logger.log(`Uploading image to ${filePath}`);

    await file.save(buffer, {
      contentType: options.contentType,
      public: true,
      metadata: {
        cacheControl: "public, max-age=31536000",
      },
    });

    return filePath;
  }

  /**
   * Gets the media link for a file in the storage bucket
   * @param {string} filePath The absolute path to the file in the bucket
   * @return {Promise<string>} The media link for the file
   */
  export async function getMediaLinkByPath(filePath: string, thumbnailType = ""): Promise<string> {
    const storage = adminApp.storage();
    const bucket = storage.bucket();

    // Remove the bucket name from the path if it starts with it
    if (filePath.startsWith(bucket.name)) {
      filePath = filePath.substring(bucket.name.length + 1);
    }

    functions.logger.log(`Getting media link for ${filePath}`);

    if (thumbnailType) {
      const splitPath = filePath.split(".");
      splitPath[splitPath.length - 2] += `_${thumbnailType}`;
      const thumbnailPath = splitPath.join(".");
      
      functions.logger.log(`Using thumbnail type for ${thumbnailType}, path is ${thumbnailPath}`);
      const thumbnailFile = bucket.file(thumbnailPath);
      const thumbnailExists = await thumbnailFile.exists();
      if (thumbnailExists) {
        functions.logger.log(`Thumbnail exists, returning media link, ${thumbnailFile.metadata.mediaLink}`);
        return thumbnailFile.metadata.mediaLink;
      }
    }

    const file = bucket.file(filePath);
    const fileExists = await file.exists();
    if (fileExists) {
      functions.logger.log(`File exists, returning media link, ${file.metadata.mediaLink}`);
      return file.metadata.mediaLink;
    }

    functions.logger.log(`File does not exist, returning empty string`);
    return "";
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
