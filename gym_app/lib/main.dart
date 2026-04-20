import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/app/app.dart';
import 'package:gym_app/core/storage/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();

  runApp(const ProviderScope(child: GymApp()));
}
