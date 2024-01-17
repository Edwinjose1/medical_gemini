import 'package:json_annotation/json_annotation.dart';

part 'responseresult.g.dart';

@JsonSerializable()
class Responseresult {
  @JsonKey(name: 'MedicineName')
  String? medicineName;
  @JsonKey(name: 'Dosage')
  String? dosage;

  Responseresult({this.medicineName, this.dosage});

  factory Responseresult.fromJson(Map<String, dynamic> json) {
    return _$ResponseresultFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ResponseresultToJson(this);
}
