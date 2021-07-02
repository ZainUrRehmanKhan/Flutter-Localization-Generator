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

  TextFormField rowInputTextField(
    String initialValue,
    String hint,
    TextEditingController controller,
    FormFieldSetter<String> onSaved,
  ) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text here';
        }
        return null;
      },
      onSaved: onSaved,
      controller: controller,
      cursorColor: Colors.white38,
      style: TextStyle(color: Colors.grey[400], fontFamily: 'monospace'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditorWrapper(
      children: [
        EditorBackground(
            child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.white60,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Table(
                columnWidths: {0: FixedColumnWidth(60)},
                border: TableBorder(
                  horizontalInside: BorderSide(
                    width: 0.2,
                    color: Colors.white38,
                    style: BorderStyle.solid,
                  ),
                  bottom: BorderSide(
                    width: 0.2,
                    color: Colors.white38,
                    style: BorderStyle.solid,
                  ),
                ),
                children: [
                  TableRow(
                    children: [
                      Text(''),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          'Key',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          'Value',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (final row in jsonMapEntries)
                    TableRow(
                      children: [
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
                                showDeleteRowDialog(context, () {
                                  jsonMapEntries.remove(row);
                                  jsonMapEntries = List.from(jsonMapEntries);
                                  setState(() {});
                                });
                              },
                            ),
                          ),
                        ),
                        rowInputTextField(
                          row.first,
                          'Enter Key',
                          TextEditingController(text: row.first),
                          (val) => row.first = val,
                        ),
                        rowInputTextField(
                          row.second,
                          'Enter Value',
                          TextEditingController(text: row.second),
                          (val) {
                            return row.second = val;
                          },
                        )
                      ],
                    ),
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
                  _formKey.currentState.save();
                  jsonMapEntries.add(Tuple('', ''));
                  setState(() {});
                },
              ),
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
      jsonParsingError: jsonParsingError,
    );
  }

  void showDeleteRowDialog(BuildContext context, VoidCallback onConfirmed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text(
              "Are you sure you want to delete this row,\nthis action will discard unsaved changes?"),
          actions: [
            DialogButton(
              title: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
            DialogButton(
              title: 'Continue',
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmed();
              },
            ),
          ],
        );
      },
    );
  }
}
