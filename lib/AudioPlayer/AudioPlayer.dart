import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../SessionUtils.dart';
import '../main.dart';

var y;

class MyAudioHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  // mix in default seek callback implementations

  var _player;
  String l = "";
  String lp = "";
  String audioFile = "";

  MyAudioHandler() {
    /* if (seek.isNotEmpty){

      Duration duration = SessionUtils.parseDuration(seek);
      print(duration);
      _player.setAudioSource(AudioSource.uri(Uri.parse(language)), initialPosition: duration);

    }
    else {
      _player.setUrl(language);
    }*/
  }

  // The most common callbacks:
  @override
  Future<void> play() async {
    print("here");
    print(firstRun);
    print("aaaaa");
    if (firstRun) {
      _player = AudioPlayer();
      firstRun = false;
      if (seeks.isNotEmpty) {
        print("false" + seeks);
        Duration duration = SessionUtils.parseDuration(seeks);
        print(duration);
        _player.setAudioSource(AudioSource.uri(Uri.parse(lurl)),
            initialPosition: duration);
      } else {
        print("true");
        _player.setUrl(lurl);
      }
    }
    _player.toString();
    print("rinnn");

    _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    y = _player.position;
    await _player.dispose();
    return super.stop();
  }

  Future<void> seek(Duration position) async {}

  Future<void> skipToQueueItem(int i) async {}

  Duration getCurrentDuration() {
    return _player.position;
  }

  void setAudioFile(String a, String b) {
    l = a;
    lp = b;
  }
}
