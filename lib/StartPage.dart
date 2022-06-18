import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sleeplearning/SessionPage.dart';
import 'package:sleeplearning/SessionUtils.dart';
import 'package:sleeplearning/Strings.dart';

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isProcessing = false;
  bool isAllBatteryOptimizationDisabled = false;
  int initNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: isProcessing
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isProcessing = true;
                  });

                  isAllBatteryOptimizationDisabled =
                      (await DisableBatteryOptimization
                              .isBatteryOptimizationDisabled) ??
                          false;
                  if (isAllBatteryOptimizationDisabled || initNumber > 2) {
                    print("a");
                    User? user = FirebaseAuth.instance.currentUser;
                    CollectionReference users = FirebaseFirestore.instance
                        .collection(StringsConstant.SubjectCollection);
                    var data = await users.doc(user?.email).get();
                    try {
                      var s = await SessionUtils.getAudioDynamically(
                          data["language"].toString());

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              MainSessionPage(data: data, audioLinks: s),
                        ),
                      );
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg:
                              "Unknown Issue occured, please double check your internet connection and restart the app");
                    }
                    setState(() {
                      isProcessing = false;
                    });
                  } else {
                    initNumber += 1;
                    print("b");
                    setState(() {
                      isProcessing = false;
                    });

                    Fluttertoast.showToast(
                        msg:
                            "Please allow the app to skip battery optimization for seemless session");
                    DisableBatteryOptimization
                        .showDisableBatteryOptimizationSettings();
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: Text(
                  StringsConstant.StartSession,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 25, color: Colors.blue),
                ),
              ),
      ),
    );
  }
}
