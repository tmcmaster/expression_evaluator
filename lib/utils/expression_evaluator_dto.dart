import 'package:expressions/expressions.dart';

import 'to_map.dart';

///
/// This class can be used to extract data from a context, and generating a value with an expression.
///
/// Expression expression = Expression.parse("person.address[0].suburb");
/// String result = evaluator.eval(expression, {
///   'person': Person(
///                 name: 'Sam',
///                 address: [
///                   Address(suburb: 'Melbourne'),
///                   Address(suburb: 'Sydney')
///                 ]
///             )
/// }) as String;
/// print("Message: $message");
///

class ExpressionEvaluatorDTO extends ExpressionEvaluator {
  /// Enable literals to be concatenated with strings
  @override
  dynamic evalBinaryExpression(BinaryExpression expression, Map<String, dynamic> context) {
    if (expression.operator == '+') {
      var left = eval(expression.left, context);
      var right = () => eval(expression.right, context);
      return left + (left is String ? right().toString() : right());
    }
    return super.evalBinaryExpression(expression, context);
  }

  /// Implements MemberExpression support, that is currently not supported in the parent class.
  @override
  dynamic evalMemberExpression(MemberExpression expression, Map<String, dynamic> context) {
    var propertyName = expression.property.name;
    var propertyContext = _getPropertyContext(expression.object, context);
    return propertyContext[propertyName];
  }

  /// This logic was a little mind bending to get right.
  /// It involves recursively walking down the expression tree, which is in reverse order,
  /// passing the context down to the bottom, and then resolving the context map or list on the way back up.
  dynamic _getPropertyContext(Expression expression, Map<String, dynamic> context) {
    if (expression is Variable) {
      var propertyName = expression.identifier.name;
      if (context[propertyName] is ToMap) {
        var dto = context[propertyName] as ToMap;
        return dto.toJson();
      } else {
        return context[propertyName];
      }
    } else if (expression is MemberExpression) {
      var propertyName = expression.property.name;
      var subExpression = expression.object;
      Map<String, dynamic> subContext = _getPropertyContext(subExpression, context);
      return subContext[propertyName];
    } else if (expression is IndexExpression) {
      final literal = expression.index as Literal;
      int index = literal.value;
      var subExpression = expression.object;
      List<dynamic> subContext = _getPropertyContext(subExpression, context);
      return subContext[index];
    } else {
      throw Exception('Not supported yet');
    }
  }
}
