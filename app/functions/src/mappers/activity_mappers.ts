import * as functions from "firebase-functions";

import { Timestamp } from "firebase-admin/firestore";

import { Activity, ActivityGeneralConfigurationStyle, ActivityGeneralConfigurationType, ActivityPricingExternalStoreInformationPricingStrategy, ActivitySecurityConfigurationMode, MEDIA_PRIORITY_DEFAULT, MEDIA_PRIORITY_MAX, MediaType } from "../dto/activities";

import { OccasionGeniusEvent } from "../dto/events";
import { CacheService } from "../services/cache_service";
import { adminApp } from "..";
import { resolveTag } from "../dto/tag";

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
  export async function mutateResponseEntitiesWithActivity(context: functions.https.CallableContext, uid: string, obj: Record<string, any>, responseEntities: Record<string, any> = {}): Promise<Record<string, any>> {
    if (responseEntities["activities"] === undefined) {
      responseEntities["activities"] = [];
    }

    if (responseEntities["tags"] === undefined) {
      responseEntities["tags"] = [];
    }

    const promises = [] as Promise<any>[];
    for (const activityTag of obj?.enrichmentConfiguration?.tags || []) {
      const resolveActivity = async (activityTag: any) => {
        if (!activityTag) {
          obj.enrichmentConfiguration.tags = obj.enrichmentConfiguration.tags.filter((tag: any) => tag !== activityTag);
          return;
        }
  
        const segments = activityTag?._path?.segments || [];
        if (!segments || segments.length < 2) {
          obj.enrichmentConfiguration.tags = obj.enrichmentConfiguration.tags.filter((tag: any) => tag !== activityTag);
          return;
        }

        const tagPath: string | undefined = segments.join("/") || undefined;
        const cachePath: string | undefined = segments.join("_") || undefined;
        const tagId = segments[segments.length - 1];
  
        if (!tagId) {
          obj.enrichmentConfiguration.tags = obj.enrichmentConfiguration.tags.filter((tag: any) => tag !== activityTag);
        } else {
          obj.enrichmentConfiguration.tags = obj.enrichmentConfiguration.tags.map((tag: any) => {
            if (tag._path?.segments?.join("_") === tagId) {
              return tag;
            }
  
            return tag;
          });
        }
        
        if (!tagPath || !cachePath || !tagId) {
          return;
        }
  
        const tagRecord = await CacheService.getFromCache(cachePath);
        if (tagRecord) {
          responseEntities["tags"].push(tagRecord);
          return;
        }
  
        const tagDocument = adminApp.firestore().doc(tagPath);
        const tagSnapshot = await tagDocument.get();
        if (tagSnapshot.exists) {
          const tag = resolveTag(tagSnapshot);
          if (tag) {
            responseEntities["tags"].push(tag);
            await CacheService.setInCache(cachePath, tag);
          }
        }
      };

      promises.push(resolveActivity(activityTag));
    }

    await Promise.all(promises);

    responseEntities["activities"].push(obj);

    return responseEntities;
  }
}
