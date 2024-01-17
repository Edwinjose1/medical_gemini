// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      userPhone: json['user_phone'] as String?,
      userEmail: json['user_email'] as String?,
      userPassword: json['user_password'] as String?,
      userName: json['user_name'] as String?,
      userAge: json['user_age'],
      userDob: json['user_dob'],
      userSex: json['user_sex'],
      profileCreatedStatus: json['profile_created_status'] as bool?,
      userDelStatus: json['user_del_status'],
      otpExpiryTime: json['otp_expiry_time'] == null
          ? null
          : DateTime.parse(json['otp_expiry_time'] as String),
      verifyOtp: json['verify_otp'],
      otp: json['otp'] as String?,
      userCreatedTime: json['user_created_time'] == null
          ? null
          : DateTime.parse(json['user_created_time'] as String),
      userUpdatedTime: json['user_updated_time'] == null
          ? null
          : DateTime.parse(json['user_updated_time'] as String),
      id: json['id'] as int?,
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'user_phone': instance.userPhone,
      'user_email': instance.userEmail,
      'user_password': instance.userPassword,
      'user_name': instance.userName,
      'user_age': instance.userAge,
      'user_dob': instance.userDob,
      'user_sex': instance.userSex,
      'profile_created_status': instance.profileCreatedStatus,
      'user_del_status': instance.userDelStatus,
      'otp_expiry_time': instance.otpExpiryTime?.toIso8601String(),
      'verify_otp': instance.verifyOtp,
      'otp': instance.otp,
      'user_created_time': instance.userCreatedTime?.toIso8601String(),
      'user_updated_time': instance.userUpdatedTime?.toIso8601String(),
      'id': instance.id,
    };
