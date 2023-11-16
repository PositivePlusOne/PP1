import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA_256 } from "../constants/domain";
import { UserService } from "../services/user_service";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { CacheService } from "../services/cache_service";
import { SystemService } from "../services/system_service";

export namespace HealthEndpoints {
    export const MAXIMUM_UPDATE_REQUESTS = 100;

    export const updateLocalCache = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA_256).https.onCall(async (request: EndpointRequest, context) => {
        await SystemService.validateUsingRedisUserThrottle(context);
        functions.logger.info("Updating local cache", { request, context });

        const data = request.data = request.data || {};
        const requestIds = data.requestIds || [];

        if (!requestIds.length) {
            functions.logger.info("No request IDs provided, skipping local cache update");
            return;
        }

        if (requestIds.length > MAXIMUM_UPDATE_REQUESTS) {
            throw new functions.https.HttpsError("invalid-argument", `Too many request IDs provided, maximum is ${MAXIMUM_UPDATE_REQUESTS}`);
        }

        const uid = context.auth?.uid || "";
        let sender = "";
        if (uid) {
            sender = await UserService.verifyAuthenticated(context);
        }

        const cacheData = await CacheService.getMultipleFromCache(requestIds) || [];

        return buildEndpointResponse(context, {
            sender,
            data: [...cacheData],
        });
    });
}