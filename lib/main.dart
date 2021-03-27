import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localization_generator/src/ui/pages/home_page.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Localization Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: defaultColorEditor,
      ),
      home: MyHomePage(title: 'Flutter Localization Generator'),
    );
  }
}
