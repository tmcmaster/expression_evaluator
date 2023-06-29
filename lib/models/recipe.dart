import 'package:freezed_annotation/freezed_annotation.dart';

import 'equipment.dart';
import 'ingredient.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
class Recipe with _$Recipe {
  factory Recipe({
    required String name,
    required String description,
    required String difficulty,
    required List<Equipment> equipment,
    required List<Ingredient> ingredients,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
