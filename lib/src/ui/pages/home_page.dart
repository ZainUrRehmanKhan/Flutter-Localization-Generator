import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localization_generator/src/utils/ui_utils.dart';
import 'package:flutter_localization_generator/src/ui/views/raw_view.dart';
import 'package:flutter_localization_generator/src/utils/locale_utils.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';
import 'package:flutter_localization_generator/src/ui/views/form_data_view.dart';
import 'package:flutter_localization_generator/src/utils/export_json_content.dart';
import 'package:flutter_localization_generator/src/services/firebase_service.dart';
import 'package:flutter_localization_generator/src/ui/pages/downloading_page.dart';
import 'package:flutter_localization_generator/src/ui/views/upload_file_view.dart';
import 'package:flutter_localization_generator/src/ui/widget/custom_icon_button.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailEditingController = TextEditingController();
  TabController tabController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          elevation: 0,
          backgroundColor: defaultColorEditor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: SizedBox(
                child: InkWell(
                  child: Image.asset(github),
                  onTap: () {
                    html.window.open(
                        'https://github.com/ZainUrRehmanKhan/Flutter-Localization-Generator',
                        'Flutter Localization Generator');
                  },
                ),
                width: 30,
                height: 30,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: 735,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///
                      /// Email Text Field
                      ///
                      Container(
                        width: 350,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          border:
                              Border.all(color: defaultColorEditor, width: 2),
                        ),
                        child: TextField(
                          controller: emailEditingController,
                          onChanged: (value) async {
                            email = emailEditingController.text;
                          },
                          cursorColor: defaultColorEditor,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'youremail@email.com',
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),

                      ///
                      /// Generate Button
                      ///
                      CustomIconButton(
                        title: 'Generate',
                        icon: CupertinoIcons.gear,
                        onTap: () {
                          if (emailEditingController.text != '' &&
                              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(emailEditingController.text)) {
                            Map<String, dynamic> checkJson =
                                jsonDecode(content);
                            if (checkJson.length == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Not data found!')));
                            } else
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return localeDialog();
                                },
                              );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Invalid Email Address!')));
                          }
                        },
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 0.1,
                  thickness: 0.1,
                  color: defaultColorEditor,
                ),
                Container(
                  color: defaultColorEditor,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 60,
                        child: TabBar(
                          tabs: [
                            Text(
                              'Form Data',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'monospace'),
                            ),
                            Text(
                              'Raw',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'monospace'),
                            ),
                            Text(
                              'Upload File',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'monospace'),
                            ),
                          ],
                          indicatorColor: Colors.white,
                          isScrollable: true,
                          controller: tabController,
                        ),
                      ),
                      ///TODO add change input locale button here
                      ElevatedButton.icon(
                        onPressed: () {
                          exportJson();
                        },
                        icon: Icon(
                          CupertinoIcons.arrow_down_doc_fill,
                          color: defaultColorEditor,
                          size: 15,
                        ),
                        label: Text(
                          'Export',
                          style: TextStyle(fontFamily: 'monospace'),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            foregroundColor: MaterialStateColor.resolveWith(
                                (states) => defaultColorEditor)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      FormDataInputView(),
                      RawInputView(),
                      UploadFileInputView(),
                    ],
                    controller: tabController,
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  height: 80,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Designed & Developed By ',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: 'monospace'),
                          ),
                          InkWell(
                            child: Text(
                              'Zain Ur Rehman',
                              style: TextStyle(
                                  color: defaultColorEditor,
                                  fontFamily: 'monospace'),
                            ),
                            onTap: () => html.window.open(
                                'https://github.com/ZainUrRehmanKhan',
                                'Zain Ur Rehman'),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.copyright_outlined,
                            color: Colors.grey[500],
                            size: 15,
                          ),
                          Text(
                            '2021 copyright',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontFamily: 'monospace'),
                          ),
                          InkWell(
                            child: Text(
                              ' SparkoSol',
                              style: TextStyle(
                                  color: defaultColorEditor,
                                  fontFamily: 'monospace'),
                            ),
                            onTap: () => html.window.open(
                                'https://github.com/SparcoT',
                                'SparkoSol'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget localeDialog() {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          height: 400,
          width: 500,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    child: Icon(
                      CupertinoIcons.clear_thick_circled,
                      color: defaultColorEditor,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
              ),
              Text(
                'Select locales:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    fontSize: 15),
              ),
              Text(
                'Localization files will be generated in the selected locales',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: 'monospace',
                    fontSize: 13),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Scrollbar(
                    isAlwaysShown: true,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return CustomCheckBoxListTile(index: index);
                      },
                      itemCount: localesKeyList.length,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      addAutomaticKeepAlives: true,
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
              CustomIconButton(
                title: 'Proceed',
                icon: CupertinoIcons.arrowtriangle_right_fill,
                onTap: () async {
                  if (toLocales.isNotEmpty) {
                    await addUser();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DownloadPage(),
                    ));
                  }
                },
              ),
              Container(
                height: 30,
                child: Center(
                    child: Text(
                  'Please select atleast one locale to proceed.',
                  style: TextStyle(color: defaultColorEditor),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class CustomCheckBoxListTile extends StatefulWidget {
  final int index;

  CustomCheckBoxListTile({@required this.index});

  @override
  _CustomCheckBoxListTileState createState() => _CustomCheckBoxListTileState();
}

class _CustomCheckBoxListTileState extends State<CustomCheckBoxListTile>
    with AutomaticKeepAliveClientMixin {
  bool check = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CheckboxListTile(
      activeColor: defaultColorEditor,
      title: Text(
        localesKeyList[widget.index] +
            ' ( ' +
            localesValueList[widget.index] +
            ' )',
        style: TextStyle(
            fontSize: 15, fontFamily: 'monospace', fontWeight: FontWeight.w500),
      ),
      value: check,
      onChanged: (value) async {
        value
            ? toLocales.add(localesValueList[widget.index])
            : toLocales.removeWhere(
                (element) => element == localesValueList[widget.index]);
        setState(() {
          check = value;
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
