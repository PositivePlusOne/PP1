// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppState _$$_AppStateFromJson(Map<String, dynamic> json) => _$_AppState(
      designSystem: DesignSystemState.fromJson(
          json['design_system'] as Map<String, dynamic>),
      systemState:
          SystemState.fromJson(json['system_state'] as Map<String, dynamic>),
      contentState:
          ContentState.fromJson(json['content_state'] as Map<String, dynamic>),
      environment:
          Environment.fromJson(json['environment'] as Map<String, dynamic>),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AppStateToJson(_$_AppState instance) =>
    <String, dynamic>{
      'design_system': instance.designSystem,
      'system_state': instance.systemState,
      'content_state': instance.contentState,
      'environment': instance.environment,
      'user': instance.user,
    };
