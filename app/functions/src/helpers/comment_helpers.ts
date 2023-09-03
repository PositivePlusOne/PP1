import * as functions from "firebase-functions";

export namespace CommentHelpers {
    export const maximumCommentLength = 1000;

    export function verifyCommentLength(str: string): void {
        if (str.length > maximumCommentLength || str.trim().length === 0) {
            throw new functions.https.HttpsError("invalid-argument", "Comment too long or empty");
        }
    }

}