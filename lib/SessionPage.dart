import 'dart:collection';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:sleeplearning/Strings.dart';
import 'package:volume_controller/volume_controller.dart';

import 'AudioPlayer/AudioPlayer.dart';
import 'Questionaire1.dart';
import 'SessionUtils.dart';
import 'main.dart';

// singleton.

class MainSessionPage extends StatefulWidget {
  final data;
  final List<String> audioLinks;

  const MainSessionPage({Key? key, this.data, required this.audioLinks})
      : super(key: key);

  @override
  _MainSessionPageState createState() => _MainSessionPageState();
}

class _MainSessionPageState extends State<MainSessionPage> {
  double numberOfPauses = 0;
  DateTime timeWhenpaused = DateTime.now();
  bool paused = false;
  User? user = FirebaseAuth.instance.currentUser;
  double volumeLevel = 0;
  double volumeListener = 0;
  bool isProcessing = false;

  // hash map to hold the user responses
  Map<String, dynamic> responses = HashMap();

  // Language userAssignedLanguage = Language.Mandarin;
  bool audio = false;

  Future<void> getLatestDocument() async {
    setState(() {
      isProcessing = true;
    });
    var time = DateFormat.yMMMMd('en_US').format(DateTime.now());
    print("kl");
    bool not = false;
    var audioFile = "";
    var lastSessionListeningPeriod = "";
    Random random = Random();
    int randomNumber = random.nextInt(widget.audioLinks.length);
    print(time);
    print("a");
    print(responses["userId"]);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print("a");
    await firestore
        .collection(responses["userId"].toString())
        .doc(time)
        .collection("Day")
        .get()
        .then((value) => {
              if (value.docs.isNotEmpty && value.docs.length > 0)
                {
                  value.docs.forEach((element) {
                    print(element.data());
                  }),
                  responses["timeForDay"] =
                      value.docs.last.data()["timeForDay"],
                  responses["audioFile"] = value.docs.last.data()["audioFile"],
                  responses["lastSessionListeningPeriod"] = value.docs.last
                      .data()["lastSessionListeningPeriod"]
                      .toString(),
                }
              else
                {
                  responses["timeForDay"] = 0,
                  print("whar "),
                  print(widget.audioLinks),
                  responses["audioFile"] = widget.audioLinks[randomNumber],
                  responses["lastSessionListeningPeriod"] = ""
                },
              lurl = responses["audioFile"],
              seeks = responses["lastSessionListeningPeriod"],
              print("aaassss"),
              setState(() {
                isProcessing = false;
              }),
              audioHandler.play(),
            });

    print("aa");
    /*await firestore.collection(responses["userId"]).doc(time).collection("Day").snapshots().last.then((value) => {
      print("helppp"),
      print(value),
      if (value.docs.isNotEmpty && value.docs.first.exists){
        print(value.docs.first.data()),
        print("aaa"),
        not = true,
        print(value.docs.last.data()),
       responses["timeForDay"]  = value.docs.first.data()["timeForDay"],
        responses["audioFile"] = value.docs.first.data()["audioFile"],
        responses["lastSessionListeningPeriod"] = value.docs.first.data()["lastSessionListeningPeriod"],

      }
      else {
        responses["timeForDay"] = 0,
        print("whar "),
        print(widget.audioLinks),
        responses["audioFile"] = widget.audioLinks[randomNumber] ,
        responses["lastSessionListeningPeriod"] = ""
      },



    }).catchError((e) => {print(e)}).whenComplete(() => {
      print("here a"),
      adu(responses["audioFile"], responses["lastSessionListeningPeriod"]).then((value) => {
        _audioHandler.play(),
      })
    }).onError((error, stackTrace) => {
      print("error"),
      print(error)
    });*/
  }

  void initialiseMap() {
    responses["numberOfPauses"] = 0;
    responses["timeForDay"] = 0;
    responses["volumes"] = <double>[];
    responses["timeForSession"] = 0;
    responses["timePaused"] = 0;
    responses["audioFile"] = "";
    responses["lastSessionListeningPeriod"] = "";
    responses["timeWhenStart"] = DateTime.now();
    responses["timesPressedContinue"] = <DateTime>[];
    responses["timesPressedPause"] = <DateTime>[];
    responses["timesRecordVolume"] = <DateTime>[];
    responses["userId"] = widget.data.data()["ID"];
    VolumeController().getVolume().then((volume) => {
          vol = volume.toString(),
          responses["volumes"].add(volume),
          responses["timesRecordVolume"].add(DateTime.now())
        });
  }

  var vol = "";

  @override
  void dispose() {
    print("disposing");
    audioHandler.stop();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialiseMap();
    firstRun = true;
    getLatestDocument();
    print("ibit");
    // Listen to system volume change
    VolumeController().listener((volume) {
      setState(() => {
            if (volume.toString() != vol)
              {
                responses["volumes"].add(volume),
                responses["timesRecordVolume"].add(DateTime.now()),
                vol = volume.toString()
              }
          });
    });
    print("dkdkdkd");
  }

  void onPressed() {
    setState(() {
      paused = !paused;
    });

    if (paused) {
      timeWhenpaused = DateTime.now();
      responses["timesPressedPause"].add(timeWhenpaused);
      responses["numberOfPauses"] = responses["numberOfPauses"] + 1;
      audioHandler.pause();
    } else {
      responses["timesPressedContinue"].add(DateTime.now());

      responses["timePaused"] = responses["timePaused"] +
          (DateTime.now().difference(timeWhenpaused).inSeconds);
      audioHandler.play();
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit the session?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  MoveToBackground.moveTaskToBack();
                },
                child: Text(
                  "Minimise App",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var l = widget.data.data() as Map<String, dynamic>;

    CollectionReference users = FirebaseFirestore.instance
        .collection(StringsConstant.SubjectCollection);
    String? userEmail = user?.email.toString();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: Colors.black,
          body: isProcessing
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: onPressed,
                        child: Text(
                            paused
                                ? StringsConstant.Continue
                                : StringsConstant.Pause,
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 25)),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Duration duration = bl.getCurrentDuration();
                        var s, d, e;
                        if (responses["lastSessionListeningPeriod"]
                            .isNotEmpty) {
                          Duration ldu = SessionUtils.parseDuration(seeks);
                          var t = duration - ldu;
                          s = t.inSeconds.abs();
                          print(duration);
                          d = responses["timeForDay"] + s;
                        } else {
                          s = duration.inSeconds.abs();
                          print(duration);

                          d = responses["timeForDay"] +
                              (1 * duration.inSeconds.abs());
                        }

                        print(responses);
                        //var y = g.getCurrentDuration();
                        print("aaaa");
                        int listening = 0;
                        listening = (d - 3600);
                        var b = (listening > 0)
                            ? intToTimeLeft((listening / 2).toInt())
                            : intToTimeLeft(0);
                        var list = listening < 0
                            ? intToTimeLeft((-1 * listening))
                            : intToTimeLeft(0);
                        audioHandler.pause();
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.INFO,
                          headerAnimationLoop: false,
                          title: 'Are you sure you want to stop the session?',
                          desc: "time format (h:m:s)\n\n" +
                              StringsConstant.minutesForSession +
                              ': ' +
                              intToTimeLeft(s.toInt()) +
                              "\n" +
                              StringsConstant.minutesForDay +
                              ': ' +
                              intToTimeLeft(d.toInt()) +
                              "\n Remaining listening period for the day: " +
                              list.toString() +
                              "\n Banked minutes: " +
                              b,
                          showCloseIcon: true,
                          btnCancelText: "No",
                          btnOkText: "Yes",
                          btnCancelOnPress: () {
                            audioHandler.play();
                          },
                          btnOkOnPress: () {
                            audioHandler.stop().then((value) => {
                                  responses["timeForDay"] = d,
                                  responses["timeForSession"] = s,
                                  responses["lastSessionListeningPeriod"] =
                                      y.toString(),
                                  print(y.toString()),
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => FirstQuestion(
                                        responses: responses,
                                      ),
                                    ),
                                  )
                                });
                          },
                        ).show();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      child: Text(StringsConstant.Stop,
                          style: const TextStyle(
                              color: Colors.orangeAccent, fontSize: 25)),
                    ),
                    //your elements here
                  ],
                )),
    );
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String result = "$h:$m:$s";

    return result;
  }
}
