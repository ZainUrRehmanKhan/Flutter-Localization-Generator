import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/utils/ui_utils.dart';
import 'package:flutter_localization_generator/src/utils/arb_files_generator.dart';
import 'package:flutter_localization_generator/src/ui/widget/loading_animation.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: generate(),
      builder: (context, snapshot) {
        return Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: snapshot.connectionState != ConnectionState.done
                ? [
                    LoadingAnimation(
                        duration: Duration(milliseconds: 1000),
                        size: 40,
                        color: defaultColorEditor,
                        type: LoadingAnimationType.simple),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Downloading of localization files will start automatically!',
                        style: TextStyle(
                            color: defaultColorEditor,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'monospace',
                            fontSize: 25),
                      ),
                    )
                  ]
                : [
                    Icon(CupertinoIcons.checkmark_seal_fill,
                        size: 40, color: defaultColorEditor),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Files Generation Successfully Completed!',
                        style: TextStyle(
                            color: defaultColorEditor,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'monospace',
                            fontSize: 25),
                      ),
                    )
                  ],
          ),
        );
      },
    );
  }
}
