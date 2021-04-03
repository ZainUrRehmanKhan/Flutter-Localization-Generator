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

class _FormDataInputViewState extends State<FormDataInputView>{
  String jsonParsingError = '';
  final _formKey = GlobalKey<FormState>();
  List<TableRow> rowList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      generateTableRows();
    });
  }

  void generateTableRows() {
    rowList = [];
    for (var index = 0; index < jsonMapEntries.length; ++index) {
      addRow(index: index);
    }
  }

  void addRow({@required int index}) {
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
                  checkIndexExists(index) ? showDeleteRowDialog(context, index) : deleteRow(index);
                },
              ))),
      rowInputTextField(index, true),
      rowInputTextField(index, false),
    ]));
    setState(() {});
  }

  ///TODO Row Deletion problem
  ///TODO problem while deleting non saved rows (delete second last and then last for exception)

  void deleteRow(int index) {
    rowList.removeAt(index);
    if(checkIndexExists(index)){
      jsonMapEntries.removeAt(index);
      updateContentFromMap();
    }
    setState(() {});
  }

  bool checkIndexExists(int index){
    return !(index >= jsonMapEntries.length);
  }

  TextFormField rowInputTextField(int index, bool isKey) {
    return TextFormField(
      initialValue: isKey
          ? checkIndexExists(index) ? jsonMapEntries[index].key.toString() : ''
          : checkIndexExists(index) ? jsonMapEntries[index].value.toString() : '',
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
        String oldKey = '';
        String oldValue = '';
        if(index >= jsonMapEntries.length){
          jsonMapEntries.add(MapEntry('', ''));
        }
        else{
          oldKey = jsonMapEntries[index].key.toString();
          oldValue = jsonMapEntries[index].value.toString();
        }

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
    return EditorWrapper(
        child: Column(
          children: [
            EditorBackground(
                child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.white60,
              ),
              child: Container(
                height: 350,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
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
                        addRow(index: rowList.length);
                        setState(() {});
                      }),
                  CustomIconButton(
                      title: 'Save',
                      icon: CupertinoIcons.tray_full,
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          updateContentFromMap();
                          setState(() {});
                        }
                      }),
                ],
              ),
            )
          ],
        ),
        jsonParsingError: jsonParsingError);
  }

  void showDeleteRowDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text("Are you sure you want to delete this row,\nthis action will discard unsaved changes?"),
          actions: [
            DialogButton(
              title: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
            DialogButton(
              title: 'Continue',
              onPressed: () {
                deleteRow(index);
                Navigator.of(context).pop();
              }
            ),
          ],
        );
      },
    );
  }
}
