import * as functions from "firebase-functions";

import { adminApp } from "..";
import { MediaJSON } from "../dto/media";

export namespace StorageService {

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
   * Formats a bucket path to be used in a URL
   * @param {string} path The bucket path
   * @return {string} The formatted bucket path
   */
  export function formatBucketPath(path: string): string {
    if (path.startsWith("/")) {
      path = path.substring(1);
    }

    path = encodeURI(path);

    return path;
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

  /**
   * Verifies that a list of paths contain data in the storage bucket
   * @param {string[]} paths The list of paths to verify
   * @return {Promise<void>} A promise that resolves when the verification is complete
   */
  export async function verifyMediaPathsContainsData(paths: string[]): Promise<void> {
    const storage = adminApp.storage();
    const bucket = storage.bucket();
    const filePromises = paths.map((path) => bucket.file(path).download());

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

  export function getMimeTypeFromBytes(arrayBuffer: ArrayBuffer) {
    const uint8arr = new Uint8Array(arrayBuffer);

    const len = 4;
    if (uint8arr.length >= len) {
      const signatureArr = new Array(len);
      for (let i = 0; i < len; i++) {
        signatureArr[i] = (new Uint8Array(arrayBuffer))[i].toString(16);
      }
        
      const signature = signatureArr.join('').toUpperCase();
      switch (signature) {
        case '89504E47':
          return 'image/png';
        case '47494638':
          return 'image/gif';
        case '25504446':
          return 'application/pdf';
        case 'FFD8FFDB':
        case 'FFD8FFE0':
          return 'image/jpeg';
        case '504B0304':
          return 'application/zip';
        default:
          break;
      }
    }

    return 'application/octet-stream';
  }

  export function getExtensionFromMime(mime: string): string {
    if (!mime.includes("/")) {
      return ".bin";
    }

    const parts = mime.split("/");
    return parts[1];
  }
}
