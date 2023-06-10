import * as functions from 'firebase-functions';
import * as redis from 'ioredis';
import { applicationConfig } from '..';
import { FlamelinkReference } from './types/flamelink_reference';

export namespace CacheService {
    // This function generates a cache key based on a schema key and an entry ID.
    export const generateCacheKey = (options: { schemaKey: string; entryId: string }): string => `${options.schemaKey}_${options.entryId}`;

    let redisClient: redis.Redis | undefined;

    /**
     * Gets the cache key from a Flamelink reference, if the object is a Flamelink reference.
     * @param {any} reference the reference to get the cache key from.
     * @return {string} the cache key.
     */
    export function getCacheKeyFromFlamelineReference(reference: FlamelinkReference): string {
        const segments = reference._path.segments;
        const cacheKey = segments.join('_');
        return cacheKey;
    }

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
     * @param value the value to set.
     */
    export async function setInCache(key: string, value: Record<string, any>): Promise<void> {
        const redisClient = await getRedisClient();
        await redisClient.set(key, JSON.stringify(value));
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

        return value ? JSON.parse(value) : null;
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
}
