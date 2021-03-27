import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';
import 'package:flutter_localization_generator/src/ui/widget/editor_background.dart';

import '../widget/editor_wrapper.dart';

class FormDataInputView extends StatefulWidget {
  @override
  _FormDataInputViewState createState() => _FormDataInputViewState();
}

class _FormDataInputViewState extends State<FormDataInputView> {
  String jsonParsingError = '';
  List<TableRow> rowList = [];

  @override
  void initState() {
    super.initState();

    for (var index = 0; index < jsonMapEntries.length; ++index) {
      addRow(index: index);
    }
  }

  addRow({@required int index}) {
    rowList.add(TableRow(children: [
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
      ),
      onSaved: (newValue) {
        if (isKey) {
          if (newValue != jsonMapEntries[index].key.toString()) {
            jsonMapEntries.removeAt(index);
            jsonMapEntries.insert(index,
                MapEntry(newValue, jsonMapEntries[index].value.toString()));
          }
        } else {
          if (newValue != jsonMapEntries[index].value.toString()) {
            jsonMapEntries.removeAt(index);
            jsonMapEntries.insert(index,
                MapEntry(jsonMapEntries[index].key.toString(), newValue));
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
        child: EditorBackground(
            false,
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.white60,
              ),
              child: Table(
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
            )),
        jsonParsingError: jsonParsingError);
  }
}
