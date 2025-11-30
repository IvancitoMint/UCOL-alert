import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();

void playSuccess() async {
  await player.play(AssetSource("success.wav"));
}


void playError() async {
  await player.play(AssetSource("error.wav"));
}