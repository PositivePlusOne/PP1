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
      uploadType: UploadType.None,
      extension: "o",
      contentType: "application/octet-stream",
    }
  ): Promise<string> {
    const storage = adminApp.storage();
    const bucket = storage.bucket();
    const uuid = uuidv4();
    const filePath = `users/${userId}/${options.uploadType}/${uuid}.${options.extension}`;
    const file = bucket.file(filePath);

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
  export async function getMediaLinkByPath(filePath: string): Promise<string> {
    const storage = adminApp.storage();
    const bucket = storage.bucket();

    // Remove the bucket name from the path if it starts with it
    if (filePath.startsWith(bucket.name)) {
      filePath = filePath.substring(bucket.name.length + 1);
    }

    const file = bucket.file(filePath);

    if (!(await file.exists())) {
      return "";
    }

    return file.metadata.mediaLink;
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
