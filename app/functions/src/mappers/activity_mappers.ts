import { Timestamp } from "firebase-admin/firestore";

import { Activity, ActivityGeneralConfigurationStyle, ActivityGeneralConfigurationType, ActivityPricingExternalStoreInformationPricingStrategy, ActivitySecurityConfigurationMode, MEDIA_PRIORITY_DEFAULT, MEDIA_PRIORITY_MAX, MediaType } from "../dto/activities";

import { OccasionGeniusEvent } from "../dto/events";

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
}
