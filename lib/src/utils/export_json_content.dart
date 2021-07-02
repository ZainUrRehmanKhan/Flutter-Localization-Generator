import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter_localization_generator/src/utils/json_formatter.dart';

import 'json_editor_utils.dart';

void exportJson() {
  final json = <String, dynamic>{};
  jsonMapEntries.forEach((element) {
    json[element.first] = element.second;
  });

  var blob = html.Blob([formatJson(jsonEncode(json))], 'text/plain', 'native');

  html.AnchorElement(
    href: html.Url.createObjectUrlFromBlob(blob).toString(),
  )
    ..setAttribute("download", 'localization-export-' + DateTime.now().toLocal().toString().split('.').first + '.json')
    ..click();
}