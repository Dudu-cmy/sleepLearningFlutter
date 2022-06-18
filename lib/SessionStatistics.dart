import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sleeplearning/Strings.dart';

import 'LoginPage.dart';
import 'StartPage.dart';

class Statistics extends StatelessWidget {
  final Map<String, dynamic> responses;

  Statistics({Key? key, required this.responses}) : super(key: key);
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Future logout() async {
      await auth.signOut().then((value) => Navigator.of(context)
          .pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false));
    }

    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              StringsConstant.sessionCompleted,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            Text(
              StringsConstant.minutesForDay,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (responses["timeForDay"] / 60).toInt().toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
                SizedBox(width: 20),
                Text(
                  StringsConstant.min,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
              ],
            ),
            Text(
              StringsConstant.minutesForSession,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (responses["timeForSession"] / 60).toInt().toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
                SizedBox(width: 20),
                Text(
                  StringsConstant.min,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => StartPage()),
                    (Route<dynamic> route) => false);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Text(
                StringsConstant.startANewSession,
                style: TextStyle(fontSize: 25, color: Colors.blue),
              ),
            ),
            /* ElevatedButton(
            onPressed: () {

              logout();



            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            child: Text(
            "Log out",
              style: TextStyle(fontSize: 25, color: Colors.white70),
            ),
          ),*/
          ],
        ));
  }
}
