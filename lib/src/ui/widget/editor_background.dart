import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';

class EditorBackground extends StatelessWidget {
  final bool edit;
  final Widget childWidget;

  EditorBackground(this.edit, this.childWidget);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: edit ? Colors.white : defaultColorEditor,
        border: Border(bottom: BorderSide(color: defaultColorBorder)),
      ),
      child: SingleChildScrollView(child: childWidget),
    );
  }
}
