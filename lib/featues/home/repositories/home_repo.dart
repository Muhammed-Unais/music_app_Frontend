import 'dart:developer';
import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repo.g.dart';

@riverpod
HomeRepo homeRepository(Ref ref) {
  return HomeRepo();
}

class HomeRepo {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedSongFile,
    required File selectedThumbnailFile,
    required String artist,
    required String songName,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${ServerConstant.serverURL}/song/upload"),
      );

      request
        ..files.addAll(
          [
            await http.MultipartFile.fromPath('song', selectedSongFile.path),
            await http.MultipartFile.fromPath(
                'thumbnail', selectedThumbnailFile.path),
          ],
        )
        ..fields.addAll({
          'artist': artist,
          'song_name': songName,
          'hex_code': hexCode,
        })
        ..headers.addAll(
          {'x-auth-token': token},
        );

      final res = await request.send();

      if (res.statusCode != 201) {
        log(res.statusCode.toString());
        return Left(AppFailure(await res.stream.bytesToString()));
      }

      return Right(await res.stream.bytesToString());
    } catch (e) {
      log(e.toString());
      return Left(AppFailure(e.toString()));
    }
  }
}
