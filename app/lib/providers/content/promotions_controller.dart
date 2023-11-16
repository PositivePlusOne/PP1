// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/extensions/future_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/services/enrichment_api_service.dart';
import 'package:app/services/third_party.dart';

part 'promotions_controller.freezed.dart';
part 'promotions_controller.g.dart';

@freezed
class PromotionsControllerState with _$PromotionsControllerState {
  const factory PromotionsControllerState({
    @Default({}) Set<String> validFeedPromotionIds,
    @Default({}) Set<String> validChatPromotionIds,
    @Default({}) Map<String, Set<String>> profilePromotionIds,
    @Default(4) int feedPromotionFrequency,
    @Default(4) int chatPromotionFrequency,
    @Default('') String cursor,
    @Default(false) bool isExhausted,
  }) = _PromotionsControllerState;

  factory PromotionsControllerState.initialState() => const PromotionsControllerState();
}

enum PromotionType {
  feed,
  chat,
}

@Riverpod(keepAlive: true)
class PromotionsController extends _$PromotionsController {
  @override
  PromotionsControllerState build() {
    return PromotionsControllerState.initialState();
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

  void addInitialPromotionWindow(List promotions) {
    final Logger logger = ref.read(loggerProvider);
    if (state.validFeedPromotionIds.isNotEmpty || state.validChatPromotionIds.isNotEmpty) {
      logger.w('Promotions already loaded');
      return;
    }

    final Iterable<Promotion> promotionDtos = promotions.map((dynamic promotion) => Promotion.fromJson(json.decodeSafe(promotion))).where((element) => element.flMeta?.id?.isNotEmpty == true).toList();
    if (promotionDtos.isEmpty) {
      logger.w('No promotions found');
      return;
    }

    appendPromotionsToCorrectFeeds(promotionDtos);
  }

  void appendPromotionsToCorrectFeeds(Iterable<Promotion> promotions) {
    final Logger logger = ref.read(loggerProvider);
    final List<String> newChatPromotionIds = [...state.validChatPromotionIds];
    final List<String> newFeedPromotionIds = [...state.validFeedPromotionIds];
    final Map<String, Set<String>> newProfilePromotions = {...state.profilePromotionIds};

    for (final Promotion promotion in promotions) {
      if (promotion.flMeta?.id?.isNotEmpty != true) {
        continue;
      }

      final String ownerId = promotion.ownerId;
      final String activityId = promotion.activityId;
      final bool hasLink = promotion.link.isNotEmpty;

      final bool isValidFeedPromotion = activityId.isNotEmpty;
      final bool isValidChatPromotion = ownerId.isNotEmpty && hasLink;

      if (isValidFeedPromotion) {
        newFeedPromotionIds.add(promotion.flMeta!.id!);
      }

      if (isValidChatPromotion) {
        newChatPromotionIds.add(promotion.flMeta!.id!);
      }

      if (ownerId.isNotEmpty) {
        final Set<String> profilePromotionIds = newProfilePromotions[ownerId] ?? {};
        profilePromotionIds.add(promotion.flMeta!.id!);
        newProfilePromotions[ownerId] = profilePromotionIds;
      }
    }

    logger.d('Loaded ${newFeedPromotionIds.length} feed promotions');
    logger.d('Loaded ${newChatPromotionIds.length} chat promotions');

    state = state.copyWith(
      validFeedPromotionIds: newFeedPromotionIds.toSet(),
      validChatPromotionIds: newChatPromotionIds.toSet(),
      profilePromotionIds: newProfilePromotions,
    );
  }

  Promotion? getPromotionFromIndex(int index, PromotionType promotionType) {
    final Set<String> validPromotionIds = promotionType == PromotionType.feed ? state.validFeedPromotionIds : state.validChatPromotionIds;
    if (validPromotionIds.isEmpty) {
      return null;
    }

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final int frequency = promotionType == PromotionType.feed ? state.feedPromotionFrequency : state.chatPromotionFrequency;

    // Work out the real index from the modulo
    final int realIndex = index % validPromotionIds.length;
    final String promotionId = validPromotionIds.elementAt(realIndex);

    // Check the frequency
    if (index % frequency != 0) {
      return null;
    }

    final Promotion? promotion = cacheController.get(promotionId);
    if (promotion == null) {
      return null;
    }

    return promotion;
  }

  Future<void> loadNextPromotionWindow() => runWithMutex(() async {
        final Logger logger = ref.read(loggerProvider);
        const int limit = 30;

        logger.i('Attempting to load next promotion window');

        if (state.isExhausted) {
          logger.w('Promotions are exhausted');
          return;
        }

        final EnrichmentApiService enrichmentApiService = await ref.read(enrichmentApiServiceProvider.future);
        final EndpointResponse response = await enrichmentApiService.getPromotionWindow(
          cursor: state.cursor,
          limit: limit,
        );

        final Iterable<Promotion> promotions = (response.data['promotions'] as List).map((dynamic promotion) => Promotion.fromJson(json.decodeSafe(promotion))).cast<Promotion>();
        final String cursor = response.cursor ?? '';

        appendPromotionsToCorrectFeeds(promotions);
        state = state.copyWith(
          cursor: cursor,
          isExhausted: promotions.length < limit || cursor.isEmpty,
        );

        logger.i('Loaded ${promotions.length} promotions');
      });
}
