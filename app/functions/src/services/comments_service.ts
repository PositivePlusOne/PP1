import * as functions from "firebase-functions";

import { CommentJSON } from "../dto/comments";
import { DataService } from "./data_service";
import { DefaultGenerics, StreamClient } from "getstream";

export namespace CommentsService {

    /**
     * Get a comment.
     * @param {string} commentId The comment ID.
     * @returns {Promise<CommentJSON>} The comment.
     */
    export async function getComment(commentId: string): Promise<CommentJSON> {
        return DataService.getDocument({
            schemaKey: "comments",
            entryId: commentId,
        }) as CommentJSON;
    }

    /**
    * Add a comment to an activity.
    * @param {CommentJSON} comment The comment.
    * @param {StreamClient<DefaultGenerics>} client The Stream client.
    * @returns {Promise<any>} The new comment.
    */
    export async function addComment(comment: CommentJSON, client: StreamClient<DefaultGenerics>): Promise<any> {
        if (!comment.activityId) {
            throw new functions.https.HttpsError("invalid-argument", "Comment must have an activityId");
        }

        const response = await client.reactions.add("comment", comment.activityId, {...comment}, {userId: comment.senderId});

        return await DataService.updateDocument({
            schemaKey: "comments",
            entryId: response.id,
            data: comment,
        });
    }

    /**
     * Update a comment.
     * @param {CommentJSON} comment The comment.
     * @param {string} commentId The comment ID.
     * @param {StreamClient<DefaultGenerics>} client The Stream client.
     * @returns {Promise<void>} A promise that resolves when the comment has been updated.
     */
    export async function updateComment(comment: CommentJSON, commentId: string, client: StreamClient<DefaultGenerics>): Promise<void> {
        await client.reactions.update(commentId, {
            ...comment,
        });

        await DataService.updateDocument({
            schemaKey: "comments",
            entryId: commentId,
            data: comment,
        });
    }

    /**
     * Delete a comment.
     * @param {string} commentId The comment ID.
     * @param {StreamClient<DefaultGenerics>} client The Stream client.
     * @returns {Promise<void>} A promise that resolves when the comment has been deleted.
     */
    export async function deleteComment(commentId: string, client: StreamClient<DefaultGenerics>): Promise<void> {
        await client.reactions.delete(commentId);

        await DataService.deleteDocument({
            schemaKey: "comments",
            entryId: commentId,
        });
    }

    /**
    * List paginated comments associated with a specific activity.
    * 
    * @param {string} activityId ID of the activity to fetch comments for.
    * @param {StreamClient<DefaultGenerics>} client The Stream client.
    * @param {number} limit The number of comments to fetch.
    * @param {string} lastCommentId The ID of the last comment fetched (optional).
    * @returns {Promise<CommentJSON[]>} A promise that resolves to an array of CommentJSON objects.
    */
    export async function listComments(activityForeignKey: string, client: StreamClient<DefaultGenerics>, limit = 10, lastCommentId?: string): Promise<CommentJSON[]> {
        const params: any = {
            activity_id: activityForeignKey,
            kind: 'comment',
            limit: limit,
        };

        if (lastCommentId) {
            params.id_lt = lastCommentId; // fetch comments with IDs less than the provided lastCommentId
        }

        functions.logger.log("params", params);

        const response = await client.reactions.filter(params);
        const responseData = response.results.map((reaction) => {
            const comment = reaction.data as CommentJSON;
            comment._fl_meta_ = {
                schema: "comments",
                fl_id: reaction.id,
                createdDate: reaction.created_at,
            };

            return comment;
        });

        functions.logger.log("Got response", {
            response,
            responseData,
        });
        
        return responseData;
    }
}