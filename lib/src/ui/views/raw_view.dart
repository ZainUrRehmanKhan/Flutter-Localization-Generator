import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';
import 'package:flutter_localization_generator/src/ui/widget/editor_wrapper.dart';
import 'package:flutter_localization_generator/src/ui/widget/editor_background.dart';

class RawInputView extends StatefulWidget {
  @override
  _RawInputViewState createState() => _RawInputViewState();
}

class _RawInputViewState extends State<RawInputView> {
  bool edit = false;
  String jsonParsingError = '';
  TextEditingController jsonEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final buffer = StringBuffer('{\n');
    for (final iterator = jsonMapEntries.iterator..moveNext();;) {
      final element = iterator.current;

      buffer.write('  "${element.first}": "${element.second}"');
      if (iterator.moveNext()) {
        buffer.writeln(',');
      } else {
        buffer.writeln();
        break;
      }
    }

    buffer.writeln('}');
    jsonEditingController.text = buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return EditorWrapper(
      children: [
        EditorBackground(
          edit: edit,
          child: Container(
            padding: EdgeInsets.only(
              right: 10,
              left: 10,
              top: 10,
              bottom: 50,
            ),
            child: TextField(
              maxLines: 1000,
              readOnly: !edit,
              decoration: InputDecoration(border: InputBorder.none),
              controller: jsonEditingController,
              cursorColor: Colors.green,
              autofocus: true,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 13,
                color: edit ? Colors.black : Colors.white,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(-20, -40),
          child: Align(
            alignment: Alignment.centerRight,
            child: editRawButton(),
          ),
        ),
      ],
      jsonParsingError: jsonParsingError,
    );
  }

  /// Creates the edit button and the save button ("OK") with a
  /// particular function [press] to execute.
  ///
  /// This button won't appear if `edit = false`.
  Widget editRawButton() {
    return ElevatedButton(
      onPressed: () {
        try {
          edit = !edit;
          if (!edit) {
            startNewJsonMapEntry();
            updateJsonContent(jsonEditingController.text);
            jsonParsingError = '';
            setState(() {});
          }
        } on FormatException catch (e) {
          edit = !edit;
          jsonParsingError = e.toString();
          print(jsonParsingError);
        }
        setState(() {});
      },
      child: Text(
        edit ? 'Save' : 'Edit',
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: "monospace",
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.grey[200]),
          minimumSize:
              MaterialStateProperty.resolveWith((states) => Size(90, 35))),
    );
  }
}
