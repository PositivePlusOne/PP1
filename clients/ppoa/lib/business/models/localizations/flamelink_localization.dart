import 'package:freezed_annotation/freezed_annotation.dart';

import '../database/metadata.dart';

part 'flamelink_localization.freezed.dart';
part 'flamelink_localization.g.dart';

@freezed
class FlamelinkLocalization with _$FlamelinkLocalization {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory FlamelinkLocalization({
    @JsonKey(name: 'metadata') required Metadata metadata,
    required String key,
    required String locale,
    required String text,
  }) = _FlamelinkLocalization;

  factory FlamelinkLocalization.fromJson(Map<String, Object?> json) => _$FlamelinkLocalizationFromJson(json);
}
