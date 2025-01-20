import 'dart:developer';

import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/featues/home/view/widgets/music_player.dart';
import 'package:client/featues/home/view_model/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSongNotifier = ref.watch(currentSongNotifierProvider);
    final currentSongNotifierRead =
        ref.read(currentSongNotifierProvider.notifier);
    final currentSong = currentSongNotifier?.$1;
    final isPlaying = currentSongNotifier?.$2;

    final userFavorites = ref.watch(currentUserNotifierProvider.select(
      (value) => value?.favorites,
    ));

    if (currentSong == null) return const SizedBox();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const MusicPlayer();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final tween = Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).chain(
                CurveTween(
                  curve: Curves.easeIn,
                ),
              );

              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 66,
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
              color: hexToColor(currentSong.hex_code),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'music-image',
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: NetworkImage(currentSong.thumbnail_url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentSong.song_name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currentSong.artist,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Pallete.subtitleText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(homeViewmodelProvider.notifier)
                            .favoriteSong(
                              songId: currentSong.id,
                            );
                      },
                      icon: userFavorites
                                  ?.where((favSong) =>
                                      favSong.song_id == currentSong.id)
                                  .isEmpty ==
                              true
                          ? const Icon(CupertinoIcons.heart)
                          : const Icon(CupertinoIcons.heart_fill),
                    ),
                    IconButton(
                      onPressed: currentSongNotifierRead.playPuaseSong,
                      icon: Icon(
                        isPlaying == true
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: currentSongNotifierRead.audioPlayer?.positionStream,
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              final position = snapShot.data;
              final duration = currentSongNotifierRead.audioPlayer?.duration;
              double silderValue = 0.0;
              if (position != null && duration != null) {
                silderValue = position.inMilliseconds / duration.inMilliseconds;
              }
              return Positioned(
                bottom: 0,
                left: 10,
                child: Container(
                  height: 4,
                  width: silderValue * (MediaQuery.of(context).size.width - 32),
                  decoration: BoxDecoration(
                    color: Pallete.whiteColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 10,
            child: Container(
              height: 4,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                color: Pallete.inactiveSeekColor,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
