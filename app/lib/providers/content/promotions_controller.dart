// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promotions_controller.freezed.dart';
part 'promotions_controller.g.dart';

@freezed
class PromotionsControllerState with _$PromotionsControllerState {
  const factory PromotionsControllerState() = _PromotionsControllerState;
  factory PromotionsControllerState.initialState() => const PromotionsControllerState();
}

@Riverpod(keepAlive: true)
class PromotionsController extends _$PromotionsController {
  @override
  PromotionsControllerState build() {
    return PromotionsControllerState.initialState();
  }
}
