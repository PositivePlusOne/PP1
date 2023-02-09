// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pledge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PledgeModel _$$_PledgeModelFromJson(Map<String, dynamic> json) =>
    _$_PledgeModel(
      owner: $enumDecode(_$PledgeOwnerEnumMap, json['owner']),
      affirmations: (json['affirmations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      version: json['version'] as int,
      hasAccepted: json['hasAccepted'] as bool,
    );

Map<String, dynamic> _$$_PledgeModelToJson(_$_PledgeModel instance) =>
    <String, dynamic>{
      'owner': _$PledgeOwnerEnumMap[instance.owner]!,
      'affirmations': instance.affirmations,
      'version': instance.version,
      'hasAccepted': instance.hasAccepted,
    };

const _$PledgeOwnerEnumMap = {
  PledgeOwner.user: 'user',
  PledgeOwner.company: 'company',
};
