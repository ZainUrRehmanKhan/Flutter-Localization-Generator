import 'dart:html' as html;
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';

void exportJson() {
  var blob = html.Blob([content], 'text/plain', 'native');

  html.AnchorElement(
    href: html.Url.createObjectUrlFromBlob(blob).toString(),
  )
    ..setAttribute("download", 'localization-export-' + DateTime.now().toLocal().toString().split('.').first + '.json')
    ..click();
}