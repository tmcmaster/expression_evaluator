import 'dart:math';

import 'package:expression_evaluator/models/address.dart';
import 'package:expression_evaluator/models/person.dart';
import 'package:expression_evaluator/models/team.dart';
import 'package:expressions/expressions.dart';
import 'package:test/test.dart';

import '../../lib/utils/expression_evaluator_dto.dart';

/// I have committed this class, and it's builder generated support file, as a stopgap until we have proper model classes defined.
/// TODO: need to update these tests at some point to use real model classes rather than local stopgap ones.

final testExpressionEvaluatorDTO =
    (expression, context) => ExpressionEvaluatorDTO().eval(Expression.parse(expression), context);

final stringToLowercase = (string) => string.toLowerCase();
final listToLowercase = (list) => list.map((s) => s.toLowerCase());
final peopleToNameList = (people) => people.map((person) => person.name).join(',');

final TEST_ADDRESS = Address(
  number: '11',
  street: 'Main1 st',
  suburb: 'Melbourne1',
);
void main() {
  test('Test getting scalar', () {
    expect(
        testExpressionEvaluatorDTO('1', {
          'name': 'Jayne Cobb',
        }),
        1);
  });

  test('Test getting value', () {
    expect(
        testExpressionEvaluatorDTO('name', {
          'name': 'Jayne Cobb',
        }),
        'Jayne Cobb');
  });

  final address = Address(
    number: '2',
    street: 'Station st',
    suburb: 'Sydney',
  );

  test('Test getting value out of a DTO', () {
    expect(
      testExpressionEvaluatorDTO('address.street', {
        'address': address,
      }),
      'Station st',
    );
  });

  test('Test getting value out of a nested DTO', () {
    expect(
        testExpressionEvaluatorDTO('team.leader.name', {
          'team': Team(
            name: 'My Team',
            leader: Person(
              name: 'Jane Doe',
              emoji: ':-)',
              address: Address(
                street: '',
                suburb: '',
                number: '',
              ),
            ),
            people: [],
          ),
        }),
        'Jane Doe');
  });

  test('Test getting value with three levels of DTO nesting', () {
    expect(
        testExpressionEvaluatorDTO('team.leader.address.suburb', {
          'team': Team(
            name: 'My Team',
            leader: Person(
              name: 'Jane Doe',
              emoji: ':-)',
              address: Address(
                number: '1',
                street: 'Main st',
                suburb: 'Melbourne',
              ),
            ),
            people: [],
          ),
        }),
        'Melbourne');
  });

  test('Test getting data from DTOs within lists', () {
    expect(
      testExpressionEvaluatorDTO('team.people[1].address.suburb', {
        'team': Team(
          name: 'My Team',
          people: [
            Person(
              name: 'Jane1 Doe1',
              emoji: ':-)',
              address: Address(
                number: '11',
                street: 'Main1 st',
                suburb: 'Melbourne1',
              ),
            ),
            Person(
              name: 'Jane2 Doe2',
              emoji: ':-)',
              address: Address(
                number: '12',
                street: 'Main2 st',
                suburb: 'Melbourne2',
              ),
            )
          ],
          leader: Person(
            name: 'Jane Doe',
            emoji: ':-)',
            address: TEST_ADDRESS,
          ),
        ),
      }),
      'Melbourne2',
    );
  });

  test('Testing maths expression', () {
    expect(
        testExpressionEvaluatorDTO('(1 + x) * 3', {
          'x': 5,
        }),
        18);
  });

  test('Testing maths expression with function', () {
    expect(
        testExpressionEvaluatorDTO('(1 + x) * sqrt(25)', {
          'x': 5,
          'sqrt': sqrt,
        }),
        30);
  });

  test('Testing anonymous function', () {
    expect(
        testExpressionEvaluatorDTO('toLowercase(letters)', {
          'letters': [
            'A',
            'B',
            'C',
          ],
          'toLowercase': (list) => list.map((s) => s.toLowerCase()),
        }),
        ['a', 'b', 'c']);
  });

  test('List of people to comma separated list of last names', () {
    expect(
        testExpressionEvaluatorDTO('peopleToLastNameList(people)', {
          'people': [
            Person(name: 'A', emoji: ':-)', address: TEST_ADDRESS),
            Person(name: 'B', emoji: ':-)', address: TEST_ADDRESS),
            Person(name: 'C', emoji: ':-)', address: TEST_ADDRESS),
          ],
          'peopleToLastNameList': peopleToNameList,
        }),
        'A,B,C');
  });

  test('testing nested functions', () {
    expect(
        testExpressionEvaluatorDTO('stringToLowercase(peopleToLastNameList(people))', {
          'people': [
            Person(name: 'A', emoji: ':-)', address: TEST_ADDRESS),
            Person(name: 'B', emoji: ':-)', address: TEST_ADDRESS),
            Person(name: 'C', emoji: ':-)', address: TEST_ADDRESS),
          ],
          'stringToLowercase': stringToLowercase,
          'peopleToLastNameList': peopleToNameList,
        }),
        'a,b,c');
  });

  /// This is currently not supported. Some thought required to make this work
  // test('testing chaining functions', () {
  //   expect(
  //       testExpressionEvaluatorDTO('peopleToLastNameList(people).toString()', {
  //         'people': [
  //           Person(lastName: 'A'),
  //           Person(lastName: 'B'),
  //           Person(lastName: 'C'),
  //         ],
  //         'stringToLowercase': stringToLowercase,
  //         'peopleToLastNameList': peopleToLastNameList,
  //       }),
  //       'a,b,c');
  // });
}
