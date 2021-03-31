import 'package:flutter/material.dart';
import 'package:flutter_localization_generator/src/utils/ui_utils.dart';

class DialogButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  DialogButton({@required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(title),
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => defaultColorEditor),
      ),
      onPressed: onPressed,
    );
  }
}
