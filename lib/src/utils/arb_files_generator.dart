import 'dart:html' as html;
import 'locale_utils.dart';
import 'package:translator/translator.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';

Future<void> generate() async {
  final json = <String, dynamic>{};

  jsonMapEntries.forEach((element) {
    json[element.first] = element.second;
  });

  for (var locale in toLocales) {
    String localeContent = '{\n  "@@locale": "$locale",\n';

    var length = json.keys.length;
    var count = 0;

    for (var key in json.keys) {
      count++;
      localeContent += '\n  "$key": "'
          '${locale == fromLocale ? json[key] : await getTranslation(json[key], locale)}",\n  "@$key": {}';

      if (length != count) localeContent += ',';
      localeContent += '\n';
    }

    localeContent += '}';

    html.AnchorElement(
      href: html.Url.createObjectUrlFromBlob(html.Blob([localeContent], 'text/plain', 'native')).toString(),
    )
      ..setAttribute("download", "app_$locale.arb")
      ..click();
  }

  toLocales.clear();
}

Future<String> getTranslation(String text, String to) async {
  return (await text.translate(to: to, from: fromLocale)).text;
}
