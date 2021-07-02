import 'dart:html';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/ui/widget/dashed_rect.dart';
import 'package:flutter_localization_generator/src/ui/widget/dialog_button.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';
import 'package:flutter_localization_generator/src/ui/widget/editor_wrapper.dart';
import 'package:flutter_localization_generator/src/ui/widget/editor_background.dart';

enum _DragState {
  dragging,
}

class UploadFileInputView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UploadFileInputViewState();
  }
}

class _UploadFileInputViewState extends State<StatefulWidget> {
  StreamSubscription<MouseEvent> _onDragOverSubscription;
  StreamSubscription<MouseEvent> _onDropSubscription;

  final StreamController<Point<double>> _pointStreamController =
      new StreamController<Point<double>>.broadcast();
  final StreamController<_DragState> _dragStateStreamController =
      new StreamController<_DragState>.broadcast();

  File _file;
  String jsonParsingError = '';

  @override
  void dispose() {
    this._onDropSubscription.cancel();
    this._onDragOverSubscription.cancel();
    this._pointStreamController.close();
    this._dragStateStreamController.close();
    super.dispose();
  }

  void _onDrop(MouseEvent value) {
    value.stopPropagation();
    value.preventDefault();
    _pointStreamController.sink.add(null);

    _addFile(value.dataTransfer.files);
  }

  void showFileTypeError() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Invalid Upload'),
          content: Text('File type must be .json'),
          actions: [
            DialogButton(
              title: 'Close',
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void showMultiFileError() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Invalid Upload'),
          content: Text('You can\'t upload multiple files.'),
          actions: [
            DialogButton(
              title: 'Close',
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _addFile(List<File> newFiles) {
    if (newFiles.length > 1) {
      showMultiFileError();
    } else if (newFiles[0].type != 'application/json') {
      showFileTypeError();
    } else {
      this.setState(() {
        this._file = newFiles[0];
        fileName = this._file.name;

        var fileReader = FileReader();
        fileReader.onLoadEnd.listen(((ProgressEvent _) {
          onFilePicked(fileReader.result);
        }));

        fileReader.readAsText(_file);
      });
    }
  }

  void _onDragOver(MouseEvent value) {
    value.stopPropagation();
    value.preventDefault();
    this
        ._pointStreamController
        .sink
        .add(Point<double>(value.layer.x.toDouble(), value.layer.y.toDouble()));
    this._dragStateStreamController.sink.add(_DragState.dragging);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      this._onDropSubscription = document.body.onDrop.listen(_onDrop);
      this._onDragOverSubscription =
          document.body.onDragOver.listen(_onDragOver);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EditorWrapper(
      jsonParsingError: jsonParsingError,
      children: [
        EditorBackground(
          child: InkWell(
            onTap: () async {
              InputElement uploadInput = FileUploadInputElement();
              uploadInput.click();

              uploadInput.onChange.listen((e) {
                _addFile(uploadInput.files);
              });
            },
            child: Center(
              child: Container(
                height: 320,
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: CustomPaint(
                    painter: DashRectPainter(
                      color: Colors.white38,
                      strokeWidth: 3.0,
                      gap: 6.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.cloud_upload_fill,
                          size: 60,
                          color: Colors.white60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Drop your file here, or ',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                color: Colors.white60,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Browse',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                color: Colors.lightBlue,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Supports: .json',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.white60,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Widget> onFilePicked(String result) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
              'Do you want to merge this file in your work\nor a new start?'),
          actions: [
            DialogButton(
                title: 'Merge',
                onPressed: () async {
                  jsonParsingError = '';
                  try {
                    updateJsonContent(result);
                  } catch (e) {
                    jsonParsingError = e.toString();
                  }
                  setState(() {});
                  Navigator.of(context).pop();
                }),
            DialogButton(
              title: 'New Start',
              onPressed: () {
                jsonParsingError = '';
                startNewJsonMapEntry();
                try {
                  updateJsonContent(result);
                } catch (e) {
                  jsonParsingError = e.toString();
                }
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
