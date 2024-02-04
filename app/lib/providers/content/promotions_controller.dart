// Dart imports:
import 'dart:async';

// Package imports:
import 'package:app/extensions/permission_extensions.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/dtos/database/geo/positive_restricted_place.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/place_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/providers/content/events/location_updated_event.dart';
import 'package:app/providers/location/location_controller.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/services/third_party.dart';

part 'promotions_controller.freezed.dart';
part 'promotions_controller.g.dart';

@freezed
class PromotionsControllerState with _$PromotionsControllerState {
  const factory PromotionsControllerState({
    @Default({}) Set<String> allPromotionIds,
    @Default({}) Set<String> validFeedPromotionIds,
    @Default({}) Set<String> validChatPromotionIds,
    @Default({}) Map<String, Set<String>> validOwnedPromotionIds,
    @Default({}) Map<String, Set<String>> knownActivityPromotionIds,
    @Default(4) int feedPromotionFrequency,
    @Default(4) int chatPromotionFrequency,
    @Default('') String cursor,
    @Default(false) bool isExhausted,
    @Default(false) bool canPerformLocationCheck,
    DateTime? lastPerformedLocationCheck,
  }) = _PromotionsControllerState;

  factory PromotionsControllerState.initialState() => const PromotionsControllerState();
}

enum PromotionType {
  feed,
  chat,
}

abstract class IPromotionsController {
  Future<void> setupListeners(); // Listeners for LocationController events
  Future<void> appendPromotions({Iterable<Promotion> promotions});
  Future<void> refreshValidPromotions();
  Promotion? getPromotionFromActivityId({required String activityId, required PromotionType promotionType});
}

@Riverpod(keepAlive: true)
class PromotionsController extends _$PromotionsController implements IPromotionsController {
  StreamSubscription<ProfileSwitchedEvent>? _profileSwitchedSubscription;
  StreamSubscription<LocationUpdatedEvent>? _locationSubscription;

  @override
  PromotionsControllerState build() {
    return PromotionsControllerState.initialState();
  }

  @override
  Future<void> setupListeners() async {
    final Logger logger = ref.read(loggerProvider);

    logger.i('Setting up listeners for promotions controller');
    final EventBus eventBus = ref.read(eventBusProvider);

    _locationSubscription ??= eventBus.on<LocationUpdatedEvent>().listen((LocationUpdatedEvent event) async {
      logger.i('Location updated, checking if promotions need to be refreshed');
      await refreshValidPromotions();
    });

    _profileSwitchedSubscription ??= eventBus.on<ProfileSwitchedEvent>().listen((ProfileSwitchedEvent event) async {
      logger.i('Profile switched, checking if promotions need to be refreshed');
      await refreshValidPromotions();
    });
  }

  Future<void> updatePromotionFrequenciesFromRemoteConfig() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseRemoteConfig remoteConfig = await ref.read(firebaseRemoteConfigProvider.future);
    final int feedPromotionFrequency = remoteConfig.getInt(SystemController.kFirebaseRemoteConfigFeedPromotionFrequencyKey);
    final int chatPromotionFrequency = remoteConfig.getInt(SystemController.kFirebaseRemoteConfigChatPromotionFrequencyKey);

    if (feedPromotionFrequency == 0 || chatPromotionFrequency == 0) {
      logger.w('No configured promotion frequencies, using defaults');
      return;
    }

    logger.i('Updating promotion frequencies from remote config');
    state = state.copyWith(
      feedPromotionFrequency: feedPromotionFrequency,
      chatPromotionFrequency: chatPromotionFrequency,
    );

    logger.i('Updated promotion frequencies from remote config');
    logger.d('Feed promotion frequency: $feedPromotionFrequency');
    logger.d('Chat promotion frequency: $chatPromotionFrequency');
  }

  @override
  Future<void> appendPromotions({
    Iterable<Promotion> promotions = const [],
  }) async {
    final Set<String> newPromotionIds = promotions.map((Promotion promotion) => promotion.flMeta?.id ?? '').where((element) => element.isNotEmpty).toSet();
    final Set<String> allPromotionIds = {...state.allPromotionIds, ...newPromotionIds};
    final Set<String> allActivityIds = promotions.map((Promotion promotion) => promotion.activityId).where((element) => element.isNotEmpty).toSet();
    final Map<String, Set<String>> knownActivityPromotionIds = {
      ...state.knownActivityPromotionIds,
    };

    for (final String activityId in allActivityIds) {
      final Set<String> promotionIds = promotions.where((Promotion promotion) => promotion.activityId == activityId).map((Promotion promotion) => promotion.flMeta?.id ?? '').toSet();
      final Set<String> existingPromotionIds = knownActivityPromotionIds[activityId] ?? {};
      knownActivityPromotionIds[activityId] = {...existingPromotionIds, ...promotionIds};
    }

    state = state.copyWith(
      allPromotionIds: allPromotionIds,
      knownActivityPromotionIds: knownActivityPromotionIds,
      validOwnedPromotionIds: {},
      validFeedPromotionIds: {},
      validChatPromotionIds: {},
    );

    await refreshValidPromotions();
  }

  @override
  Future<void> refreshValidPromotions() async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final LocationControllerState locationControllerState = ref.read(locationControllerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    final Set<String> validFeedPromotionIds = {};
    final Set<String> validChatPromotionIds = {};
    final Set<String> validOwnedPromotionIds = {};

    final String currentProfileId = profileController.currentProfile?.flMeta?.id ?? '';

    logger.i('Refreshing valid promotions');
    final List<Promotion> promotions = cacheController.list(state.allPromotionIds);
    for (final Promotion promotion in promotions) {
      if (promotion.flMeta?.id?.isNotEmpty != true) {
        continue;
      }

      final String ownerId = promotion.ownerId;
      final String activityId = promotion.activityId;
      final bool hasLink = promotion.link.isNotEmpty;

      final bool isValidFeedPromotion = activityId.isNotEmpty;
      final bool isValidChatPromotion = ownerId.isNotEmpty && hasLink;

      if (ownerId.isNotEmpty && ownerId == currentProfileId) {
        validOwnedPromotionIds.add(promotion.flMeta!.id!);
      }

      // Perform location check if required
      final bool hasEnforcedRestrictions = promotion.locationRestrictions.isNotEmpty;
      final Map<String, Set<String>> currentLocationComponents = locationControllerState.lastKnownAddressComponents;

      final PermissionStatus locationPermissionStatus = await ref.read(locationPermissionsProvider.future);
      final bool canPerformLocationCheck = locationPermissionStatus.canUsePermission;

      bool hasPassedRestrictions = false;
      if (hasEnforcedRestrictions) {
        for (final PositiveRestrictedPlace restrictedPlace in promotion.locationRestrictions) {
          if (!canPerformLocationCheck || currentLocationComponents.isEmpty) {
            break;
          }

          final bool passesCheck = canPerformLocationCheck && await restrictedPlace.performCheck(addressComponents: currentLocationComponents);
          if (!hasPassedRestrictions && passesCheck) {
            hasPassedRestrictions = true;
          }

          if (hasPassedRestrictions) {
            break;
          }
        }
      } else {
        hasPassedRestrictions = true;
      }

      if (currentProfileId.isNotEmpty && ownerId.isNotEmpty) {
        final String expectedRelationshipId = [currentProfileId, ownerId].asGUID;
        final Relationship? relationship = cacheController.get(expectedRelationshipId);
        final Set<RelationshipState> relationshipStates = relationship?.relationshipStatesForEntity(currentProfileId) ?? {};

        // Check if the relationship is blocked
        if (relationshipStates.contains(RelationshipState.targetBlocked)) {
          hasPassedRestrictions = false;
        }
      }

      final bool isPostPromotionEnabled = promotion.postPromotionEnabled;
      if (isValidFeedPromotion && hasPassedRestrictions && isPostPromotionEnabled) {
        validFeedPromotionIds.add(promotion.flMeta!.id!);
      }

      final bool isChatPromotionEnabled = promotion.chatPromotionEnabled;
      if (isValidChatPromotion && hasPassedRestrictions && isChatPromotionEnabled) {
        validChatPromotionIds.add(promotion.flMeta!.id!);
      }
    }

    logger.i('Found ${validFeedPromotionIds.length} valid feed promotions');
    logger.i('Found ${validChatPromotionIds.length} valid chat promotions');
    logger.i('Found ${validOwnedPromotionIds.length} valid owned promotions');

    final Map<String, Set<String>> validOwnedPromotionIdsMap = {
      ...state.validOwnedPromotionIds,
    };

    if (validOwnedPromotionIds.isNotEmpty) {
      validOwnedPromotionIdsMap[currentProfileId] = validOwnedPromotionIds;
    }

    state = state.copyWith(
      validFeedPromotionIds: validFeedPromotionIds,
      validChatPromotionIds: validChatPromotionIds,
      validOwnedPromotionIds: validOwnedPromotionIdsMap,
    );
  }

  Promotion? getPromotionFromIndex({
    required int index,
    required PromotionType promotionType,
  }) {
    final Set<String> validPromotionIds = promotionType == PromotionType.feed ? state.validFeedPromotionIds : state.validChatPromotionIds;
    if (validPromotionIds.isEmpty) {
      return null;
    }

    // Get the gap between adverts based on the feed type
    final int gapBetweenAdverts = promotionType == PromotionType.feed ? state.feedPromotionFrequency : state.chatPromotionFrequency;

    // Get the index of the advert
    final bool canShowAdvert = index % gapBetweenAdverts == 0;
    if (!canShowAdvert) {
      return null;
    }

    final int totalAdverts = validPromotionIds.length;
    final int advertIndex = index ~/ gapBetweenAdverts % totalAdverts;
    final String promotionId = validPromotionIds.elementAt(advertIndex);

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final Promotion? promotion = cacheController.get(promotionId);
    if (promotion == null) {
      return null;
    }

    return promotion;
  }

  @override
  Promotion? getPromotionFromActivityId({
    required String activityId,
    required PromotionType promotionType,
  }) {
    final Set<String> validPromotionIds = promotionType == PromotionType.feed ? state.validFeedPromotionIds : state.validChatPromotionIds;
    if (validPromotionIds.isEmpty) {
      return null;
    }

    final CacheController cacheController = ref.read(cacheControllerProvider);
    for (final String promotionId in validPromotionIds) {
      final Promotion? promotion = cacheController.get(promotionId);
      if (promotion?.activityId == activityId) {
        return promotion;
      }
    }

    return null;
  }
}
