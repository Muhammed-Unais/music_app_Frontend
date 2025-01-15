import 'package:client/featues/home/model/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;

  AudioPlayer? get audioPlayer => _audioPlayer;

  @override
  (SongModel, bool)? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    _audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
    );
    await _audioPlayer?.setAudioSource(audioSource);

    audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        _isPlaying = false;

        this.state = (this.state!.$1.copyWith(), _isPlaying);
      }
    });
    _audioPlayer?.play();

    _isPlaying = true;

    state = (song, _isPlaying);
  }

  void playPuaseSong() {
    if (_isPlaying) {
      _audioPlayer?.pause();
    } else {
      _audioPlayer?.play();
    }

    _isPlaying = !_isPlaying;

    state = (state!.$1, _isPlaying);
  }
}
