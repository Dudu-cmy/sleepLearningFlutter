import 'package:flutter/material.dart';

import 'ActivityDoingDuringSession.dart';
import 'Strings.dart';

// Define a custom Form widget.
class ThirdPhrase extends StatefulWidget {
  final Map<String, dynamic> responses;

  const ThirdPhrase({Key? key, required this.responses}) : super(key: key);

  @override
  _ThirdPhrase createState() => _ThirdPhrase();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _ThirdPhrase extends State<ThirdPhrase> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  var gender = "Female";
  final myController = TextEditingController();
  bool _validate = true;

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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 15, right: 15, top: 100, bottom: 30),
                  child: Text(
                    StringsConstant.thirdEnglishPhrase,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: TextField(
                    decoration:
                        InputDecoration(fillColor: Colors.white, filled: true),
                    controller: myController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 15, right: 15, top: 100, bottom: 30),
                  child: Text(
                    StringsConstant.speakerGender,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton<String>(
                    value: gender,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        gender = newValue!;
                      });
                    },
                    items: <String>['Female', 'Male']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 30,
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
                      responses["englishPhrase3"] = myController.text;
                      responses["englishPhrase3Gender"] = gender.toString();
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ActivityDoingWhileInSessionActivity(
                                  responses: responses)),
                    );

                    /* else {
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
                    }*/
                  },
                  child: Text(
                    StringsConstant.Continue,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
