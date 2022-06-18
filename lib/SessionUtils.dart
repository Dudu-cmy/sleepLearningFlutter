import 'package:flutter/services.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class SessionUtils {
  static const String url =
      "https://storage.googleapis.com/sleep-learning-app/";

  static String getMandarinAudio() {
    // https://storage.googleapis.com/sleep-learning-app/audio-files/mandarin/Mandarin-10-part1_JS.m4a
    var titles = ["Mandarin-10-part1_JS.m4a"];
    return url + titles[0];
  }

  static String getArabicAudio() {
    return "https://storage.googleapis.com/sleep-learning-app/audio-files/arabic/Arabic-Q1-part1_MG.m4a";
  }

  static Duration parseDuration(String s) {
    print("aaa");
    print(s);
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  static Future<List<String>> getAudioDynamically(String language) async {
    String response = await rootBundle.loadString('Assets/test.json');
    //var json = new File('/Users/hubertdushime/AndroidStudioProjects/sleeplearning/Assets/test.json').readAsStringSync();
    var credentials = new auth.ServiceAccountCredentials.fromJson(response);
    // Get an HTTP authenticated client using the service account credentials.
    List<String> scopes = Storage.SCOPES;

    var client = await auth.clientViaServiceAccount(credentials, scopes);
    var storage = Storage(client, 'Sleep Learning');
    var bucket = await storage.bucket("sleep-learning-app");

    final mandarin = "audio-files/mandarin/";
    final arabic = "audio-files/arabic/";
    var a =
        bucket.list(prefix: language.contains('Mandarin') ? mandarin : arabic);
    var audioStreams = <String>[];
    await for (final i in a) {
      if (i.name != mandarin && i.name != arabic) {
        audioStreams.add(url + i.name);
      }
    }
    print("********");
    return audioStreams;
  }
}
