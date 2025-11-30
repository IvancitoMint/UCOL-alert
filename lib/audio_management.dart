import 'package:audioplayers/audioplayers.dart';

void playSuccess() async {
  await AudioPlayer().play(AssetSource("success.wav"));
}


void playError() async {
  await AudioPlayer().play(AssetSource("error.wav"));
}