import * as functions from "firebase-functions";

import { Timestamp } from "firebase-admin/firestore";

import { Activity, ActivityGeneralConfigurationStyle, ActivityGeneralConfigurationType, ActivityPricingExternalStoreInformationPricingStrategy, ActivitySecurityConfigurationMode, MEDIA_PRIORITY_DEFAULT, MEDIA_PRIORITY_MAX, MediaType } from "../dto/activities";

import { OccasionGeniusEvent } from "../dto/events";
import { CacheService } from "../services/cache_service";
import { adminApp } from "..";
import { resolveTag } from "../dto/tag";
import { ProfileService } from "../services/profile_service";
import { convertFlamelinkObjectToResponse } from "./response_mappers";

export namespace ActivityMappers {
  /**
   * Converts OccasionGeniusEvents to Activities.
   * @param {OccasionGeniusEvent[]} occasionGeniusEvents the OccasionGeniusEvents to convert.
   * @return {Activity[]} the converted Activities.
   */
  export function convertOccasionGeniusEventsToActivities(occasionGeniusEvents: OccasionGeniusEvent[]): Activity[] {
    const activities: Activity[] = [];
    for (const occasionGeniusEvent of occasionGeniusEvents) {
      activities.push(convertOccasionGeniusEventToActivity(occasionGeniusEvent));
    }

    return activities;
  }

  /**
   * Converts an OccasionGeniusEvent to an Activity.
   * @param {OccasionGeniusEvent} occasionGeniusEvent the OccasionGeniusEvent to convert.
   * @return {Activity} the converted Activity.
   */
  export function convertOccasionGeniusEventToActivity(occasionGeniusEvent: OccasionGeniusEvent): Activity {
    const activity: Activity = {
      foreignKey: occasionGeniusEvent.uuid,
      generalConfiguration: {
        type: ActivityGeneralConfigurationType.Event,
        style: ActivityGeneralConfigurationStyle.Text,
        content: occasionGeniusEvent.description,
      },
      securityConfiguration: {
        context: occasionGeniusEvent.uuid,
        visibilityMode: ActivitySecurityConfigurationMode.Public,
        reactionMode: ActivitySecurityConfigurationMode.Public,
        shareMode: ActivitySecurityConfigurationMode.Public,
      },
      publisherInformation: {
        foreignKey: occasionGeniusEvent.uuid || "",
      },
      eventConfiguration: {
        venue: occasionGeniusEvent.venue?.uuid || "",
        name: occasionGeniusEvent.name,
        schedule: {
          startDate: Timestamp.fromDate(new Date(occasionGeniusEvent.start_date)),
          endDate: Timestamp.fromDate(new Date(occasionGeniusEvent.end_date)),
          reoccuranceRule: occasionGeniusEvent.rrule,
        },
        location: occasionGeniusEvent.venue?.address_1 || "",
        popularityScore: occasionGeniusEvent.popularity_score,
        isCancelled: (occasionGeniusEvent.cancelled?.length ?? 0) > 0,
      },
      pricingInformation: {
        productId: "", // OccasionGenius only supplies a URL to the ticketing site
        externalStoreInformation: {
          costExact: occasionGeniusEvent.minimum_price,
          costMinimum: occasionGeniusEvent.minimum_price,
          costMaximum: occasionGeniusEvent.maximum_price,
          pricingStrategy: ActivityPricingExternalStoreInformationPricingStrategy.OnePerson,
        },
      },
      enrichmentConfiguration: {
        title: occasionGeniusEvent.name,
        tags: occasionGeniusEvent.flags || [],
        publishLocation: null, // Not available in OccasionGeniusEvent
        isSensitive: false, // TODO(ryan): Chase up a list of sensitivity flags from OccasionGenius
        mentions: [], // Not available in OccasionGeniusEvent
      },
      media: [
        {
          type: MediaType.WebsiteLink,
          url: occasionGeniusEvent.source_url,
          priority: MEDIA_PRIORITY_DEFAULT,
        },
        {
          type: MediaType.TicketLink,
          url: occasionGeniusEvent.ticket_url,
          priority: MEDIA_PRIORITY_DEFAULT,
        },
        {
          type: MediaType.PhotoLink,
          url: occasionGeniusEvent.image_url,
          priority: MEDIA_PRIORITY_MAX,
        },
      ],
    };

    return activity;
  }

  /**
   * Mutates the response entities with activity tags.
   * @param {functions.https.CallableContext} {context} the context of the request.
   * @param {string} {uid} the uid of the user.
   * @param {Record<string, any>} {obj} the object to mutate.
   * @param {Record<string, any>} {responseEntities} the response entities to mutate.
   * @return {Promise<Record<string, any>>} the mutated response entities.
   */
  export async function mutateResponseEntitiesWithActivity(context: functions.https.CallableContext, uid: string, obj: Record<string, any>, responseEntities: Record<string, any> = {}, walk = true, visited = new Set(), maxDepth = 5, currentDepth = 0): Promise<Record<string, any>> {
    if (responseEntities["activities"] === undefined) {
      responseEntities["activities"] = [];
    }

    if (responseEntities["tags"] === undefined) {
      responseEntities["tags"] = [];
    }

    const promises = [] as Promise<any>[];

    const tagReferences = Array.from(new Set(obj?.enrichmentConfiguration?.tags || []));

    if (tagReferences.length > 0) {
      obj.enrichmentConfiguration.tags = [];
    }

    // Resolve tags
    for (const activityTag of tagReferences) {
      const resolveActivity = async (activityTag: any) => {
        if (!activityTag) {
          return;
        }

        const segments = activityTag?._path?.segments || [];
        if (!segments || segments.length < 2) {
          return;
        }

        const tagPath: string | undefined = segments.join("/") || undefined;
        const tagId = segments[segments.length - 1];
        const tagsCachePath = CacheService.generateCacheKey({
          entryId: tagId,
          schemaKey: "tags",
        });

        if (!tagPath || !tagId || !tagsCachePath) {
          return;
        }

        obj.enrichmentConfiguration.tags.push(tagId);

        const tagRecord = await CacheService.getFromCache(tagsCachePath);
        if (tagRecord) {
          responseEntities["tags"].push(tagRecord);
          return;
        }

        const tagDocument = adminApp.firestore().doc(tagPath);
        const tagSnapshot = await tagDocument.get();
        if (tagSnapshot.exists) {
          const tagSnapshotData = tagSnapshot.data();
          const tag = resolveTag(tagSnapshotData);
          if (tag) {
            responseEntities["tags"].push(tag);
            CacheService.setInCache(tagsCachePath, tag);
          }
        }
      };

      promises.push(resolveActivity(activityTag));
    }

    // Resolve venue
    const venueReference = obj?.eventConfiguration?.venue;
    if (venueReference) {
      const resolveVenue = async (venueReference: any) => {
        const venuePath = venueReference?._path?.segments?.join("/") || undefined;
        const venueId = venueReference?._path?.segments?.[1] || undefined;
        const venuesCachePath = CacheService.generateCacheKey({
          entryId: venueId,
          schemaKey: "venues",
        });

        if (venuePath && venueId && venuesCachePath) {
          const venueRecord = await CacheService.getFromCache(venuesCachePath);
          if (venueRecord) {
            responseEntities["venues"] = [venueRecord];
          } else {
            const venueDocument = adminApp.firestore().doc(venuePath);
            const venueSnapshot = await venueDocument.get();
            if (venueSnapshot.exists) {
              const venueData = venueSnapshot.data();
              if (venueData) {
                responseEntities["venues"] = [venueData];
                CacheService.setInCache(venuesCachePath, venueData);
              }
            }
          }

          obj.eventConfiguration.venue = venueId;
        }
      };

      promises.push(resolveVenue(venueReference));
    }

    // Resolve publisher
    const publisherReference = obj?.publisherInformation?.foreignKey;
    if (publisherReference) {
      const resolvePublisher = async (publisherReference: any) => {
        const publisherProfile = await ProfileService.getProfile(publisherReference);
        if (!publisherProfile) {
          return;
        }

        await convertFlamelinkObjectToResponse(context, uid, publisherProfile, responseEntities, walk, visited, maxDepth, currentDepth + 1);
      };

      promises.push(resolvePublisher(publisherReference));
    }

    await Promise.all(promises);

    responseEntities["activities"].push(obj);

    return responseEntities;
  }
}
