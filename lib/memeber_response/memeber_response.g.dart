// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memeber_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemeberResponse _$MemeberResponseFromJson(Map<String, dynamic> json) =>
    MemeberResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$MemeberResponseToJson(MemeberResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'status': instance.status,
      'message': instance.message,
    };
