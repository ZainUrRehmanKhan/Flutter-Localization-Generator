import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/utils/ui_utils.dart';

class EditorBackground extends StatelessWidget {
  final bool edit;
  final Widget child;

  EditorBackground({this.edit = false, @required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: edit ? Colors.white : defaultColorEditor,
          border: Border(bottom: BorderSide(color: defaultColorBorder)),
        ),
        child: child,
        // child: SingleChildScrollView(child: child),
      ),
    );
  }
}
