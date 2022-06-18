import 'package:flutter/material.dart';

import 'IssueWithTheStream.dart';
import 'Strings.dart';

// Define a custom Form widget.
class ActivityDoingWhileInSessionActivity extends StatefulWidget {
  final Map<String, dynamic> responses;

  const ActivityDoingWhileInSessionActivity({Key? key, required this.responses})
      : super(key: key);

  @override
  _ActivityDoingWhileInSessionActivity createState() =>
      _ActivityDoingWhileInSessionActivity();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _ActivityDoingWhileInSessionActivity
    extends State<ActivityDoingWhileInSessionActivity> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  var gender = "Female";
  final myController = TextEditingController();
  final controller2 = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 100, bottom: 30),
                child: Text(
                  StringsConstant.activityDoingDuringSessionQuestion,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: TextField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "E.g. Workout"),
                  controller: myController,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () {
                  _validate = myController.text.isNotEmpty;
                  var responses = widget.responses;
                  if (_validate) {
                    responses["ActivityDuringSession"] = myController.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              IssueWithTheStream(responses: responses)),
                    );
                    print(gender);
                  } else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: const Text('Please enter a valid value'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text(
                  StringsConstant.Continue,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));
  }
}
