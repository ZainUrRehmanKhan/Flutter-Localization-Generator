import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localization_generator/src/utils/json_formatter.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';

class JsonEditor extends StatefulWidget {
  final InputType selectedIndex;

  JsonEditor({@required this.selectedIndex});

  @override
  _JsonEditorState createState() => _JsonEditorState();
}

class _JsonEditorState extends State<JsonEditor> {
  bool edit = false;
  TextEditingController jsonEditingController = TextEditingController();
  String jsonParsingError = '';
  List<TableRow> rowList = [];

  @override
  void initState() {
    super.initState();
    jsonEditingController.text = content;

    Map<String, dynamic> jsonContent = jsonDecode(content);
    jsonContent.forEach((key, value) {
      addRow(key: key, value: value);
    });
  }

  addRow({String key, String value}) {
    rowList.add(TableRow(children: [
      customDataCell(key),
      customDataCell(value),
    ]));
    setState(() {});
  }

  Widget customDataCell(String data) {
    return TextFormField(
      initialValue: data ?? '',
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      cursorColor: Colors.white38,
      style: TextStyle(
        color: Colors.grey[400],
        fontFamily: 'monospace',
      ),
    );
  }

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
          getEditorFromInputType(),
          Container(
            height: 30,
            child: Center(
                child: Text(
              jsonParsingError,
              style: TextStyle(color: Colors.redAccent),
            )),
          )
        ],
      ),
    );
  }

  Widget getEditorFromInputType() {
    switch (widget.selectedIndex) {
      case InputType.FormData:
        return formDataInput();
      case InputType.Raw:
        return rawInput();
      case InputType.UploadFile:
        return uploadFileInput();
    }
    return SizedBox.shrink();
  }

  Widget editorBackground(Widget childWidget) {
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

  /// Creates the edit button and the save button ("OK") with a
  /// particular function [press] to execute.
  ///
  /// This button won't appear if `edit = false`.
  Widget editButton() {
    return Positioned(
      bottom: 10,
      right: 15,
      child: ElevatedButton(
        onPressed: () {
          try {
            edit = !edit;
            if (!edit) {
              jsonDecode(jsonEditingController.text);
              content = formatJson(jsonEditingController.text);
              jsonEditingController.text = content;
              jsonParsingError = '';
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

  Widget rawInput() {
    return Stack(
      children: [
        editorBackground(edit
            ? Container(
                padding: EdgeInsets.only(
                  right: 10,
                  left: 10,
                  top: 10,
                  bottom: 50,
                ),
                child: TextField(
                  maxLines: 1000,
                  controller: jsonEditingController,
                  cursorColor: Colors.green,
                  autofocus: true,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w200),
                ),
              )
            : Text(
                '\n' + content,
                style: TextStyle(
                    fontFamily: "monospace",
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w100,
                    fontSize: 13,
                    color: Colors.grey[200]),
              )),
        editButton(),
      ],
    );
  }

  Widget formDataInput() {
    return editorBackground(
      Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.white60,
        ),
        child: Table(
          border: TableBorder(
              horizontalInside: BorderSide(
                  width: 0.2, color: Colors.white38, style: BorderStyle.solid),
              bottom: BorderSide(
                  width: 0.2, color: Colors.white38, style: BorderStyle.solid)),
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text('Key',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'monospace')),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text('Value',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'monospace')),
                ),
              ],
            ),
            ...rowList,
          ],
        ),
      ),
    );
  }

  Widget uploadFileInput() {
    return SizedBox.shrink();
  }
}
