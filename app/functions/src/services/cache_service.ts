import * as functions from 'firebase-functions';
import * as redis from 'ioredis';
import { applicationConfig } from '..';
import { FlamelinkHelpers } from '../helpers/flamelink_helpers';

export namespace CacheService {
    // This function generates a cache key based on a schema key and an entry ID.
    export const generateCacheKey = (options: { schemaKey: string; entryId: string }): string => `${options.schemaKey}_${options.entryId}`;

    let redisClient: redis.Redis | undefined;

    /**
     * This function gets the Redis client.
     * @return {Promise<redis.Redis>} the Redis client.
     */
    export async function getRedisClient(): Promise<redis.Redis> {
        if (redisClient) {
            functions.logger.info('Redis client already exists.');
            return redisClient;
        }

        const redisHost = applicationConfig.redis_host;
        const redisPort = parseInt(applicationConfig.redis_port);

        if (!redisHost || !redisPort) {
            throw new Error('Cache not currently available, missing configuration.');
        }

        functions.logger.info(`Connecting to Redis at ${redisHost}:${redisPort}.`);
        redisClient = new redis.Redis(redisPort, redisHost, {
            commandTimeout: 10000,
        });

        return redisClient;
    }

    /**
     * This function sets a value in the Redis cache.
     * @param {string} key the key to set.
     * @param {Record<String, any>} value the value to set.
     * @param {number} [expirationTime=60 * 60 * 24] the expiration time in seconds. Default is 24 hours.
     */
    export async function setInCache(key: string, value: Record<string, any>, expirationTime = 60 * 60 * 24): Promise<void> {
        const redisClient = await getRedisClient();
        await redisClient.set(key, JSON.stringify(value), 'EX', expirationTime);
        functions.logger.info(`Set ${key} in cache.`);
    }

    /**
     * This function gets a value from the Redis cache.
     * @param {string} key the key to get.
     * @return {Promise<Record<string, any> | null>} the value from the cache, or null if it doesn't exist.
     */
    export async function getFromCache(key: string): Promise<Record<string, any> | null> {
        const redisClient = await getRedisClient();
        const value = await redisClient.get(key);
        functions.logger.info(`Got ${key} from cache.`);

        if (!value) {
            return null;
        }

        const parsedValue = JSON.parse(value);
        const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(parsedValue);
        if (!flamelinkId) {
            return null;
        }

        return parsedValue;
    }

    /**
     * This function deletes a value from the Redis cache.
     * @param {string} key the key to delete.
     */
    export async function deleteFromCache(key: string): Promise<void> {
        const redisClient = await getRedisClient();
        await (redisClient).del(key);
        functions.logger.info(`Deleted ${key} from cache.`);
    }

    /**
     * This function deletes all values from the Redis cache that start with a prefix.
     * @param {string} prefix the prefix to delete.
     * @return {Promise<void>} a promise that resolves when the values have been deleted.
     */
    export async function deletePrefixedFromCache(prefix: string): Promise<void> {
        const redisClient = await getRedisClient();
        const keys = await redisClient.keys(`${prefix}*`);
        if (!keys || keys.length === 0) {
            return;
        }
        
        await redisClient.del(...keys);
        functions.logger.info(`Deleted ${keys.length} keys from cache.`);
    }

    /**
     * This function deletes all values from the Redis cache.
     */
    export async function deleteAllFromCache(): Promise<void> {
        const redisClient = await getRedisClient();
        await redisClient.flushall();
        functions.logger.info(`Deleted all keys from cache.`);
    }
}
