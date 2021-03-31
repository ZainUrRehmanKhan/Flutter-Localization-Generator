import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';
import 'package:flutter_localization_generator/src/ui/widget/dialog_button.dart';
import 'package:flutter_localization_generator/src/ui/widget/editor_wrapper.dart';
import 'package:flutter_localization_generator/src/ui/widget/editor_background.dart';
import 'package:flutter_localization_generator/src/ui/widget/custom_icon_button.dart';

class FormDataInputView extends StatefulWidget {
  @override
  _FormDataInputViewState createState() => _FormDataInputViewState();
}

class _FormDataInputViewState extends State<FormDataInputView> {
  String jsonParsingError = '';
  final _formKey = GlobalKey<FormState>();
  List<TableRow> rowList = [];
  BuildContext myContext;

  @override
  void initState() {
    super.initState();

    for (var index = 0; index < jsonMapEntries.length; ++index) {
      addRow(index: index);
    }
  }

  int addJsonMapEntry() {
    jsonMapEntries.add(MapEntry('', ''));
    return jsonMapEntries.length - 1;
  }

  addRow({@required int index}) {
    rowList.add(TableRow(children: [
      Container(
          height: 50,
          child: Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                child: Icon(
                  CupertinoIcons.delete,
                  color: Colors.redAccent,
                  size: 20,
                ),
                onTap: () {
                  showAlertDialog(myContext, index);
                },
              ))),
      forInputTextField(index, true),
      forInputTextField(index, false),
    ]));
    setState(() {});
  }

  Widget forInputTextField(int index, bool isKey) {
    return TextFormField(
      initialValue: isKey
          ? jsonMapEntries[index].key.toString()
          : jsonMapEntries[index].value.toString(),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: isKey ? 'Enter a key' : 'Enter a value',
          hintStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text here';
        }
        return null;
      },
      onSaved: (newValue) {
        String oldKey = jsonMapEntries[index].key.toString();
        String oldValue = jsonMapEntries[index].value.toString();

        if (isKey) {
          if (newValue != oldKey) {
            jsonMapEntries.removeAt(index);
            jsonMapEntries.length != 0
                ? jsonMapEntries.insert(index, MapEntry(newValue, oldValue))
                : jsonMapEntries.add(MapEntry(newValue, oldValue));
          }
        } else {
          if (newValue != oldValue) {
            jsonMapEntries.removeAt(index);
            jsonMapEntries.length != 0
                ? jsonMapEntries.insert(index, MapEntry(oldKey, newValue))
                : jsonMapEntries.add(MapEntry(oldKey, newValue));
          }
        }

        updateContentFromMap();
        setState(() {});
      },
      cursorColor: Colors.white38,
      style: TextStyle(
        color: Colors.grey[400],
        fontFamily: 'monospace',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    myContext = context;

    return EditorWrapper(
        child: Column(
          children: [
            EditorBackground(
                child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.white60,
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 50),
                height: 300,
                child: Form(
                  key: _formKey,
                  child: Table(
                    columnWidths: {0: FixedColumnWidth(60)},
                    border: TableBorder(
                        horizontalInside: BorderSide(
                            width: 0.2,
                            color: Colors.white38,
                            style: BorderStyle.solid),
                        bottom: BorderSide(
                            width: 0.2,
                            color: Colors.white38,
                            style: BorderStyle.solid)),
                    children: [
                      TableRow(
                        children: [
                          Text(''),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text('Key',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'monospace')),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text('Value',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'monospace')),
                          ),
                        ],
                      ),
                      ...rowList,
                    ],
                  ),
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconButton(
                      title: 'Add a Row',
                      icon: CupertinoIcons.add_circled,
                      onTap: () {
                        addRow(index: addJsonMapEntry());
                        setState(() {});
                      }),
                  CustomIconButton(
                      title: 'Save',
                      icon: CupertinoIcons.tray_full,
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                        }
                      }),
                ],
              ),
            )
          ],
        ),
        jsonParsingError: jsonParsingError);
  }

  deleteRow(int index) {
    jsonMapEntries.removeAt(index);
    rowList.removeAt(index);
    updateContentFromMap();
    setState(() {});
  }

  showAlertDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text("Would you like to delete this row?"),
          actions: [
            DialogButton(
                title: 'Cancel',
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            DialogButton(
                title: 'Continue',
                onPressed: () {
                  deleteRow(index);
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}
