import 'package:expression_evaluator/models/address.dart';
import 'package:expression_evaluator/utils/to_map.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable(explicitToJson: true)
class Person implements ToMap {
  final String name;
  final String emoji;
  final Address? address;
  Person({
    required this.name,
    required this.emoji,
    this.address,
  });
  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
