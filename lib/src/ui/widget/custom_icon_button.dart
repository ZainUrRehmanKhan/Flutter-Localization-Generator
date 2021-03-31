import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/utils/ui_utils.dart';

class CustomIconButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  CustomIconButton(
      {@required this.title, @required this.icon, @required this.onTap});

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 55,
        width: 150,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: defaultColorEditor,
            borderRadius: BorderRadius.all(Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[400],
                  offset: Offset(1, 1),
                  spreadRadius: 1,
                  blurRadius: 3)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.title,
                style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 15,
                    fontFamily: 'monospace')),
            VerticalDivider(
              color: Colors.grey[200],
              width: 0.2,
              thickness: 0.2,
            ),
            Icon(
              widget.icon,
              color: Colors.grey[200],
            )
          ],
        ),
      ),
    );
  }
}
