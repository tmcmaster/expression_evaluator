import 'package:expression_evaluator/utils/to_map.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(explicitToJson: true)
class Address extends ToMap {
  final String number;
  final String street;
  final String suburb;
  Address({required this.number, required this.street, required this.suburb});
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
