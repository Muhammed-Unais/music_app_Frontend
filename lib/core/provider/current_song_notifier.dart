import 'dart:developer';

import 'package:client/featues/home/model/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? _audioPlayer;
  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    _audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
    );
    await _audioPlayer?.setAudioSource(audioSource);
    await _audioPlayer?.play();

    state = song;
  }
}
