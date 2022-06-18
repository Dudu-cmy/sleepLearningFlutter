import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleeplearning/EnglishPhrasesHeard.dart';

import 'Strings.dart';

// Define a custom Form widget.
class SecondQuestion extends StatefulWidget {
  final Map<String, dynamic> responses;

  const SecondQuestion({Key? key, required this.responses}) : super(key: key);

  @override
  _SecondQuestionState createState() => _SecondQuestionState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SecondQuestionState extends State<SecondQuestion> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
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
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 100),
                child: Text(
                  StringsConstant.secondQuestion,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "0",
                      ),
                      controller: myController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      StringsConstant.phrases,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () {
                  _validate = myController.text.isNotEmpty;
                  if (_validate) {
                    var responses = widget.responses;

                    responses["numPhrases"] = myController.text;
                    var u = int.parse(myController.text);
                    if (u > 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EnglishPhrasesHeard(responses: responses)),
                      );
                    } else {
                      // TODO More validation

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
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      StringsConstant.back,
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
