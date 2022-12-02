// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_decoration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PageDecoration _$$_PageDecorationFromJson(Map<String, dynamic> json) =>
    _$_PageDecoration(
      asset: json['asset'] as String,
      alignment: alignmentFromJson(json['alignment'] as String),
      color: colorFromJson(json['color'] as String),
      scale: (json['scale'] as num).toDouble(),
      offsetX: (json['offset_x'] as num).toDouble(),
      offsetY: (json['offset_y'] as num).toDouble(),
      rotationDegrees: (json['rotation_degrees'] as num).toDouble(),
    );

Map<String, dynamic> _$$_PageDecorationToJson(_$_PageDecoration instance) =>
    <String, dynamic>{
      'asset': instance.asset,
      'alignment': alignmentToJson(instance.alignment),
      'color': colorToJson(instance.color),
      'scale': instance.scale,
      'offset_x': instance.offsetX,
      'offset_y': instance.offsetY,
      'rotation_degrees': instance.rotationDegrees,
    };
