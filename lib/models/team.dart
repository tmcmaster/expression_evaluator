import 'package:expression_evaluator/models/person.dart';
import 'package:expression_evaluator/utils/to_map.dart';
import 'package:json_annotation/json_annotation.dart';

part 'team.g.dart';

@JsonSerializable(explicitToJson: true)
class Team implements ToMap {
  final String name;
  final Person leader;
  final List<Person> people;
  Team({required this.name, required this.leader, required this.people});
  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
