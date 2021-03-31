import 'dart:convert';
import 'dart:html' as html;
import 'locale_utils.dart';
import 'package:translator/translator.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';

Future<void> generate() async {
  if (content.trim() != '') {
    Map<String, dynamic> decoded = json.decode(content);

    for (var locale in toLocales) {
      String localeContent = '{\n  "@@locale": "$locale",\n';

      var length = decoded.keys.length;
      var count = 0;

      for (var key in decoded.keys) {
        count++;
        localeContent += '\n  "$key": "'
            '${locale == fromLocale ? decoded[key] : await getTranslation(decoded[key], locale)}",\n  "@$key": {}';

        if (length != count) content += ',';

        localeContent += '\n';
      }

      localeContent += '}';

      var blob = html.Blob([localeContent], 'text/plain', 'native');

      html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(blob).toString(),
      )
        ..setAttribute("download", "app_$locale.arb")
        ..click();
    }
  }
  toLocales.clear();
}

Future<String> getTranslation(String text, String to) async {
  return (await text.translate(to: to, from: fromLocale)).text;
}

void exportJson() {
  var blob = html.Blob([content], 'text/plain', 'native');

  html.AnchorElement(
    href: html.Url.createObjectUrlFromBlob(blob).toString(),
  )
    ..setAttribute("download", "localization_export.json")
    ..click();
}
