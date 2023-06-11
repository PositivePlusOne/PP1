export namespace Keys {
  //* API keys
  export const OccasionGeniusApiKey = "OCCASION_GENIUS_API_KEY";
  export const StreamApiKey = "STREAM_API_KEY";
  export const StreamFeedsApiKey = "STREAM_FEEDS_API_KEY";
  export const AlgoliaApiKey = "ALGOLIA_API_KEY";
  export const GoogleMapKey = "MAPS_API_KEY";

  //* Secret keys
  export const StreamApiSecret = "STREAM_API_SECRET";
  export const StreamFeedsApiSecret = "STREAM_FEEDS_API_SECRET";
  export const AlgoliaAppId = "ALGOLIA_APP_ID";

  //* Feature flags
  export const FeatureFlagManagedOrganisation = "MANAGED_ORGANISATION";

  // A map of all the keys
  export const AllKeys = [
    OccasionGeniusApiKey,
    StreamApiKey,
    StreamFeedsApiKey,
    StreamApiSecret,
    StreamFeedsApiSecret,
    AlgoliaApiKey,
    AlgoliaAppId,
    GoogleMapKey,
  ];
}
