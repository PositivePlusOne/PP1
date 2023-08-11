import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { UserService } from "../services/user_service";
import { MentionJSON } from "../dto/mentions";
import { MentionHelpers } from "../helpers/mention_helpers";
import { MediaJSON } from "../dto/media";
import { StorageService } from "../services/storage_service";
import { ActivitiesService } from "../services/activities_service";
import { CommentHelpers } from "../helpers/comment_helpers";
import { CommentJSON } from "../dto/comments";
import { CommentsService } from "../services/comments_service";
import { FeedService } from "../services/feed_service";

export namespace CommentEndpoints {
    export const postComment = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const activityId = request.data.activityId;
        // const reactionId = request.data.reactionId;
        const comtent = request.data.content || "";
        const mentions = request.data.mentions || [] as MentionJSON[];
        const media = request.data.media || [] as MediaJSON[];

        // Mention verification
        MentionHelpers.verifyMentionSchemasValid(mentions);
        await MentionHelpers.verifyMentionsExist(mentions);

        // Media verification
        const mediaBucketPaths = StorageService.getBucketPathsFromMediaArray(media);
        await StorageService.verifyMediaPathsContainsData(mediaBucketPaths);

        // Activity verification
        await ActivitiesService.verifyActivityExists(activityId);

        // Comment verification
        CommentHelpers.verifyCommentLength(comtent);

        // Build comment
        const commentJSON = {
            content: comtent,
            activityId: activityId,
            senderId: uid,
            mentions: mentions,
            media: media,
        } as CommentJSON;

        // Create and response
        const streamClient = await FeedService.getFeedsClient();
        const responseComment = await CommentsService.addComment(commentJSON, streamClient);
        return buildEndpointResponse(context, {
            sender: uid,
            data: [responseComment],
          });
    });

    export const updateComment = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const activityId = request.data.activityId;
        // const reactionId = request.data.reactionId;
        const commentId = request.data.commentId || "";
        const content = request.data.content || "";
        const mentions = request.data.mentions || [] as MentionJSON[];
        const media = request.data.media || [] as MediaJSON[];

        // Mention verification
        MentionHelpers.verifyMentionSchemasValid(mentions);
        await MentionHelpers.verifyMentionsExist(mentions);

        // Media verification
        const mediaBucketPaths = StorageService.getBucketPathsFromMediaArray(media);
        await StorageService.verifyMediaPathsContainsData(mediaBucketPaths);

        // Activity verification
        await ActivitiesService.verifyActivityExists(activityId);

        // Comment verification
        CommentHelpers.verifyCommentLength(content);

        // Get the current comment and check the sender
        const checkComment = await CommentsService.getComment(commentId);
        if (checkComment.senderId !== uid) {
            throw new functions.https.HttpsError("permission-denied", "You do not have permission to update this comment.");
        }


        // Build comment
        const updatedComment = {
            content: content,
            activityId: activityId,
            senderId: uid,
            mentions: mentions,
            media: media,
        } as CommentJSON;

        const streamClient = await FeedService.getFeedsClient();
        await CommentsService.updateComment(updatedComment, commentId, streamClient);

        return buildEndpointResponse(context, {
            sender: uid,
            data: [updatedComment],
        });
    });

    export const deleteComment = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const commentId = request.data.commentId;

        const comment = await CommentsService.getComment(commentId);
        if (comment.senderId !== uid) {
            throw new functions.https.HttpsError("permission-denied", "You do not have permission to delete this comment.");
        }

        const streamClient = await FeedService.getFeedsClient();
        await CommentsService.deleteComment(commentId, streamClient);

        return buildEndpointResponse(context, {
            sender: uid,
            data: [],
        });
    });

    export const listCommentsForActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const activityId = request.data.activityId;

        const streamClient = await FeedService.getFeedsClient();
        const comments = await CommentsService.listComments(activityId, streamClient, request.limit, request.cursor);

        let cursor = "";
        if (comments.length > 0) {
            const lastComment = comments[comments.length - 1];
            if (lastComment._fl_meta_ && lastComment._fl_meta_.fl_id) {
                cursor = lastComment._fl_meta_.fl_id;
            }
        }

        return buildEndpointResponse(context, {
            sender: uid,
            cursor: cursor,
            limit: request.limit,
            data: comments,
        });
    });
}