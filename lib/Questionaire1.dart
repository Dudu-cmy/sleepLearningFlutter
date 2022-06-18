import 'package:flutter/material.dart';
import 'package:sleeplearning/SecondQuestion.dart';
import 'package:sleeplearning/Strings.dart';

import 'ActivityDoingDuringSession.dart';

class FirstQuestion extends StatelessWidget {
  final Map<String, dynamic> responses;

  FirstQuestion({Key? key, required this.responses}) : super(key: key);

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
                StringsConstant.questionOne,
                style: TextStyle(color: Colors.white, fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {
                      responses["englishHeardYN"] = StringsConstant.yesButton;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SecondQuestion(responses: responses)),
                      );
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
                      responses["englishHeardYN"] = StringsConstant.noButton;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ActivityDoingWhileInSessionActivity(
                                    responses: responses)),
                      );
                    },
                    child: Text(
                      StringsConstant.noButton,
                      style: TextStyle(color: Colors.red, fontSize: 25),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
