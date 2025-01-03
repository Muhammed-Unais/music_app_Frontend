import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/core/theme/app_theme.dart';
import 'package:client/featues/auth/view/pages/signup_page.dart';
import 'package:client/featues/auth/view_model/auth_viewmodel.dart';
import 'package:client/featues/home/view/pages/upload_songs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewmodelProvider.notifier).initSharedPreferences();
  await container.read(authViewmodelProvider.notifier).getData();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Music app',
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const SignupPage() : const UploadSongsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
