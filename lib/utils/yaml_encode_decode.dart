import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

/// Considering the benefits of using YAML instead of JSON for defining recipes.
Future<Map<String, dynamic>> yamlFileToJsonMap(filePath) {
  var completer = Completer<Map<String, dynamic>>();

  File(filePath).openRead().transform(utf8.decoder).toList().then((lines) {
    final yamlString = lines.join();
    final doc = loadYaml(yamlString);
    final jsonString = jsonEncode(doc);
    final jsonMap = jsonDecode(jsonString);
    completer.complete(jsonMap);
  });

  return completer.future;
}

/// For the time being, sticking with JSON for the recipe definition files.
Future<Map<String, dynamic>> jsonFileToJsonMap(filePath) {
  var completer = Completer<Map<String, dynamic>>();

  File(filePath).openRead().transform(utf8.decoder).toList().then((lines) {
    final jsonString = lines.join();
    final jsonMap = jsonDecode(jsonString);
    completer.complete(jsonMap);
  });

  return completer.future;
}

/// For the time being, sticking with JSON for the recipe definition files.
Future<List<dynamic>> jsonFileToJsonList(filePath) {
  var completer = Completer<List<dynamic>>();

  File(filePath).openRead().transform(utf8.decoder).toList().then((lines) {
    final jsonString = lines.join();
    final jsonList = jsonDecode(jsonString);
    completer.complete(jsonList);
  });

  return completer.future;
}
