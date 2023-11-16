// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import '../../dtos/system/design_typography_model.dart';

part 'design_controller.freezed.dart';
part 'design_controller.g.dart';

@freezed
class DesignControllerState with _$DesignControllerState {
  const factory DesignControllerState({
    required DesignTypographyModel typography,
    required DesignColorsModel colors,
  }) = _DesignControllerState;

  factory DesignControllerState.initialState() => DesignControllerState(
        typography: DesignTypographyModel.empty(),
        colors: DesignColorsModel.empty(),
      );
}

@Riverpod(keepAlive: true)
class DesignController extends _$DesignController {
  @override
  DesignControllerState build() {
    return DesignControllerState.initialState();
  }
}
