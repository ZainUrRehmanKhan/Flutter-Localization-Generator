import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localization_generator/src/widget/json_editor.dart';
import 'package:flutter_localization_generator/src/ui/downloading_page.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';
import 'package:flutter_localization_generator/src/widget/custom_icon_button.dart';
import 'package:flutter_localization_generator/src/services/firebase_service.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailEditingController = TextEditingController();
  InputType selected = InputType.FormData;

  onChange(InputType value) {
    setState(() {
      selected = value;
    });
  }

  Widget customRadioListTile(InputType value, String title, Function onChange) {
    return SizedBox(
      width: 200,
      child: RadioListTile(
        value: value,
        groupValue: selected,
        title: Text(title),
        activeColor: defaultColorEditor,
        onChanged: onChange
      )
    );
  }

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
        ),
        body: Column(
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
                      border: Border.all(color: defaultColorEditor, width: 2),
                    ),
                    child: TextField(
                      controller: emailEditingController,
                      onChanged: (value) async{
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
                      if(
                        emailEditingController.text != '' &&
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailEditingController.text)
                      ){
                        Map<String, dynamic> checkJson = jsonDecode(content);
                        if(checkJson.length == 0){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Not data found!')));
                        }
                        else showDialog(
                          context: context,
                          builder: (context) {
                            return localeDialog();
                          },
                        );
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid Email Address!')));
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

            ///
            /// Radio Button Option Row
            ///
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customRadioListTile(
                      InputType.FormData, 'Form Data', onChange),
                  customRadioListTile(InputType.Raw, 'Raw', onChange),
                  customRadioListTile(
                      InputType.UploadFile, 'Upload File', onChange),
                ],
              ),
            ),

            ///
            /// Editor Body
            ///
            JsonEditor(selectedIndex: selected)
          ],
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
                    child: Icon(CupertinoIcons.clear_thick_circled, color: defaultColorEditor,),
                  onTap: (){ Navigator.of(context).pop(); }
                ),
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
                onTap: () async{
                  if(toLocales.isNotEmpty){
                    await addUser();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DownloadPage(),));
                  }
                },
              ),
              Container(
                height: 30,
                child: Center(child: Text('Please select atleast one locale to proceed.', style: TextStyle(color: defaultColorEditor),)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCheckBoxListTile extends StatefulWidget {
  final int index;
  CustomCheckBoxListTile({@required this.index});

  @override
  _CustomCheckBoxListTileState createState() => _CustomCheckBoxListTileState();
}

class _CustomCheckBoxListTileState extends State<CustomCheckBoxListTile> with AutomaticKeepAliveClientMixin{
  bool check = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CheckboxListTile(
      activeColor: defaultColorEditor,
      title: Text(
        localesKeyList[widget.index] + ' ( ' + localesValueList[widget.index] + ' )',
        style: TextStyle(fontSize: 15, fontFamily: 'monospace', fontWeight: FontWeight.w500),
      ),
      value: check,
      onChanged: (value) async{
        value ? toLocales.add(localesValueList[widget.index]) : toLocales.removeWhere((element) => element == localesValueList[widget.index]);
        setState(() {
          check = value;
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
