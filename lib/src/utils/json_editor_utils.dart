import 'dart:convert';
import 'package:flutter_localization_generator/src/utils/json_formatter.dart';

String content = '{\n  "hello": "Hello World"\n}';
var jsonMapEntries = <Tuple<String, String>>[Tuple("hello", "Hello World")];

class Tuple<K, V> {
  K first;
  V second;
  Tuple(this.first, this.second);
}

void updateContentFromMap() {
  final map = <String, String>{};

  jsonMapEntries.forEach((element) {
    if (element.first.isNotEmpty) map[element.first] = element.second;
  });
  content = formatJson(json.encode(map));
}

Future<void> updateJsonContent(String value) async {
  try {
    var jsonContent = await jsonDecode(value);
    jsonContent.forEach((key, value) {
      jsonMapEntries.add(Tuple(key, value));
    });
    content = formatJson(value);
  } catch(e) {
    throw e;
  }
}

startNewJsonMapEntry(){
  jsonMapEntries = [];
}

String fileName = 'untitled.json';
