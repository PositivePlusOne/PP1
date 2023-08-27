import * as functions from "firebase-functions";

import { FeedName } from "../constants/default_feeds";
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
import { ProfileService } from "../services/profile_service";

export namespace CommentEndpoints {
    export const postComment = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const activityId = request.data.activityId;
        const feed = request.data.feed || FeedName.User;
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

        // Build comment
        const commentJSON = {
            data: content,
            activity_id: activityId,
            user_id: uid,
            mentions: mentions,
            origin: `${feed}:${uid}`,
            media: media,
        } as CommentJSON;

        // Create and response
        const streamClient = FeedService.getFeedsClient();
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
        if (checkComment.user_id !== uid) {
            throw new functions.https.HttpsError("permission-denied", "You do not have permission to update this comment.");
        }

        // Build comment
        const updatedComment = {
            content: content,
            activity_id: activityId,
            user_id: uid,
            mentions: mentions,
            media: media,
        } as CommentJSON;

        const streamClient = FeedService.getFeedsUserClient(uid);
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
        if (comment.user_id !== uid) {
            throw new functions.https.HttpsError("permission-denied", "You do not have permission to delete this comment.");
        }

        const streamClient = FeedService.getFeedsUserClient(uid);
        await CommentsService.deleteComment(commentId, streamClient);

        return buildEndpointResponse(context, {
            sender: uid,
            data: [],
        });
    });

    export const listCommentsForActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const activityId = request.data.activityId;

        functions.logger.log("Listing comments for activity", {
            activityId: activityId,
            limit: request.limit,
            cursor: request.cursor,
            uid: uid,
        });

        if (!activityId) {
            throw new functions.https.HttpsError("invalid-argument", "The activityId is required.");
        }

        const streamClient = FeedService.getFeedsUserClient(uid);
        const comments = await CommentsService.listComments(activityId, streamClient, request.limit, request.cursor);
        functions.logger.info("Comments for activity", { activityId, comments });

        let cursor = "";
        if (comments.length > 0) {
            const lastComment = comments[comments.length - 1];
            if (lastComment._fl_meta_ && lastComment._fl_meta_.fl_id) {
                cursor = lastComment._fl_meta_.fl_id;
                functions.logger.info("Last comment", { lastComment });
            }
        }

        // Get the profiles from the reactions
        const profiles = await ProfileService.getMultipleProfiles(comments.map((comment) => comment.user_id || "").filter((userId) => userId !== ""));
        functions.logger.info("Profiles for comments", { profiles, comments });

        return buildEndpointResponse(context, {
            sender: uid,
            cursor: cursor,
            limit: request.limit,
            data: [profiles, comments],
        });
    });
}