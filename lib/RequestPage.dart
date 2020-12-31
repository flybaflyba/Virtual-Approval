import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/Request.dart';
import 'package:virtual_approval_flutter/SignIn.dart';
import 'package:virtual_approval_flutter/Universals.dart';
import 'package:flutter_picker/flutter_picker.dart';

class RequestPage extends StatefulWidget {
  RequestPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {

  var name = "";
  var email = "";
  var course = "";
  var question = "";

  TextEditingController courseTextEditingController = new TextEditingController();
  bool courseTextEditingEnable = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Universals.appBarColor,
        title: Text(widget.title),
      ),
      body:      ListView(
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.person), onPressed: null),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 10),
                    child: TextField(
                      onChanged: (value){
                         name = value;
                      },
                      decoration: InputDecoration(hintText: "Name"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.email), onPressed: null),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 10),
                    child: TextField(
                      onChanged: (value){
                         email = value;
                      },
                      decoration: InputDecoration(hintText: "Email"),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.menu_book), onPressed: null),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 10),
                    child:
                    TextField(
                      enabled: courseTextEditingEnable,
                      controller: courseTextEditingController,
                      onTap: () {
                        courseTextEditingEnable = false;
                        FocusScope.of(context).requestFocus(new FocusNode()); // do not show keyboard
                        // show course picker
                        Picker picker = Picker(
                          adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(Universals.courses)),
                          changeToFirst: false,
                          textAlign: TextAlign.left,
                          textStyle: const TextStyle(color: Colors.blue),
                          selectedTextStyle: TextStyle(color: Colors.red),
                          columnPadding: const EdgeInsets.all(8.0),
                          onConfirm: (Picker picker, List value) {
                            print(value.toString()); // index
                            print(picker.getSelectedValues()); // value
                            course = picker.getSelectedValues()[0] + " " + picker.getSelectedValues()[1];
                            print(course);
                            courseTextEditingController.text = course;
                            courseTextEditingEnable = true;
                          },
                          onCancel: () {
                            courseTextEditingEnable = true;
                          },
                        );
                        picker.show(_scaffoldKey.currentState);
                      },
                      decoration: InputDecoration(hintText: 'Course'),
                    ),


                  ),
                ),
              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.question_answer), onPressed: null),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 10),
                    child:
                    TextField(
                      minLines: 1,
                      maxLines: 100,
                      // textAlign: TextAlign.center,
                      onChanged: (value) {
                         question = value;
                      },
                      decoration: InputDecoration(hintText: 'Question'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 60,
                child: RaisedButton(
                  onPressed: () async {
                    print(name);
                    print(email);
                    print(course);
                    print(question);

                    Request request = new Request(name: name, email: email, course: course, question: question);
                    DatabaseInteractions.saveNewRequest(request);


                  },
                  color: Universals.buttonColor,
                  child: Text(
                    'Request Help',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ),

          Padding(
              padding: const EdgeInsets.all(5.0),
              child:
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn(),));
                },
                child: Text("Are you a TA?"),
              )

          ),
        ],

      )
    );
  }
}
