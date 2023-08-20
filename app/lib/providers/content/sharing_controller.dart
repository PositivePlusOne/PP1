import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sharing_controller.freezed.dart';
part 'sharing_controller.g.dart';

@freezed
class SharingControllerState with _$SharingControllerState {
  const factory SharingControllerState() = _SharingControllerState;

  factory SharingControllerState.initialState() => const SharingControllerState();
}

@Riverpod(keepAlive: true)
class SharingController extends _$SharingController {
  @override
  SharingControllerState build() {
    return SharingControllerState.initialState();
  }
}
