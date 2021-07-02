import 'dart:convert';

var jsonMapEntries = <Tuple<String, String>>[Tuple("hello", "Hello World")];

class Tuple<K, V> {
  K first;
  V second;
  Tuple(this.first, this.second);
}

void updateJsonContent(String value) {
  try {
    var jsonContent = jsonDecode(value);
    jsonContent.forEach((key, value) {
      jsonMapEntries.add(Tuple(key, value));
    });
  } catch(e) {
    rethrow;
  }
}

startNewJsonMapEntry(){
  jsonMapEntries = [];
}

String fileName = 'untitled.json';
