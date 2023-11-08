// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/extensions/future_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/enrichment_api_service.dart';
import 'package:app/services/third_party.dart';

part 'promotions_controller.freezed.dart';
part 'promotions_controller.g.dart';

@freezed
class PromotionsControllerState with _$PromotionsControllerState {
  const factory PromotionsControllerState({
    @Default('') String cursor,
    @Default({}) Set<String> promotionIds,
    @Default(false) bool isExhausted,
  }) = _PromotionsControllerState;
  factory PromotionsControllerState.initialState() => const PromotionsControllerState();
}

@Riverpod(keepAlive: true)
class PromotionsController extends _$PromotionsController {
  @override
  PromotionsControllerState build() {
    return PromotionsControllerState.initialState();
  }

  void addInitialPromotionWindow(List promotions) {
    final Logger logger = ref.read(loggerProvider);
    if (state.promotionIds.isNotEmpty) {
      logger.w('Promotions already loaded');
      return;
    }

    final Iterable<String> promotionIds = promotions.map((dynamic promotion) => Promotion.fromJson(json.decodeSafe(promotion)).flMeta?.id ?? '').where((element) => element.isNotEmpty).toList();
    if (promotionIds.isEmpty) {
      logger.w('No promotions found');
      return;
    }

    logger.i('Loaded ${promotionIds.length} initial or owned promotions');
    state = state.copyWith(
      promotionIds: {
        ...state.promotionIds,
        ...promotionIds,
      },
    );
  }

  Promotion? getPromotionFromIndex(int index) {
    if (state.promotionIds.isEmpty) {
      return null;
    }

    final CacheController cacheController = ref.read(cacheControllerProvider);

    // Work out the real index from the modulo
    final int realIndex = index % state.promotionIds.length;
    final String promotionId = state.promotionIds.elementAt(realIndex);

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
        final Iterable<String> promotionIds = promotions.map((Promotion promotion) => promotion.flMeta?.id ?? '').where((element) => element.isNotEmpty).toList();
        final String cursor = response.cursor ?? '';

        state = state.copyWith(
          cursor: cursor,
          isExhausted: promotions.length < limit || cursor.isEmpty,
          promotionIds: {
            ...state.promotionIds,
            ...promotionIds,
          },
        );

        logger.i('Loaded ${promotionIds.length} promotions');
      });
}
