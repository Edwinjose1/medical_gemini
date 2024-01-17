import 'package:json_annotation/json_annotation.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  @JsonKey(name: 'mem_id')
  int? memId;
  @JsonKey(name: 'mem_name')
  String? memName;
  @JsonKey(name: 'mem_height')
  int? memHeight;
  @JsonKey(name: 'mem_weight')
  int? memWeight;
  @JsonKey(name: 'mem_blood_group')
  String? memBloodGroup;
  @JsonKey(name: 'mem_age')
  int? memAge;
  @JsonKey(name: 'mem_sex')
  String? memSex;
  @JsonKey(name: 'mem_relation')
  String? memRelation;
  @JsonKey(name: 'parent_id')
  int? parentId;

  Datum({
    this.memId,
    this.memName,
    this.memHeight,
    this.memWeight,
    this.memBloodGroup,
    this.memAge,
    this.memSex,
    this.memRelation,
    this.parentId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
