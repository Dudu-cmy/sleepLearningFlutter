import 'package:audio_service/audio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleeplearning/InstructionPage.dart';
import 'package:sleeplearning/LoginPage.dart';

import 'AudioPlayer/AudioPlayer.dart';

var lurl = "";
var seeks = "";
var firstRun = true;
late AudioHandler audioHandler;
var bl = MyAudioHandler();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  audioHandler = await AudioService.init(
    builder: () => bl,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.cmu.sleeplearning.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: false,
      androidNotificationChannelDescription: "Text",
      androidNotificationClickStartsActivity: true,
      notificationColor: Colors.orangeAccent,
      androidShowNotificationBadge: true,
    ),
  );

  Firebase.initializeApp()
      .then((value) => {print(value)})
      .whenComplete(() => {runApp(const MyApp())});
}

Future<FirebaseApp> _initializeFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  return firebaseApp;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Sleep Learning App',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          backgroundColor: Colors.black),
      home: user == null ? LoginPage() : InstructionPage(),
    );
  }
}
