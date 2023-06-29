import 'package:test/test.dart';

import '../../lib/models/_all.dart';
import '../../lib/service/recipe_service.dart';

void main() {
  final recipeService = RecipeService();
  test('Test loading a recipe', () async {
    final recipe = await recipeService.loadRecipe('recipe_1', {'serves': 5});
    expect(recipe.name, 'Title = recipe 4');
    expect(recipe.description, 'Description = Title = recipe 4');
  });

  test('Test ReceiptService walkMap method', () {
    final context = <String, dynamic>{'serves': 3};
    final dtoMap = <String, dynamic>{
      'name': 'Name',
      'quantity': 'expr__(20*serves)__int',
      'unit': 'g',
    };
    recipeService.walkMap(dtoMap, context);
    expect(dtoMap['quantity'], 60);

    final ingredient = Ingredient.fromJson(dtoMap);
    expect(ingredient.name, dtoMap['name']);
    expect(ingredient.quantity, dtoMap['quantity']);
    expect(ingredient.unit, dtoMap['unit']);
  });
}
