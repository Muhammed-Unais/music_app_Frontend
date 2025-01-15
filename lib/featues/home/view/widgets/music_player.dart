import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/featues/home/model/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({
    super.key,
    required this.currentSong,
  });

  final SongModel currentSong;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                "assets/images/pull-down-arrow.png",
                color: Pallete.whiteColor,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: _songThumbnailImage(),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  _songNameArtAndFavoriteButton(),
                  const SizedBox(height: 15),
                  _musicSlider(context),
                  const SizedBox(height: 15),
                  _musicControllers(),
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

  Row _musicControllers() {
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
          onPressed: () {},
          icon: const Icon(
            CupertinoIcons.play_circle_fill,
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

  Column _musicSlider(BuildContext context) {
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
            value: 0.5,
            onChanged: (value) {},
          ),
        ),
        const Row(
          children: [
            Text(
              '0:05',
              style: TextStyle(
                fontSize: 13,
                color: Pallete.subtitleText,
                fontWeight: FontWeight.w300,
              ),
            ),
            Expanded(child: SizedBox()),
            Text(
              '0:05',
              style: TextStyle(
                fontSize: 13,
                color: Pallete.subtitleText,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _songNameArtAndFavoriteButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentSong.song_name,
              style: const TextStyle(
                color: Pallete.whiteColor,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              currentSong.artist,
              style: const TextStyle(
                color: Pallete.subtitleText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            CupertinoIcons.heart,
            color: Pallete.whiteColor,
          ),
        )
      ],
    );
  }

  Widget _songThumbnailImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              currentSong.thumbnail_url,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
