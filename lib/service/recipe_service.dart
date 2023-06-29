import 'package:expressions/expressions.dart';

import '../models/_all.dart';
import '../utils/expression_evaluator_dto.dart';
import '../utils/yaml_encode_decode.dart';

/// This is currently a WIP, to test the generating receipt data from expressions.
/// There are still some issues with the order that the expressions are executed. This is due to the need for some kind spreadsheet algorithm.  ??
/// TODO: Currently expressions that rely on other expressions will not work, if the order of processing the map elements is incorrect.
/// TODO: At the moment the service is returning a RecipeExpr instead of a Recipe. There are still some json decode from String to int issues.
class RecipeService {
  final ExpressionEvaluatorDTO _evaluator = ExpressionEvaluatorDTO();

  /// This is where any custom function can be registered.
  final _functions = <String, dynamic>{
    'stringToLowercase': (string) => string.toLowerCase(),
  };

  Future<Recipe> loadRecipe(String recipeName, Map<String, dynamic> context) async {
    final filePath = 'data/$recipeName.json';
    final recipeDef = await jsonFileToJsonMap(filePath);
    final recipe = <String, dynamic>{}..addAll(recipeDef);
    walkMap(recipe, {...context, ..._functions});
    return Recipe.fromJson(recipe);
  }

  void walkMap(Map<String, dynamic> recipe, Map<String, dynamic> context) {
    _walkMap(recipe, {'recipe': recipe, ...context});
  }

  void _walkMap(Map<String, dynamic> map, Map<String, dynamic> context) {
    map.forEach((key, value) {
      if (value is String) {
        map[key] = _evaluateExpression(value, context);
      } else if (value is Map<String, dynamic>) {
        _walkMap(map[key], context);
      } else if (value is List) {
        map[key] = _walkList(map[key], context);
      }
    });
  }

  List<dynamic> _walkList(List<dynamic> list, Map<String, dynamic> context) {
    return list.map((value) {
      if (value is String) {
        return _evaluateExpression(value, context);
      } else if (value is Map<String, dynamic>) {
        _walkMap(value, context);
        return value;
      } else {
        return value;
      }
    }).toList();
  }

  dynamic _evaluateExpression(String value, Map<String, dynamic> context) {
    if (value.startsWith('expr__')) {
      final parts = value.split('__');
      final expression = parts[1];
      //print("Evaluating expression: $expression");
      var result = _evaluator.eval(Expression.parse(expression), context);
      return result;
    } else {
      return value;
    }
  }
}
