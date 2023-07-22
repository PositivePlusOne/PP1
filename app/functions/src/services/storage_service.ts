import * as functions from "firebase-functions";

import { adminApp } from "..";
import { UploadType } from "./types/upload_type";

import { v4 as uuidv4 } from "uuid";
import { MediaJSON } from "../dto/media";

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

    await file.save(buffer, {
      contentType: options.contentType,
    });

    return filePath;
  }

  /**
   * Gets the suffix for a thumbnail type
   * @param {string} type The type of thumbnail
   * @return {string} The suffix for the thumbnail
   */
  export function getThumbnailSuffix(type: string): string {
    switch (type) {
      case "128x128":
        return "_128x128";
      case "256x256":
        return "_256x256";
      case "512x512":
        return "_512x512";
      default:
        return "";
    }
  }

  /**
   * Gets the size for a thumbnail type
   * @param {string} type The type of thumbnail
   * @return {number} The size for the thumbnail
   */
  export function getThumbnailSize(type: string): number {
    switch (type) {
      case "128x128":
        return 64;
      case "256x256":
        return 256;
      case "512x512":
        return 512;
      default:
        return 0;
    }
  }

  /**
   * Gets a list of bucket paths from a list of media
   * @param {MediaJSON[]} mediaJSON The list of media
   * @return {string[]} The list of bucket paths
   */
  export function getBucketPathsFromMediaArray(mediaJSON: MediaJSON[]): string[] {
    return mediaJSON.map((m) => {
      if (!m.bucketPath || !m.url || !m.type) {
        return null;
      }
  
      if (m.type !== "bucket_path") {
        return null;
      }
  
      return m.bucketPath;
    }).filter((m) => m !== null) as string[] || [];
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

  /**
   * Verifies that a list of paths exist in the storage bucket
   * @param {string[]} paths The list of paths to verify
   */
  export async function verifyMediaPathsExist(paths: string[]): Promise<void> {
    const storage = adminApp.storage();
    const bucket = storage.bucket();
    const filePromises = paths.map((path) => bucket.file(path).exists());

    const results = await Promise.all(filePromises);

    for (let i = 0; i < results.length; i++) {
      if (!results[i][0]) {
        throw new functions.https.HttpsError(
          "not-found",
          `File at path ${paths[i]} does not exist`
        );
      }
    }
  }
}
