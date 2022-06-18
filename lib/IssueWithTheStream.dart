import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sleeplearning/Strings.dart';

import 'SessionStatistics.dart';

class IssueWithTheStream extends StatefulWidget {
  final Map<String, dynamic> responses;

  IssueWithTheStream({Key? key, required this.responses}) : super(key: key);

  @override
  State<IssueWithTheStream> createState() => _IssueWithTheStreamState();
}

class _IssueWithTheStreamState extends State<IssueWithTheStream> {
  final myController = TextEditingController();

  bool processing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                StringsConstant.issueWhileStreaming,
                style: TextStyle(color: Colors.white, fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            !processing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              processing = true;
                            });
                          },
                          child: Text(
                            StringsConstant.yesButton,
                            style: TextStyle(color: Colors.blue, fontSize: 25),
                          )),
                      SizedBox(width: 30),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          onPressed: () {
                            widget.responses["IssueWhileStreaming"] =
                                StringsConstant.noButton;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IssueWithTheApp(
                                      responses: widget.responses)),
                            );
                          },
                          child: Text(
                            StringsConstant.noButton,
                            style: TextStyle(color: Colors.red, fontSize: 25),
                          ))
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: TextField(
                          decoration: InputDecoration(
                              fillColor: Colors.white, filled: true),
                          controller: myController,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          bool _validate = myController.text.isNotEmpty;

                          var responses = widget.responses;
                          if (_validate) {
                            responses["IssueWhileStreaming"] =
                                myController.text.toString();
                            setState(() {
                              processing = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      IssueWithTheApp(responses: responses)),
                            );
                          } else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content:
                                    const Text('Please enter a valid entry'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
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
          ],
        ),
      ),
    );
  }
}

// Issue with the app

class IssueWithTheApp extends StatefulWidget {
  final Map<String, dynamic> responses;

  IssueWithTheApp({Key? key, required this.responses}) : super(key: key);

  @override
  State<IssueWithTheApp> createState() => _IssueWithTheAppState();
}

class _IssueWithTheAppState extends State<IssueWithTheApp> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isProcessing = false;
  bool pressed = false;

  void add(BuildContext context, Map<String, dynamic> responses) {
    initializeDateFormatting();
    print("here");
    var time = DateFormat.yMMMMd('en_US').format(DateTime.now());
    print("kl");

    var doc = responses["audioFile"].split("/");
    var l = doc[doc.length - 1].toString();
    firestore
        .collection("eventFiles")
        .doc(l.split(".")[0])
        .get()
        .then((value) => {
              print(value.data().toString()),
              print(l.split(".")),
              value.data()?.forEach((key, value) {
                print(value);
                print("()()(");
                responses[key] = value;
              })
            })
        .whenComplete(() => {
              firestore
                  .collection(widget.responses["userId"])
                  .doc(time)
                  .collection("Day")
                  .doc(DateTime.now().toString())
                  .set(responses)
                  .then((value) => {
                        print("Finished adding data"),
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    Statistics(responses: responses)),
                            (Route<dynamic> route) => false)
                      })
                  .catchError((e) => {
                        print(e),
                        print("aaaa"),
                        Fluttertoast.showToast(
                          msg: "Please check your internet connection.",
                        )
                      })
            });

    print(responses);
    setState(() {
      _isProcessing = false;
    });
  }

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var responses = widget.responses;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isProcessing
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      StringsConstant.issueWithTheApp,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  !pressed
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                onPressed: () {
                                  setState(() {
                                    pressed = true;
                                  });
                                },
                                child: Text(
                                  StringsConstant.yesButton,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 25),
                                )),
                            SizedBox(width: 30),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                onPressed: () {
                                  responses["IssueWithTheApp"] = "No";
                                  setState(() {
                                    _isProcessing = true;
                                  });
                                  //    print(widget.responses);
                                  add(context, responses);
                                },
                                child: Text(
                                  StringsConstant.noButton,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 25),
                                ))
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: TextField(
                                decoration: InputDecoration(
                                    fillColor: Colors.white, filled: true),
                                controller: myController,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: () {
                                bool _validate = myController.text.isNotEmpty;

                                var responses = widget.responses;
                                if (_validate) {
                                  setState(() {
                                    _isProcessing = true;
                                  });
                                  responses["IssueWithTheApp"] =
                                      myController.text.toString();
                                  //    print(widget.responses);
                                  add(context, responses);
                                } else {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      content: const Text(
                                          'Please enter a valid entry'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                StringsConstant.Continue,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                ],
              ),
      ),
    );
  }
}
