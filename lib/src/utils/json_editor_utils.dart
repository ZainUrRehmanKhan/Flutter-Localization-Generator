import 'dart:convert';
import 'package:flutter_localization_generator/src/utils/json_formatter.dart';

String content = '{\n  "hello": "Hello World"\n}';
var jsonMapEntries = <MapEntry<String, dynamic>>[MapEntry("hello", "Hello World")];

void updateContentFromMap(){
  Map<String, dynamic> map = {};
  map.addEntries(jsonMapEntries);

  content = formatJson(json.encode(map));
}

Future<void> updateJsonContent(String value) async {
  try{
    Map<String, dynamic> jsonContent = await jsonDecode(value);
    jsonContent.forEach((key, value) {
      jsonMapEntries.add(MapEntry(key, value));
    });

    updateContentFromMap();
  } catch(e){
    throw e;
  }
}

startNewJsonMapEntry(){
  jsonMapEntries = [];
}

String fileName = 'untitled.json';
