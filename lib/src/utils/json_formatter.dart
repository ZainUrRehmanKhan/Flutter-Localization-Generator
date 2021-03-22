import 'dart:convert';

String formatJson(String jsonText){
  Map<String, dynamic> rawJson = jsonDecode(jsonText.trim());
  String formattedJson = "{\n";
  int length = rawJson.length;
  int count = 0;

  rawJson.forEach((key, value) {
    count++;
    formattedJson += '  "$key": "$value"';
    if(count != length)
      formattedJson += ',\n';
    else
      formattedJson += '\n';
  });
  formattedJson += '}';
  return formattedJson;
}