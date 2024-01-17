// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      memId: json['mem_id'] as int?,
      memName: json['mem_name'] as String?,
      memHeight: json['mem_height'] as int?,
      memWeight: json['mem_weight'] as int?,
      memBloodGroup: json['mem_blood_group'] as String?,
      memAge: json['mem_age'] as int?,
      memSex: json['mem_sex'] as String?,
      memRelation: json['mem_relation'] as String?,
      parentId: json['parent_id'] as int?,
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'mem_id': instance.memId,
      'mem_name': instance.memName,
      'mem_height': instance.memHeight,
      'mem_weight': instance.memWeight,
      'mem_blood_group': instance.memBloodGroup,
      'mem_age': instance.memAge,
      'mem_sex': instance.memSex,
      'mem_relation': instance.memRelation,
      'parent_id': instance.parentId,
    };
