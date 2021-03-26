import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/widget/json_editor.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';

class RawInputView extends StatefulWidget {
  @override
  _RawInputViewState createState() => _RawInputViewState();
}

class _RawInputViewState extends State<RawInputView> {
  @override
  Widget build(BuildContext context) {
    return JsonEditor(selectedIndex: InputType.Raw);
  }
}
