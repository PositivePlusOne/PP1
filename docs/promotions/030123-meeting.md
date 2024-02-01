# Questions - for dev
1. How often do we refresh the users location
Handled by location stream in: https://pub.dev/packages/geolocator
Down to package, not defined by us.
intervalDuration: const Duration(seconds: 10),

1b. What do we want that interval duration to be

2. How do we know when to fetch from location filtered vs non
@Default(false) bool isLocationRestricted,

3. How we input location filtered promotions
@Default('') String placeId,

4. Is the location controller fit, and does it need any updates
Yes, but the promotions controller needs to be updated as it implies it injects into the feeds; as opposed to building as a separator.

5. Do we currently bulk all promotions on launch? If not we need to do it.
See above, a change may be needed.

# Questions - for product
1. Will we ever need location in a promotion without it being a restriction (next 2 years)
2. Do we want to have a grace on location, and if so do we want it configurable in flamelink?

# Actions - for dev
1. Update the feed pagination behaviour to make knowing what post we're showing (clip, post, promotion) easier.
2. Avoid bloat in buildItem and buildSeparator of feed behaviour
3. Update getPromotionFromIndex to take location, either keeping in promotions controller or creating an adapter/delegate
4. Have a session on place IDs