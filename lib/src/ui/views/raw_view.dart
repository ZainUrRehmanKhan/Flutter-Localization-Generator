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
    jsonEditingController.text = content;
  }

  @override
  Widget build(BuildContext context) {
    return EditorWrapper(
      child: Stack(
        children: [
          EditorBackground(
              edit: edit,
              child: edit
                  ? Container(
                padding: EdgeInsets.only(
                        right: 10,
                        left: 10,
                        top: 10,
                        bottom: 50,
                      ),
                      height: 350,
                      child: TextField(
                        maxLines: 1000,
                        decoration: InputDecoration(border: InputBorder.none),
                        controller: jsonEditingController,
                        cursorColor: Colors.green,
                        autofocus: true,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w200),
                      ),
                    )
                  : Container(
                height: 350,
                      child: Text(
                        '\n' + content,
                        style: TextStyle(
                            fontFamily: "monospace",
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w100,
                            fontSize: 13,
                            color: Colors.grey[200]),
                      ),
                    )),
          editRawButton(),
        ],
      ),
      jsonParsingError: jsonParsingError,
    );
  }

  /// Creates the edit button and the save button ("OK") with a
  /// particular function [press] to execute.
  ///
  /// This button won't appear if `edit = false`.
  Widget editRawButton() {
    return Positioned(
      bottom: 10,
      right: 15,
      child: ElevatedButton(
        onPressed: () {
          try {
            edit = !edit;
            if (!edit) {
              startNewJsonMapEntry();
              updateJsonContent(jsonEditingController.text);
              jsonEditingController.text = content;
              jsonParsingError = '';
              setState(() {});
            }
          } catch (e) {
            edit = !edit;
            jsonParsingError = e.toString();
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
      ),
    );
  }
}
