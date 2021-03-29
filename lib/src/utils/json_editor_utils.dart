import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/utils/json_formatter.dart';

const Color defaultColorEditor = Color(0xff2E3152);
const Color defaultColorBorder = Color(0xFF3E416E);
const Color defaultColorFileName = Color(0xFF6CD07A);

const github = 'assets/github.png';

String email;

String content = '{\n  "hello": "Hello World"\n}';
var jsonMapEntries = <MapEntry<String, dynamic>>[MapEntry("hello", "Hello World")];

void updateContentFromMap(){
  Map<String, dynamic> map = {};
  map.addEntries(jsonMapEntries);

  content = formatJson(json.encode(map));
}

void updateJsonContent(String value) {
  content = value;
  Map<String, dynamic> jsonContent = jsonDecode(value);
  jsonMapEntries = [];
  jsonContent.forEach((key, value) {
    jsonMapEntries.add(MapEntry(key, value));
  });
}

Map<String, String> locales = {
  "Afrikaans": "af",
  "Albanian": "sq",
  "Amharic": "am",
  "Arabic": "ar",
  "Armenian": "hy",
  "Azerbaijani": "az",
  "Basque": "eu",
  "Belarusian": "be",
  "Bengali": "bn",
  "Bosnian": "bs",
  "Bulgarian": "bg",
  "Catalan": "ca",
  "Cebuano": "ceb",
  "Chinese (Simplified)": "zh-CN",
  "Chinese (Traditional)": "zh-TW",
  "Corsican": "co",
  "Croatian": "hr",
  "Czech": "cs",
  "Danish": "da",
  "Dutch": "nl",
  "English": "en",
  "Esperanto": "eo",
  "Estonian": "et",
  "Finnish": "fi",
  "French": "fr",
  "Frisian": "fy",
  "Galician": "gl",
  "Georgian": "ka",
  "German": "de",
  "Greek": "el",
  "Gujarati": "gu",
  "Haitian Creole": "ht",
  "Hausa": "ha",
  "Hawaiian": "haw",
  "Hebrew": "he",
  "Hindi": "hi",
  "Hmong": "hmn",
  "Hungarian": "hu",
  "Icelandic": "is",
  "lgbo": "ig",
  "Indonesian": "id",
  "Irish": "ga",
  "Italian": "it",
  "japanese": "ja",
  "javanese": "jv",
  "Kannada": "kn",
  "Kazakh": "kk",
  "Khmer": "km",
  "Kinyarwanda": "rw",
  "Korean": "ko",
  "Kurdish": "ku",
  "Kyrgyz": "ky",
  "Lao": "lo",
  "Latin": "la",
  "Latvian": "lv",
  "Lithuanian": "lt",
  "Luxembourgish": "lb",
  "Macedonian": "mk",
  "Malagasy": "mg",
  "Malay": "ms",
  "Malayalam": "ml",
  "Maltese": "mt",
  "Maori": "mi",
  "Marathi": "mr",
  "Mongolian": "mn",
  "Myanmar (Burmese)": "my",
  "Nepali": "ne",
  "Norwegian": "no",
  "Nyanja (Chichewa)": "ny",
  "Odia (Oriya)": "or",
  "Pashto": "ps",
  "Persian": "fa",
  "Polish": "pl",
  "Portuguese (Portugal, Brazil)": "pt",
  "Punjabi": "pa",
  "Romanian": "ro",
  "Russian": "ru",
  "Samoan": "sm",
  "Scots Gaelic": "gd",
  "Serbian": "sr",
  "Sesotho": "st",
  "Shona": "sn",
  "Sindhi": "sd",
  "Sinhala (Sinhalese)": "si",
  "Slovak": "sk",
  "Slovenian": "sl",
  "Somali": "so",
  "Spanish": "es",
  "Sundanese": "su",
  "Swahili": "sw",
  "Swedish": "sv",
  "Tagalog (Filipino)": "tl",
  "Tajik": "tg",
  "Tamil": "ta",
  "Tatar": "tt",
  "Telugu": "te",
  "Thai": "th",
  "Turkish": "tr",
  "Turkmen": "tk",
  "Ukrainian": "uk",
  "Urdu": "ur",
  "Uyghur": "ug",
  "Uzbek": "uz",
  "Vietnamese": "vi",
  "Welsh": "cy",
  "Xhosa": "xh",
  "Yiddish": "yi",
  "Yoruba": "uo",
  "Zulu": "zu",
};

List<String> localesKeyList = locales.keys.toList();
List<String> localesValueList = locales.values.toList();

List<String> toLocales = [];
String fromLocale = 'en';
const String fileName = 'untitled.json';

enum InputType { FormData, Raw, UploadFile }
