import 'dart:developer';
import 'dart:io';
import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/featues/auth/repo/auth_local_repository.dart';
import 'package:client/featues/home/model/song_model.dart';
import 'package:client/featues/home/repositories/home_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r
  };
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepo _homeRepo;
  @override
  AsyncValue? build() {
    _homeRepo = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSongs({
    required File selctedSongFile,
    required File selectedThumbnailFile,
    required String artist,
    required String songName,
    required Color color,
  }) async {
    try {
      state = const AsyncValue.loading();
      final res = await _homeRepo.uploadSong(
        selectedSongFile: selctedSongFile,
        selectedThumbnailFile: selectedThumbnailFile,
        artist: artist,
        songName: songName,
        hexCode: rgbToHex(color),
        token: ref.watch(authLocalRepositoryProvider).getToken() ?? "",
      );

      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
        Right(value: final r) => state = AsyncValue.data(r)
      };

      log(val.toString());
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
