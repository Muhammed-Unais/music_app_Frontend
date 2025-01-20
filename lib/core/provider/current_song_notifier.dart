import 'package:client/featues/home/model/song_model.dart';
import 'package:client/featues/home/repositories/home_local_repository.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  HomeLocalRepository? _homeLocalRepository;

  AudioPlayer? get audioPlayer => _audioPlayer;

  @override
  (SongModel, bool)? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSong(SongModel song) async {
    _audioPlayer?.stop();
    _audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
      tag: MediaItem(
        id: song.id,
        title: song.song_name,
        artist: song.artist,
        artUri: Uri.parse(
          song.thumbnail_url,
        ),
      ),
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
    _homeLocalRepository?.uploadLocalSong(song);
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

  void seek(double value) {
    audioPlayer?.seek(
      Duration(
        milliseconds: (value * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }
}
