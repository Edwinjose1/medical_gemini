import 'package:json_annotation/json_annotation.dart';

import 'datum.response.dart';

part 'profile.response.g.dart';

@JsonSerializable()
class Profile {
  List<Datum>? data;
  bool? status;
  String? message;

  Profile({this.data, this.status, this.message});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return _$ProfileFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
