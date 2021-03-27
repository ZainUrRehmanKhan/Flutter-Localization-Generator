import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';

class EditorWrapper extends StatefulWidget {
  final Widget child;
  final String jsonParsingError;

  EditorWrapper({this.child, this.jsonParsingError});

  @override
  _EditorWrapperState createState() => _EditorWrapperState();
}

class _EditorWrapperState extends State<EditorWrapper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 22, horizontal: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: defaultColorEditor,
              border: Border(bottom: BorderSide(color: defaultColorBorder)),
            ),
            child: Text(
              fileName,
              style: TextStyle(
                  fontFamily: "monospace",
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: defaultColorFileName),
            ),
          ),
          Divider(
            height: 0.1,
            thickness: 0.1,
            color: Colors.white60,
          ),
          widget.child,
          Container(
            height: 30,
            child: Center(
                child: Text(
              widget.jsonParsingError,
              style: TextStyle(color: Colors.redAccent),
            )),
          )
        ],
      ),
    );
  }
}
