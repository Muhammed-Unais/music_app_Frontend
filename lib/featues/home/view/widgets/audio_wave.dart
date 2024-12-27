import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;

  const AudioWave({
    super.key,
    required this.path,
  });

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController _playerController = PlayerController();
  late ValueNotifier<PlayerState> valueNotifier;

  @override
  void initState() {
    initPlayer();
    valueNotifier = ValueNotifier(_playerController.playerState);
    super.initState();
  }

  Future<void> initPlayer() async {
    await _playerController.preparePlayer(path: widget.path);
  }

  void playAndPauseVideo() async {
    if (!_playerController.playerState.isPlaying) {
      await _playerController.startPlayer();
      _playerController.setFinishMode(finishMode: FinishMode.pause);
    } else if (!_playerController.playerState.isPaused) {
      await _playerController.pausePlayer();
    }
    valueNotifier.value = _playerController.playerState;
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder<PlayerState>(
          valueListenable: valueNotifier,
          builder: (context, value, _) {
            return IconButton(
              onPressed: playAndPauseVideo,
              icon: Icon(
                !value.isPlaying ? Icons.play_arrow : Icons.pause,
              ),
            );
          },
        ),
        Expanded(
          child: AudioFileWaveforms(
            size: const Size(double.infinity, 100),
            playerController: _playerController,
            playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: Pallete.borderColor,
              liveWaveColor: Pallete.gradient2,
              spacing: 7,
              showSeekLine: false,
            ),
          ),
        ),
      ],
    );
  }
}
