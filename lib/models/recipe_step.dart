import 'package:freezed_annotation/freezed_annotation.dart';

import 'item.dart';

part 'recipe_step.freezed.dart';
part 'recipe_step.g.dart';

@freezed
class RecipeStep with _$RecipeStep, Item {
  factory RecipeStep({
    required int idx,
    required String id,
    required String title,
    required String description,
    required int duration,
    required int elapsed,
    required int completed,
    required String type,
    required int start,
    required int end,
    required String stage,
  }) = _RecipeStep;

  factory RecipeStep.fromJson(Map<String, dynamic> json) => _$RecipeStepFromJson(json);
}
