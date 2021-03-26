import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/widget/json_editor.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';

class UploadFileInputView extends StatefulWidget {
  @override
  _UploadFileInputViewState createState() => _UploadFileInputViewState();
}

class _UploadFileInputViewState extends State<UploadFileInputView> {
  @override
  Widget build(BuildContext context) {
    return JsonEditor(selectedIndex: InputType.UploadFile);
  }
}
