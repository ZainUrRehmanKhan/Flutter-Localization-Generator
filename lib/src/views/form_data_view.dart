import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/widget/json_editor.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';

class FormDataInputView extends StatefulWidget {
  @override
  _FormDataInputViewState createState() => _FormDataInputViewState();
}

class _FormDataInputViewState extends State<FormDataInputView> {
  @override
  Widget build(BuildContext context) {
    return JsonEditor(selectedIndex: InputType.FormData);
  }
}
