import 'package:client/core/models/user_model.dart';
import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/featues/auth/repo/auth_local_repository.dart';
import 'package:client/featues/auth/repo/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;
  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );

    final val = switch (res) {
      Left(value: final l) => AsyncValue<UserModel>.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => AsyncValue.data(r),
    };
    state = val;
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    final val = switch (res) {
      Left(value: final l) => AsyncValue<UserModel>.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => _loginSuccuss(r),
    };

    state = val;
  }

  AsyncValue<UserModel> _loginSuccuss(UserModel user) {
    _currentUserNotifier.adduser(user);
    _authLocalRepository.setToken(user.token);
    return AsyncValue.data(user);
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();
    if (token != null) {
      try {
        final res =
            await _authRemoteRepository.getCurrentUserData(token: token);

        final val = switch (res) {
          Left(value: final l) => state = AsyncValue.error(
              l.message,
              StackTrace.current,
            ),
          Right(value: final r) => _getDataSuccuss(r),
        };
        return val.value;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  AsyncValue<UserModel> _getDataSuccuss(UserModel user) {
    _currentUserNotifier.adduser(user);
    return state = AsyncValue.data(user);
  }
}
