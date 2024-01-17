import 'package:json_annotation/json_annotation.dart';

part 'datum.response.g.dart';

@JsonSerializable()
class Datum {
  @JsonKey(name: 'user_phone')
  String? userPhone;
  @JsonKey(name: 'user_email')
  String? userEmail;
  @JsonKey(name: 'user_password')
  String? userPassword;
  @JsonKey(name: 'user_name')
  String? userName;
  @JsonKey(name: 'user_age')
  dynamic userAge;
  @JsonKey(name: 'user_dob')
  dynamic userDob;
  @JsonKey(name: 'user_sex')
  dynamic userSex;
  @JsonKey(name: 'profile_created_status')
  bool? profileCreatedStatus;
  @JsonKey(name: 'user_del_status')
  dynamic userDelStatus;
  @JsonKey(name: 'otp_expiry_time')
  DateTime? otpExpiryTime;
  @JsonKey(name: 'verify_otp')
  dynamic verifyOtp;
  String? otp;
  @JsonKey(name: 'user_created_time')
  DateTime? userCreatedTime;
  @JsonKey(name: 'user_updated_time')
  DateTime? userUpdatedTime;
  @JsonKey(name: 'id')
  int? id;

  Datum({
    this.userPhone,
    this.userEmail,
    this.userPassword,
    this.userName,
    this.userAge,
    this.userDob,
    this.userSex,
    this.profileCreatedStatus,
    this.userDelStatus,
    this.otpExpiryTime,
    this.verifyOtp,
    this.otp,
    this.userCreatedTime,
    this.userUpdatedTime,
    this.id,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
