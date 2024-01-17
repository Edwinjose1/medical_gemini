import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'memeber_response.g.dart';

@JsonSerializable()
class MemeberResponse {
  List<Datum>? data;
  bool? status;
  String? message;

  MemeberResponse({this.data, this.status, this.message});

  factory MemeberResponse.fromJson(Map<String, dynamic> json) {
    return _$MemeberResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MemeberResponseToJson(this);
}
