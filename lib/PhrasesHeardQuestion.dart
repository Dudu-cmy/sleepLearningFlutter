import 'package:flutter/material.dart';

import 'ActivityDoingDuringSession.dart';
import 'Strings.dart';

// Define a custom Form widget.
class FirstPhrase extends StatefulWidget {
  final Map<String, dynamic> responses;
  final int i;
  final PageController p;

  const FirstPhrase(
      {Key? key, required this.responses, required this.i, required this.p})
      : super(key: key);

  @override
  _FirstPhrase createState() => _FirstPhrase();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _FirstPhrase extends State<FirstPhrase> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  var gender = "Male";
  final myController = TextEditingController();

  bool _validate = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  bool onWillPop() {
    if (widget.p.page?.round() == widget.p.initialPage)
      return true;
    else {
      widget.p.previousPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var responses = widget.responses;
    int n = int.parse(responses["numPhrases"]);
    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 100, bottom: 30),
                    child: Text(
                      "What was the " +
                          widget.i.toString() +
                          ordinal(widget.i) +
                          " English phrase you heard during this session?",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.white, filled: true),
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
                        color: Colors.white,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          gender = newValue!;
                        });
                      },
                      items: <String>['Male', 'Female']
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
                      print(gender);
                      var responses = widget.responses;
                      if (_validate) {
                        responses["englishPhrase" + widget.i.toString()] =
                            myController.text;
                        responses["englishPhrase" +
                            widget.i.toString() +
                            "Gender"] = gender.toString();

                        if (widget.i >= n) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ActivityDoingWhileInSessionActivity(
                                        responses: responses)),
                          );
                        } else {
                          widget.p.animateToPage(widget.i,
                              duration: Duration(milliseconds: 10),
                              curve: Curves.easeIn);
                        }
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
            ),
          )),
    );
  }
}

String ordinal(int number) {
  if (!(number >= 1 && number <= 100)) {
    //here you change the range
    throw Exception('Invalid number');
  }

  if (number >= 11 && number <= 13) {
    return 'th';
  }

  switch (number % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
