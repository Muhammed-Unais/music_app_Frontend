import 'dart:developer';

import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/featues/home/model/song_model.dart';
import 'package:client/featues/home/view_model/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSongNotifier = ref.read(currentSongNotifierProvider.notifier);
    final currentSongValues = ref.watch(currentSongNotifierProvider);
    final currentSong = currentSongValues!.$1;
    final isPlaying = currentSongValues.$2;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            hexToColor(currentSong.hex_code),
            const Color(0xff121212),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              highlightColor: Pallete.transparentColor,
              focusColor: Pallete.transparentColor,
              splashColor: Pallete.transparentColor,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/pull-down-arrow.png",
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: _songThumbnailImage(currentSong),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  _songNameArtAndFavoriteButton(currentSong, ref),
                  const SizedBox(height: 15),
                  _musicSlider(context, currentSongNotifier),
                  const SizedBox(height: 15),
                  _musicControllers(
                    currentSongNotifier: currentSongNotifier,
                    isPlaying: isPlaying,
                  ),
                  const SizedBox(height: 25),
                  _conncectDeviceAndPlayListWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _conncectDeviceAndPlayListWidget() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            "assets/images/connect-device.png",
            color: Pallete.whiteColor,
          ),
        ),
        const Expanded(child: SizedBox()),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            "assets/images/playlist.png",
            color: Pallete.whiteColor,
          ),
        ),
      ],
    );
  }

  Row _musicControllers({
    required CurrentSongNotifier currentSongNotifier,
    required bool isPlaying,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _songControllIconWidget(
          image: "assets/images/shuffle.png",
          onTap: () {},
        ),
        _songControllIconWidget(
          image: "assets/images/previus-song.png",
          onTap: () {},
        ),
        IconButton(
          onPressed: currentSongNotifier.playPuaseSong,
          icon: Icon(
            isPlaying
                ? CupertinoIcons.pause_circle_fill
                : CupertinoIcons.play_circle_fill,
          ),
          iconSize: 80,
          color: Pallete.whiteColor,
        ),
        _songControllIconWidget(
          image: "assets/images/next-song.png",
          onTap: () {},
        ),
        _songControllIconWidget(
          image: "assets/images/repeat.png",
          onTap: () {},
        ),
      ],
    );
  }

  GestureDetector _songControllIconWidget({
    required String image,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(
          image,
          color: Pallete.whiteColor,
        ),
      ),
    );
  }

  Widget _musicSlider(
    BuildContext context,
    CurrentSongNotifier currentSongNotifier,
  ) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      log("Rebuilding");
      return StreamBuilder(
        stream: currentSongNotifier.audioPlayer?.positionStream,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }

          final position = snapShot.data;
          final duration = currentSongNotifier.audioPlayer?.duration;
          double sliderValue = 0.0;
          if (position != null && duration != null) {
            sliderValue = position.inMilliseconds / duration.inMilliseconds;
          }
          return Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Pallete.whiteColor,
                  inactiveTrackColor: Pallete.whiteColor.withOpacity(.117),
                  thumbColor: Pallete.whiteColor,
                  trackHeight: 4,
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: sliderValue,
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                    });
                  },
                  onChangeEnd: currentSongNotifier.seek,
                ),
              ),
              Row(
                children: [
                  Text(
                    "${position?.inMinutes ?? ''}:${(position?.inSeconds ?? 0) > 10 ? position?.inSeconds : "0${position?.inSeconds}"}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Pallete.subtitleText,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    "${duration?.inMinutes ?? ''}:${(duration?.inSeconds ?? 0) > 10 ? duration?.inSeconds : "0${duration?.inSeconds}"}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Pallete.subtitleText,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              )
            ],
          );
        },
      );
    });
  }

  Widget _songNameArtAndFavoriteButton(SongModel? currentSong, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentSong?.song_name ?? '',
              style: const TextStyle(
                color: Pallete.whiteColor,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              currentSong?.artist ?? '',
              style: const TextStyle(
                color: Pallete.subtitleText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            await ref.read(homeViewmodelProvider.notifier).favoriteSong(
                  songId: currentSong?.id ?? '',
                );
          },
          icon: const Icon(
            CupertinoIcons.heart,
            color: Pallete.whiteColor,
          ),
        )
      ],
    );
  }

  Widget _songThumbnailImage(SongModel? currentSong) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Hero(
        tag: 'music-image',
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                currentSong?.thumbnail_url ?? '',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
