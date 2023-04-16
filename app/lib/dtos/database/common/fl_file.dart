// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'fl_meta.dart';

part 'fl_file.freezed.dart';
part 'fl_file.g.dart';

@freezed
class FlFile with _$FlFile {
  const factory FlFile({
    @Default('application/octet-stream') String contentType,
    @Default('') String file,
    @Default('') String folderId,
    @Default('') String id,
    @Default('') String type,
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @JsonKey(name: 'sizes') List<FlFileSize>? sizes,
  }) = _FlFile;

  factory FlFile.fromJson(Map<String, dynamic> json) => _$FlFileFromJson(json);
}

@freezed
class FlFileSize with _$FlFileSize {
  const factory FlFileSize({
    @Default('') String path,
    @Default(0.0) double quality,
    @Default(0) int height,
    @Default(0) int width,
  }) = _FlFileSize;

  factory FlFileSize.fromJson(Map<String, dynamic> json) => _$FlFileSizeFromJson(json);
}
